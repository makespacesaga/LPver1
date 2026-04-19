# Generate program section images via Gemini 3.1 Flash Image
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

# カードヘッダーアイコン
Generate-Image "prog header" "A minimalist elegant flat icon of a white clipboard with a small gold checkmark and a thin timeline line on a deep rose red background. Clean, modern, premium. Perfectly centered. Square 1:1. No text, no watermarks." "prog_header.png"
Start-Sleep -Seconds 15

# Step1: カウンセリング
Generate-Image "step1 counseling" "An elegant close-up of two women's hands across a table in a warm consultation setting. One hand is holding a pen over a notebook. Soft warm indoor light, cream and rose gold tones. Intimate, trustworthy, professional atmosphere. Square 1:1. No text, no watermarks." "prog_step1.jpg"
Start-Sleep -Seconds 15

# Step2: プラン設計
Generate-Image "step2 plan" "An elegant flat lay of an open planner notebook with a gold pen, small pink flowers, and a measuring tape on a cream linen background. Warm soft light. Organized, premium, feminine aesthetic. Square 1:1. No text, no watermarks." "prog_step2.jpg"
Start-Sleep -Seconds 15

# Step3: LINEサポート
Generate-Image "step3 support" "A close-up of a woman's hand holding a smartphone showing a chat app with a friendly message. Warm soft light, blurred rose and cream background. Modern, supportive, connected feeling. Square 1:1. No text, no watermarks." "prog_step3.jpg"
Start-Sleep -Seconds 15

# Step4: 卒業
Generate-Image "step4 graduate" "A radiant Japanese woman in her 30s holding a small bouquet of pink flowers, smiling with genuine joy and pride. Soft bright background with warm bokeh. Graduation and achievement mood. Feminine, uplifting. Square 1:1. No text, no watermarks." "prog_step4.jpg"

Write-Host ""
Write-Host "All program images generated." -ForegroundColor Green
