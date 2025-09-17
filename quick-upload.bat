@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ================================
echo ⚡ 快速上傳檔案到 GitHub
echo ================================
echo.

echo 正在檢查檔案狀態...
echo.

echo 本地檔案列表：
echo ================================
dir /b *.html *.css *.js *.txt *.md 2>nul
echo ================================

echo.
echo 正在檢查 Git 狀態...
git status --short
echo.

echo 正在添加所有檔案到 Git...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    exit /b 1
)
echo ✅ 檔案已添加到 Git

echo.
echo 正在檢查添加的檔案...
git status --short
echo.

echo 正在提交檔案...
set commit_msg=上傳網站檔案 - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    exit /b 1
)
echo ✅ 檔案已提交

echo.
echo 正在推送到 GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失敗
    echo.
    echo 可能的原因：
    echo 1. 網路連接問題
    echo 2. GitHub 認證問題
    echo 3. 需要先同步遠端內容
    echo.
    echo 建議使用「修復 Git 同步問題」功能
    pause
    exit /b 1
)
echo ✅ 已成功推送到 GitHub

echo.
echo ================================
echo 🎉 上傳完成！
echo ================================
echo.
echo 您的網站地址：
echo https://sky770825.github.io/housepolltex/
echo.

echo 正在驗證上傳結果...
echo.
echo GitHub 上的檔案：
echo ================================
git ls-tree -r origin/main --name-only 2>nul
echo ================================

echo.
pause
