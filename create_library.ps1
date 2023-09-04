param(
    [String]$pat,
    [String]$org_name,
    [String]$group_name,
    [String]$project_name,
    [Int32]$create = 0
)

try {
    # Log in to az cli using pat
    Write-Output $pat | az devops login --organization $org_name
    Write-Host "az cli login succeeded" -ForegroundColor Green
}
catch {
    Write-Host "az cli login failed!" -ForegroundColor Red
}

# Create an array from a list of all groups in projects
$groups = az pipelines variable-group list --project $project_name | ConvertFrom-Json
$group_list = @()

foreach ($group in $groups) {
    $group_list.Add($group.name)
}

# Check if group already exists, error if it does
if ($group_list.Contains($group_name)) {
    Write-Host "Group already exists, please choose another name." -ForegroundColor Red
}

else {
    if ($create -eq 1) {
        Write-Host "Create flag set to true, creating group now." -ForegroundColor Yellow
        az pipelines variable-group create --name $group_name --variables environment=$($project_name.ToLower()) --organization $org_name --project $project_name
    }
    elseif ($create -ne 1) {
        Write-Host "Create flag set to false, not creating group." -ForegroundColor Yellow
    }
}