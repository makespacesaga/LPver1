# Generate 6 problem section icons via Gemini 3.1 Flash Image
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

Generate-Image "prob1 rebound" "A minimalist elegant icon-style illustration of a circular weight scale with an upward arrow indicating weight regain. Deep dark plum background. Soft rose pink and gold tones. Moody cinematic lighting. Square 1:1. No text, no watermarks." "prob_rebound.jpg"
Start-Sleep -Seconds 15

Generate-Image "prob2 postpartum" "A minimalist elegant close-up of a soft measuring tape loosely coiled on a dark plum background. Warm rose and gold accent lighting. Moody, feminine, cinematic. Square 1:1. No text, no watermarks." "prob_postpartum.jpg"
Start-Sleep -Seconds 15

Generate-Image "prob3 menopause" "A minimalist elegant image of a small thermometer beside a wilting pink flower on a deep dark background. Soft warm rose and gold tones. Moody cinematic lighting. Feminine aesthetic. Square 1:1. No text, no watermarks." "prob_menopause.jpg"
Start-Sleep -Seconds 15

Generate-Image "prob4 food" "A minimalist elegant close-up photograph of a fork resting on an empty white plate on a dark plum background. Soft rose and gold rim lighting. Moody, cinematic, feminine. Square 1:1. No text, no watermarks." "prob_food.jpg"
Start-Sleep -Seconds 15

Generate-Image "prob5 money" "A minimalist elegant image of a few scattered gold coins and a crumpled receipt on a deep dark plum surface. Warm gold and rose accent lighting. Cinematic moody aesthetic. Square 1:1. No text, no watermarks." "prob_money.jpg"
Start-Sleep -Seconds 15

Generate-Image "prob6 confused" "A minimalist elegant silhouette of a Japanese woman sitting alone with head slightly bowed, surrounded by soft dark space. Deep dark plum background with subtle rose glow from behind. Emotional, cinematic, feminine. Square 1:1. No text, no watermarks." "prob_confused.jpg"

Write-Host ""
Write-Host "All problem images generated." -ForegroundColor Green
