# Generate CTA button icons via Gemini 3.1 Flash Image
$ErrorActionPreference = "Stop"

$apiKey = (Get-Content (Join-Path $PSScriptRoot ".env") -Encoding UTF8) -replace "gemini_apikey=",""
$outputDir = Join-Path $PSScriptRoot "image"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }
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

# カウンセリング予約ボタンアイコン
Generate-Image "icon counseling" "A simple flat icon of a white elegant open calendar with a small gold star sparkle on a deep rose red background. Minimal, clean, modern. Perfectly centered. Square 1:1. No text, no watermarks." "icon_counseling.png"
Start-Sleep -Seconds 15

# LINE相談ボタンアイコン
Generate-Image "icon line" "A simple flat icon of a white elegant speech bubble with a small white heart inside on a vivid green background. Minimal, clean, modern. Perfectly centered. Square 1:1. No text, no watermarks." "icon_line.png"

Write-Host ""
Write-Host "All CTA icons generated." -ForegroundColor Green
