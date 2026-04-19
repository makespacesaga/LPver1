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

# ゴールド用チェックアイコン（price-features / check-list）
Generate-Image "check gold" "A single minimalist flat icon of a small elegant gold diamond rhombus shape, perfectly centered on a pure white background. Clean, sharp edges, premium and feminine. Square 1:1. No text, no shadows, no watermarks." "icon_check_gold.png"
Start-Sleep -Seconds 15

# 白用チェックアイコン（featured card 用）
Generate-Image "check white" "A single minimalist flat icon of a small elegant white diamond rhombus shape, perfectly centered on a deep rose red background. Clean, sharp edges, premium and feminine. Square 1:1. No text, no shadows, no watermarks." "icon_check_white.png"

Write-Host "Done." -ForegroundColor Green
