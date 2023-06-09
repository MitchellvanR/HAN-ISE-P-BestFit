$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$baseDir = $currentDir + "\bin"
$coverageOutputDir = $currentDir + "\results"

$database = "Test_BestFit"
$server = "localhost"
$user = "LOG_BEST_FIT_ADMIN"
$password = "BestFitAdminExamplePassword0?"

Remove-Item "$coverageOutputDir\*" -Recurse -Force
. "$baseDir\SQLCover.ps1" 
$results = Get-CoverTSql  "$baseDir\SQLCover.dll"  "server=$server;initial catalog=$database;UID=$user;PWD=$password;TrustServerCertificate=true" "$database" "EXEC [tSQLt].[RunAll]"
New-Item -ItemType Directory -Force -Path $coverageOutputDir
Export-Html $results  $coverageOutputDir