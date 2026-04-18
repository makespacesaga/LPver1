# Generate CTA background + Before/After images via Gemini 3.1 Flash Image
$ErrorActionPreference = "Stop"

$apiKey = (Get-Content (Join-Path $PSScriptRoot ".env") -Encoding UTF8) -replace "gemini_apikey=",""
$outputDir = Join-Path $PSScriptRoot "image"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image-preview:generateContent?key=$apiKey"

function Generate-Image($label, $prompt, $filename) {
    Write-Host "[$label] Generating..." -ForegroundColor Cyan
    $escaped = $prompt.Replace('\','\\').Replace('"','\"')
    $body = '{"contents":[{"parts":[{"text":"' + $escaped + '"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}'
    try {
        $res = Invoke-RestMethod -Uri $url -Method POST `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes($body))
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

# CTA background (wait before first call to avoid rate limit from previous session)
Start-Sleep -Seconds 10
Generate-Image "CTA BG" `
    "A beautiful and happy Japanese woman in her 30s, laughing joyfully with eyes slightly closed, shoulders-up portrait. Healthy glowing skin, radiant smile. Dark background with deep plum purple to dark rose gradient tones. Cinematic low-key lighting with warm pink rim light on her face. Triumphant, emotional, aspirational mood. High quality photorealistic cinematic photography. No text, no watermarks." `
    "cta_bg.jpg"

Start-Sleep -Seconds 15
# Before image
Generate-Image "Before" `
    "A tired-looking Japanese woman in her 30s sitting on a sofa at home, slouched posture, wearing loose casual clothes, looking slightly unhappy and exhausted. Soft dim indoor lighting. The mood feels heavy and stagnant, representing the before state before a lifestyle transformation. Realistic, candid, relatable. No text, no watermarks." `
    "before.jpg"

Start-Sleep -Seconds 15
# After image
Generate-Image "After" `
    "A slim, radiant and confident Japanese woman in her 30s, standing and smiling brightly in a bright airy room with natural light, wearing well-fitted stylish casual clothes. Energetic, joyful and empowered expression. Light and uplifting mood representing a successful body transformation. High quality photorealistic magazine-style photography. No text, no watermarks." `
    "after.jpg"

Write-Host ""
Write-Host "All images generated." -ForegroundColor Green
