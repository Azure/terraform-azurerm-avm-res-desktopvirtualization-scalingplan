$ErrorActionPreference = 'Stop'

if ($env:GITHUB_ACTIONS -ne 'true' -or $env:GITHUB_JOB -ne 'e2e-test') {
    return
}

if ([string]::IsNullOrWhiteSpace($env:ARM_SUBSCRIPTION_ID) -or [string]::IsNullOrWhiteSpace($env:TEST_SUBSCRIPTION_IDS)) {
    throw 'The scaling plan E2E role assignment requires a configured test subscription.'
}

$testSubscriptions = @($env:TEST_SUBSCRIPTION_IDS | ConvertFrom-Json)
if ($env:ARM_SUBSCRIPTION_ID -notin @($testSubscriptions | ForEach-Object { [string]$_.id })) {
    throw 'The selected subscription is not a configured test subscription.'
}

$variableFile = Join-Path $PSScriptRoot 'ci.test-only.auto.tfvars'
if (Test-Path -LiteralPath $variableFile) {
    throw 'Refusing to overwrite an existing CI variable file.'
}

[System.IO.File]::WriteAllText($variableFile, "create_role_assignment = true`n", [System.Text.UTF8Encoding]::new($false))
