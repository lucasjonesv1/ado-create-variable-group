## A simple script to create a variable group for your ADO project pipelines

To run this script you will need to pass various parameters in order to create the variable group. These are outline below.

| Variable          | Description |
| -----------       | ----------- |
| pat               | A personal access token with access to read, write and update pipeline variable groups |
| org_name          | The URL of the organisation that your target project is in |
| group_name        | The desired name of the group that you want to create |
| project_name      | The name of the project you want to create the group in |
| create            | A flag for debugging, set to 1 to create the group |