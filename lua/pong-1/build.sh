#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# --- Universal Configuration ---
GAME_NAME="Pong2D"
LOVE_VERSION="11.5" # Target engine version for Windows runtime binaries
MEMORY_ALLOCATION=67108864 # 64MB - safe standard target for 2D games

# --- Path Targets ---
BUILD_ROOT="./build"
WEB_DIR="${BUILD_ROOT}/web"
WIN_DIR="${BUILD_ROOT}/windows"
WIN_CACHE="${BUILD_ROOT}/love-win64"
WIN_URL="https://github.com/love2d/love/releases/download/${LOVE_VERSION}/love-${LOVE_VERSION}-win64.zip"

# Print operational menu
show_usage() {
    echo "Usage: $0 [web | windows | all]"
    echo "---------------------------------------"
    echo "  web     : Compile down to WebAssembly (love.js)"
    echo "  windows : Package and fuse a standalone Windows x64 build"
    echo "  all     : Execute both pipelines sequentially"
    exit 1
}

# Ensure the core build directory exists safely
mkdir -p "$BUILD_ROOT"

# Core Asset Bundler (.love packaging method)
package_love_archive() {
    echo "📦 Packaging source payload into temporary game archive..."
    rm -f "${BUILD_ROOT}/${GAME_NAME}.love"

    # Pack securely from root without dragging parent folder into tree context
    # Includes asset maps and tracking directories safely
    zip -r "${BUILD_ROOT}/${GAME_NAME}.love" main.lua conf.lua assets/ *.lua 2>/dev/null || true
}

# Web assembly compilation pipeline
build_web() {
    echo "========================================="
    echo "🚀 Triggering WebAssembly (love.js) Build"
    echo "========================================="

    # Guard clause evaluating internal node_modules context
    if [ ! -f ./node_modules/.bin/love.js ]; then
        echo "📦 love.js local binary missing. Checking environment with npm..."
        npm ci
    else
        echo "✓ love.js engine context verified."
    fi

    rm -rf "$WEB_DIR"
    mkdir -p "$WEB_DIR"

    package_love_archive

    echo "🔨 Generating WASM runtime assets..."
    npx love.js "${BUILD_ROOT}/${GAME_NAME}.love" "$WEB_DIR" \
      --title "${GAME_NAME}" \
      --memory $MEMORY_ALLOCATION

    echo "🗜️  Compressing web layer into shippable archive..."
    rm -f "${BUILD_ROOT}/${GAME_NAME}_web.zip"
    (cd "$WEB_DIR" && zip -q -r "../${GAME_NAME}_web.zip" .)

    # Erase loose payload artifact from root structure
    rm -f "${BUILD_ROOT}/${GAME_NAME}.love"
    echo "✓ Web build deployed successfully!"
}

# Windows compilation pipeline
build_windows() {
    echo "========================================="
    echo "🪟 Triggering Standalone Windows x64 Build"
    echo "========================================="

    rm -rf "$WIN_DIR"
    mkdir -p "$WIN_DIR"

    # Evaluate dependency cache safely tucked away inside build/
    if [ ! -d "$WIN_CACHE" ]; then
        echo "🌐 Windows engine binaries missing. Downloading LÖVE v${LOVE_VERSION}..."
        curl -L -o "${BUILD_ROOT}/love-win64.zip" "$WIN_URL"
        unzip -q "${BUILD_ROOT}/love-win64.zip" -d "$BUILD_ROOT"
        mv "${BUILD_ROOT}/love-${LOVE_VERSION}-win64" "$WIN_CACHE"
        rm "${BUILD_ROOT}/love-win64.zip"
    else
        echo "✓ Windows dependency cache located at: $WIN_CACHE"
    fi

    package_love_archive

    echo "⚡ Fusing game payload onto love.exe wrapper..."
    cat "${WIN_CACHE}/love.exe" "${BUILD_ROOT}/${GAME_NAME}.love" > "${WIN_DIR}/${GAME_NAME}.exe"

    echo "📋 Binding dynamic link libraries (.dll)..."
    cp "${WIN_CACHE}"/*.dll "$WIN_DIR/"
    cp "${WIN_CACHE}/license.txt" "$WIN_DIR/"

    echo "🗜️  Compressing Windows folder into distribution package..."
    rm -f "${BUILD_ROOT}/${GAME_NAME}_windows.zip"

    # FIX: Navigate into the staging folder and zip everything recursively (*) properly
    (cd "$WIN_DIR" && zip -q -r "../${GAME_NAME}_windows.zip" *)

    # Clean up game payload artifact
    rm -f "${BUILD_ROOT}/${GAME_NAME}.love"
    echo "✓ Windows build deployed successfully!"
}

# --- Target Routing Selector ---
if [ $# -eq 0 ]; then
    show_usage
fi

case "$1" in
    web)
        build_web
        ;;
    windows)
        build_windows
        ;;
    all)
        build_web
        build_windows
        echo "========================================="
        echo "🎉 Complete Orchestration Finished!"
        echo "========================================="
        ;;
    *)
        show_usage
        ;;
esac