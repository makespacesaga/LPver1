$ErrorActionPreference = "Stop"
$apiKey = (Get-Content (Join-Path $PSScriptRoot ".env") -Encoding UTF8) -replace "gemini_apikey=",""
$outputDir = Join-Path $PSScriptRoot "image"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image-preview:generateContent?key=$apiKey"

function Generate-Image {
    param($label, $prompt, $filename)
    Write-Host "[$label] Generating..." -ForegroundColor Cyan
    $escaped = $prompt.Replace('\','\\').Replace('"','\"')
    $body = '{"contents":[{"parts":[{"text":"' + $escaped + '"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}'
    try {
        $res = Invoke-RestMethod -Uri $url -Method POST -ContentType "application/json; charset=utf-8" -Body ([System.Text.Encoding]::UTF8.GetBytes($body))
        $part = $res.candidates[0].content.parts | Where-Object { $_.inlineData }
        $bytes = [Convert]::FromBase64String($part.inlineData.data)
        $path = Join-Path $outputDir $filename
        [IO.File]::WriteAllBytes($path, $bytes)
        Write-Host "[$label] Saved: $path" -ForegroundColor Green
    } catch {
        Write-Host "[$label] Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message -ForegroundColor Yellow }
    }
}

Generate-Image "floating icon" "A minimalist flat icon of a gold weighing scale with a small downward arrow indicating weight loss, centered on a warm white background. Clean, premium, elegant. Perfectly centered. Square 1:1. No text, no watermarks." "icon_result.png"
Write-Host "Done." -ForegroundColor Green
