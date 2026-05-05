#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
GAME_NAME="Pong2D"
BUILD_DIR="./build/web"
MEMORY_ALLOCATION=67108864 # 64MB - safe standard target for 2D games

echo "========================================="
echo "🚀 Starting LÖVE Web Build Pipeline"
echo "========================================="

# Step 1: Ensure love.js dependency exists locally
if [ ! -f ./node_modules/.bin/love.js ]; then
    echo "📦 love.js local binary not found. Installing via npm..."
    npm ci
else
    echo "✓ love.js dependency is verified."
fi

rm -rf "$BUILD_DIR"

mkdir -p $BUILD_DIR

# Step 2: Package game files into a .love file
echo "📦 Packaging game assets into ${GAME_NAME}.love..."
rm -f "build/${GAME_NAME}.love"

# Zip from INSIDE the folder so main.lua sits explicitly at the archive root
# Customize this list to match your project folder structure (e.g., assets, fonts)
zip -r "build/${GAME_NAME}.love" main.lua conf.lua assets/ *.lua 2>/dev/null || true

# Step 3: Compile to WebAssembly via love.js
echo "🔨 Compiling to WebAssembly and JavaScript via love.js..."

npx love.js "${GAME_NAME}.love" "$BUILD_DIR" \
  --title "${GAME_NAME}" \
  --memory $MEMORY_ALLOCATION

# Step 4: Prepare final distribution package
echo "🗜️  Creating deployment-ready ZIP for itch.io..."
rm -f "${GAME_NAME}_web.zip"
(cd "$BUILD_DIR" && zip -r "../${GAME_NAME}_web.zip" .)

echo "========================================="
echo "🎉 Build Complete!"
echo "📂 Web Folder:   $BUILD_DIR"
echo "📦 Dist Package: ./${GAME_NAME}_web.zip"
echo "========================================="