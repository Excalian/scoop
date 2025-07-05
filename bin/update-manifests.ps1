$manifests = Get-ChildItem -Path .\bucket -Filter *.json -Recurse

$failed = @()
$updated = @()

foreach ($manifest in $manifests) {
    Write-Output "Checking $($manifest.Name)..."
    try {
        scoop checkver $manifest.FullName
        scoop update $manifest.BaseName
        $updated += $manifest.Name
    } catch {
        Write-Warning "Failed to update $($manifest.Name): $_"
        $failed += $manifest.Name
    }
}

if ($failed.Count -gt 0) {
    Write-Error "Failed to update the following manifests: $($failed -join ', ')"
    exit 1  # Causes workflow step to fail
}

if ($updated.Count -eq 0) {
    Write-Output "No manifests were updated."
} else {
    Write-Output "Updated manifests: $($updated -join ', ')"
}
