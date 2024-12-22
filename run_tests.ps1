# run_tests.ps1
$logFile = "test_results.log"

# Clear previous log file
if (Test-Path $logFile) {
    Remove-Item $logFile
}

# Run Flutter tests and capture output
Write-Output "Running Flutter tests at $(Get-Date)" | Tee-Object -FilePath $logFile -Append
flutter test --coverage | Tee-Object -FilePath $logFile -Append

# If tests fail, note in log
if ($LASTEXITCODE -ne 0) {
    Write-Output "Tests failed with exit code $LASTEXITCODE" | Tee-Object -FilePath $logFile -Append
} else {
    Write-Output "All tests passed successfully" | Tee-Object -FilePath $logFile -Append
}

Write-Output "Test run completed at $(Get-Date)" | Tee-Object -FilePath $logFile -Append