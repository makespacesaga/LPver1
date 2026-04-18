# Hero image generation via Imagen 3 (Gemini API)
$ErrorActionPreference = "Stop"

# Load API key from .env
$envPath = Join-Path $PSScriptRoot ".env"
$envContent = Get-Content $envPath -Encoding UTF8
$apiKey = ($envContent | Where-Object { $_ -match "gemini_apikey=" }) -replace "gemini_apikey=", ""

if (-not $apiKey) { Write-Error "gemini_apikey not found in .env"; exit 1 }
Write-Host "API key loaded." -ForegroundColor Cyan

# Prompt
$prompt = "A slim, healthy and confident Japanese woman in her 30s, standing in a bright and airy studio with soft natural light. She is smiling warmly, wearing stylish pastel athletic wear in light pink or white. Full body shot. The background is clean white or very light pink with subtle bokeh. The overall mood is feminine, uplifting, and aspirational. High quality, photorealistic, magazine-style photography. No text, no watermarks."

# Build JSON body for gemini-3.1-flash-image-preview (generateContent format)
$escapedPrompt = $prompt.Replace('\','\\').Replace('"','\"')
$body = '{"contents":[{"parts":[{"text":"' + $escapedPrompt + '"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}'

$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image-preview:generateContent?key=$apiKey"

Write-Host "Calling Gemini 3.1 Flash Image API..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri $url -Method POST `
        -ContentType "application/json; charset=utf-8" `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body))

    # generateContent response: candidates[0].content.parts[].inlineData.data
    $imagePart = $response.candidates[0].content.parts | Where-Object { $_.inlineData }
    $imageData = $imagePart.inlineData.data

    if (-not $imageData) {
        Write-Host "Response:" -ForegroundColor Yellow
        $response | ConvertTo-Json -Depth 5
        Write-Error "No image data in response"
        exit 1
    }

    # Save image
    $outputDir  = Join-Path $PSScriptRoot "image"
    $outputPath = Join-Path $outputDir "hero_main.jpg"
    if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

    $bytes = [Convert]::FromBase64String($imageData)
    [IO.File]::WriteAllBytes($outputPath, $bytes)

    Write-Host "Saved: $outputPath" -ForegroundColor Green
    Start-Process $outputPath

} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "API detail: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
}
