# Generate 3 feature section icons via Gemini 3.1 Flash Image
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

Start-Sleep -Seconds 5
Generate-Image "Feature1 Ear" "A close-up elegant macro photograph of a woman's ear with a tiny gold acupressure sticker on it. Soft blush pink and rose background with warm bokeh. Luxurious, feminine, therapeutic mood. Studio lighting, high-end beauty photography. Square 1:1 composition. No text, no watermarks." "feat_ear.jpg"

Start-Sleep -Seconds 15
Generate-Image "Feature2 Meal" "A beautifully arranged Japanese balanced meal set on a white ceramic plate, top-down flat lay. Colorful vegetables, lean protein, miso soup, and rice. Soft natural light, clean white background with subtle rose-gold accents. Elegant food photography, feminine and healthy aesthetic. Square 1:1 composition. No text, no watermarks." "feat_meal.jpg"

Start-Sleep -Seconds 15
Generate-Image "Feature3 Knowledge" "An elegant open journal notebook with a slim measuring tape and small pink flowers arranged beside it, on a soft cream linen background. Empowering, organized, feminine mood. Flat lay with warm natural light. Lifestyle photography, soft pastel tones with rose gold details. Square 1:1 composition. No text, no watermarks." "feat_knowledge.jpg"

Write-Host ""
Write-Host "All feature images generated." -ForegroundColor Green
