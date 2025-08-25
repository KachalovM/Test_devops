# Test Server Smoke
Start-Sleep -Seconds 10

# Test 1: Root Endpoint Check
Write-Host "Test 1: Root Endpoint Check" -ForegroundColor Cyan
try {
    $rootResponse = Invoke-RestMethod -Uri "http://localhost:8080/" -Method Get
    if ($rootResponse.message -eq "Blog Server API") {
        Write-Host "   PASS: Root endpoint check successful" -ForegroundColor Green
    }
    else {
        Write-Host "   FAIL: Root endpoint check failed" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "   FAIL: Root endpoint check failed - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Create Post
Write-Host "Test 2: Create Post" -ForegroundColor Cyan
try {
    $postData = @{
        title   = "Smoke Test Post"
        content = "This is test"
    } | ConvertTo-Json

    $postResponse = Invoke-RestMethod -Uri "http://localhost:8080/posts" -Method Post -Body $postData -ContentType "application/json"
    
    if ($postResponse.id) {
        Write-Host "   PASS: Post created successfully" -ForegroundColor Green
        Write-Host "   Post ID: $($postResponse.id)" -ForegroundColor Green
    }
    else {
        Write-Host "   FAIL: Failed to create post" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "   FAIL: Failed to create post - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 3: Get Posts
Write-Host "Test 3: Get Posts" -ForegroundColor Cyan
try {
    $getResponse = Invoke-RestMethod -Uri "http://localhost:8080/posts" -Method Get
    
    if ($getResponse -and $getResponse.Count -gt 0) {
        Write-Host "   PASS: Posts get successfully" -ForegroundColor Green
        Write-Host "   Found $($getResponse.Count) post(s)" -ForegroundColor Green
    }
    else {
        Write-Host "   FAIL: Failed to get posts" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "   FAIL: Failed to get posts - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "======================================" -ForegroundColor Green
Write-Host "All smoke tests passed!" -ForegroundColor Green
