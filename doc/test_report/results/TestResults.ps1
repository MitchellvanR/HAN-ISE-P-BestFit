$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$testResultDest = $currentDir + "\test_results.csv"

$DB_USER="LOG_BEST_FIT_ADMIN"
$DB_PASSWORD="BestFitAdminExamplePassword0?"
$DB="Test_BestFit"

sqlcmd -S localhost -U $DB_USER -P $DB_PASSWORD -d $DB -Q "EXEC [tSQLt].[RunAll]"

New-Item -ItemType File -Force -Path $testResultDest
sqlcmd -S localhost -U $DB_USER -P $DB_PASSWORD -d $DB -Q "SELECT t.Class, t.TestCase, t.Result, t.Msg FROM [tSQLt].[TestResult] t" -o $testResultDest -s"," -w 4000