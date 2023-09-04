param(
    [String]$pat,
    [String]$org_name,
    [String]$group_name,
    [String]$project_name,
    [Int32]$create = 0
)

function ado_log_in {
    try {
        # Log in to az cli using pat
        Write-Output $pat | az devops login --organization $org_name
        Write-Host "az cli login succeeded" -ForegroundColor Green
    }
    catch {
        Write-Host "az cli login failed!" -ForegroundColor Red
    }   
}

function list_variable_groups {
    # A list of all groups in the chosen project
    $groups = az pipelines variable-group list --project $project_name | ConvertFrom-Json
    $group_list = @()

    # Create list of groups, to check one doesn't already exist
    foreach ($group in $groups) {
        $group_list.Add($group.name)
    }

    return $group_list
}

function create_variable_group {
    param([array]$group_list)

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
}

ado_log_in
list_variable_groups
create_variable_group($group_list)