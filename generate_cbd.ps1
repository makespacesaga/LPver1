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

Generate-Image "cbd bottle" "An elegant flat lay of a small amber CBD oil dropper bottle surrounded by soft green hemp leaves, small white flowers, and a linen cloth on a warm cream background. Soft natural light. Premium, feminine, wellness aesthetic. No text, no watermarks. Square 1:1." "cbd_bottle.jpg"
Start-Sleep -Seconds 15
Generate-Image "cbd relax" "A close-up of a Japanese woman's bare shoulders and neck from behind, with gentle hands applying oil in a relaxing massage setting. Soft warm candlelight and bokeh background. Peaceful, luxurious, deeply relaxing mood. Premium spa aesthetic. No text, no watermarks. Square 1:1." "cbd_relax.jpg"

Write-Host "Done." -ForegroundColor Green
