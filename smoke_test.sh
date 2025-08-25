#!/bin/bash

# Test Server Smoke
sleep 10

# Test 1: Root Endpoint Check
echo "Test 1: Root Endpoint Check"
if curl -f http://localhost:8080/ > /dev/null 2>&1; then
    echo "   PASS: Root endpoint check successful"
else
    echo "   FAIL: Root endpoint check failed"
    exit 1
fi

# Test 2: Create Post
echo "Test 2: Create Post"
POST_RESPONSE=$(curl -s -X POST http://localhost:8080/posts \
  -H "Content-Type: application/json" \
  -d '{"title": "Smoke Test Post", "content": "This is a test"}')

if echo "$POST_RESPONSE" | grep -q "id"; then
    echo "   PASS: Post created successfully"
    POST_ID=$(echo "$POST_RESPONSE" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    echo "   Post ID: $POST_ID"
else
    echo "   FAIL: Failed to create post"
    echo "   Response: $POST_RESPONSE"
    exit 1
fi

# Test 3: Get Posts
echo "Test 3: Get Posts"
GET_RESPONSE=$(curl -s http://localhost:8080/posts)

if echo "$GET_RESPONSE" | grep -q "Smoke Test Post"; then
    echo "   PASS: Posts get successfully"
    echo "   Found test post"
else
    echo "   FAIL: Failed to get posts or test post not found"
    echo "   Response: $GET_RESPONSE"
    exit 1
fi

# Test 4: Root Endpoint
echo "Test 4: Root Endpoint"
ROOT_RESPONSE=$(curl -s http://localhost:8080/)

if echo "$ROOT_RESPONSE" | grep -q "Blog Server API"; then
    echo "   PASS: Root endpoint successfully"
else
    echo "   FAIL: Root endpoint failed"
    echo "   Response: $ROOT_RESPONSE"
    exit 1
fi

echo "======================================"
echo "All smoke tests passed!"
