# Generate 3 voice/testimonial avatar images via Gemini 3.1 Flash Image
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

Generate-Image "voice1 KM" "A warm candid portrait of a smiling Japanese woman in her mid-30s, looking happy and healthy. Soft natural indoor lighting, slightly blurred cream background. She looks genuinely joyful and relieved, like someone who achieved a goal. Close-up shoulders-up shot. Warm skin tone, natural makeup. Real and relatable, not model-like. Square 1:1. No text, no watermarks." "voice_km.jpg"
Start-Sleep -Seconds 15

Generate-Image "voice2 TA" "A confident warm portrait of a Japanese woman in her early 40s, smiling softly with a calm and empowered expression. Professional but approachable look, wearing a simple blouse. Soft indoor natural light, warm blurred background. Real and relatable appearance. Close-up shoulders-up shot. Square 1:1. No text, no watermarks." "voice_ta.jpg"
Start-Sleep -Seconds 15

Generate-Image "voice3 YS" "A warm portrait of a Japanese woman in her late 40s, smiling contentedly with a relaxed and satisfied expression. She looks at ease, healthy, and confident in herself. Soft natural indoor lighting, warm neutral background. Real and relatable, not overly glamorous. Close-up shoulders-up shot. Square 1:1. No text, no watermarks." "voice_ys.jpg"

Write-Host ""
Write-Host "All voice images generated." -ForegroundColor Green
