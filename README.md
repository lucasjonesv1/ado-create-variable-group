## A simple script to create a variable group for your ADO project pipelines

To run this script, you will need to have a PAT token with access to read and create variable groups in the desired organisation and project.

You will also need a JSON file with the following structure:

    {
        "org_name": "https://dev.azure.com/ExampleOrgName",
        "project_name": "Example Project Name",
        "groups": [
            {
                "name": "Example Group Name 1",
                "desired_variables": {
                    "subscriptionId": "12345a1b-1cd2-1ef2-123g-1h234556i07j",
                    "subscriptionName": "EXAMPLE-SUBSCRIPTION-NAME-1",
                    "keyvault_whitelist": "false",
                    "tf_version": "1.4.6",
                    "tfstate_whitelist": "true",
                    "RunTFSec": "true"
                }
            },
            {
                "name": "Example Group Name 2",
                "desired_variables": {
                    "subscriptionId": "12345a1b-1cd2-1ef2-123g-1h234556i07j",
                    "subscriptionName": "EXAMPLE-SUBSCRIPTION-NAME-2",
                    "keyvault_whitelist": "false",
                    "tf_version": "1.4.6",
                    "tfstate_whitelist": "true",
                    "RunTFSec": "true"
                }
            }
        ]
    }

There can be any number of groups, with any number of `desired_variables` within.

The script will log in to the given ADO organisation using the provided PAT token. It will use the `org_name` and `project_name` keys from the json to do this. It will then create the groups, additionally it will iterate through the `desired_variables` object and create a variable for each entry, using the key and value.