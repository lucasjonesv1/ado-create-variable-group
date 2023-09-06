param(
    [String]$pat,
    [Int32]$create = 0
)

$ErrorActionPreference = 'Stop'

# Import JSON to PS object, create org and project names
$service_request_input = Get-Content -Raw -Path test.json | ConvertFrom-Json
$org_name = $service_request_input.org_name
$project_name = $service_request_input.project_name

Write-Output $pat | az devops login --organization $org_name
if (!$?) {
    Write-Host "Error logging in" -ForegroundColor Red
    Exit
}
else {
    Write-Host "az cli login succeeded" -ForegroundColor Green
}

# Create an array from a list of all groups in projects
$group_list = @()
foreach ($group in az pipelines variable-group list --project $project_name | ConvertFrom-Json) {
    $group_list += $group.name
}

foreach ($group_to_create in $service_request_input.groups) {
    if ($group_list.Contains($group_to_create.name)) {
        Write-Host "Error: Library $($group_to_create.name) already exists, please use another name." -ForegroundColor Red

        foreach ($variable in $group_to_create.desired_variables.PSObject.Properties) {
            Write-Host "Would have created variable $($variable.Name) with value $($variable.Value)" -ForegroundColor DarkYellow
        }
    }
    else {
        if ($create -eq 1) {
            Write-Host ("Create flag set to true, creating group {0} now" -f $group_to_create.name) -ForegroundColor Green
            $created_group = az pipelines variable-group create --name $group_to_create.name --variables project-name=$($project_name.ToUpper()) --organization $org_name --project $project_name | ConvertFrom-Json

            foreach ($variable in $group_to_create.desired_variables.PSObject.Properties) {
                Write-Host "Creating variable $($variable.Name) with value $($variable.Value)" -ForegroundColor Green
                az pipelines variable-group variable create --group-id $created_group.Id --name $variable.Name --value $variable.Value --organization $org_name --project $project_name --output none
            }
        }
        elseif ($create -ne 1) {
            Write-Host ("Create flag set to false, not creating group {0}" -f $group_to_create.name) -ForegroundColor Red

            foreach ($variable in $group_to_create.desired_variables.PSObject.Properties) {
                Write-Host "Would have created variable $($variable.Name) with value $($variable.Value)" -ForegroundColor DarkYellow
            }
        }
    }
}