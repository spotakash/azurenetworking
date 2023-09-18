# PowerShell Script to Validate Connectivity from Source Server which is to be managed by Azure Arc
# Guidance is to run atleast 3-4 different Server from different type network so that proper validation can be done
# Once Result Comes out, chose right deployment method describe here https://learn.microsoft.com/en-us/azure/azure-arc/servers/plan-at-scale-deployment#phase-2-deploy-azure-arc-enabled-servers

# Name: Azure Arc Deployment Secured Internet Connectivity Analyzer
# v0.1
# Author: Akash Kumar
# Date: 18-09-2023

# Ensure Execution Policy is Unrestricted
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Define the list of URLs and their corresponding test explanations
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$REGION #(e.g., southeastasia, eastasia, westus, etc.)
)
$urls = @(
    # One Time (MUST)
    @{
        URL = "aka.ms"
        Explanation = "One Time (MUST) - For Arc Agent Script Download"
    },
    @{
        URL = "download.microsoft.com"
        Explanation = "One Time (MUST) - For Arc Windows Agent Download"
    },
    @{
        URL = "packages.microsoft.com"
        Explanation = "One Time (MUST) - For Arc Linux Agent Download"
    },

    # Always (MUST)
    @{
        URL = "login.windows.net"
        Explanation = "Always (MUST) - For AzureAD Authentication"
    },
    @{
        URL = "login.microsoftonline.com"
        Explanation = "Always (MUST) - For AzureAD Authentication"
    },
    @{
        URL = "pas.windows.net"
        Explanation = "Always (MUST) - For AzureAD Authentication"
    },
    @{
        URL = "guestnotificationservice.azure.com"
        Explanation = "Always (MUST) - For Extension management and guest configuration services"
    },
    @{
        URL = "azgn*.servicebus.windows.net"
        Explanation = "Always (MUST) - For Notification service for extension and connectivity"
    },

    # Always (MUST) - Azure ARM (if false, use private endpoint)
    @{
        URL = "management.azure.com"
        Explanation = "Always (MUST) - Azure ARM (if false, use private endpoint)"
    },

    # Optional (To use SSH or Windows Admin Center from Azure)
    @{
        URL = "*.servicebus.windows.net"
        Explanation = "Always (MUST) - For Notification service for extension and connectivity scenarios"
    },

    # Always (MUST) - Azure Storage (if false, use private endpoint)
    @{
        URL = "*.blob.core.windows.net"
        Explanation = "Always (MUST) - Azure Storage (if false, expected to have Private Link Setup)"
    },
    
    # Always (MUST) - Azure Arc Enable SQL Server
    @{
        URL = "san-af-$REGION-prod.azurewebsites.net"
        Explanation = "Always (MUST) - Azure Arc Enable SQL Server (If using, Azure Extension for SQL Server)"
    },

    # Optional, not used in agent versions 1.24+
    @{
        URL = "dc.services.visualstudio.com"
        Explanation = "Optional - Not used in agent versions 1.24+"
    },

    # Optional (To use Windows Admin Center)
    @{
        URL = "*.waconazure.com"
        Explanation = "Optional - To use Windows Admin Center"
    }
)

# Initialize an array to store the results
$results = @()

# Loop through the URLs and test connectivity
foreach ($urlInfo in $urls) {
    $url = $urlInfo.URL
    $explanation = $urlInfo.Explanation

    if (($url -like "azgn*.servicebus.windows.net") -or ($url -like "*.servicebus.windows.net")) {
        # Use Invoke-RestMethod with a GET request to check connectivity for all matching URLs
        try {
            $response = Invoke-RestMethod -Uri "https://guestnotificationservice.azure.com/urls/allowlist?api-version=2020-01-01&location=$REGION" -Method Get -UseBasicParsing -TimeoutSec 10
            $isConnected = $true
        } catch {
            $isConnected = $false
        }
    } else {
        # For other URLs, use the regular connectivity check
        $result = Test-NetConnection -ComputerName $url -Port 443

        # Determine if the connection is successful
        $isConnected = $result.TcpTestSucceeded
    }

    # Create a custom object for the result
    $resultObj = [PSCustomObject]@{
        URL = $url
        Explanation = $explanation
        Result = $isConnected
    }

    # Add the result object to the results array
    $results += $resultObj
}

# Display the results in a table
$results | Format-Table -AutoSize

# Explanation of URL
Write-Host "For more explanation about these URLs, review this URL https://learn.microsoft.com/en-us/azure/azure-arc/servers/network-requirements?tabs=azure-cloud#urls"

# Ask the user if they want to export the results to a CSV file
$exportChoice = Read-Host "Do you want to export the results to a CSV file? (Y/N)"

if ($exportChoice -eq "Y" -or $exportChoice -eq "y") {
    $csvFileName = "ConnectivityResults.csv"
    $results | Export-Csv -Path $csvFileName -NoTypeInformation
    Write-Host "Results exported to $csvFileName."
} else {
    Write-Host "Results not exported."
}
