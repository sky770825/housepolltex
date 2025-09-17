@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ================================
echo 🔧 Git 同步修復工具
echo ================================
echo.

echo 正在檢查 Git 狀態...
git status
echo.

echo 選擇修復方式：
echo 1. 強制同步（推薦）- 下載遠端內容並合併
echo 2. 強制覆蓋 - 用本地內容覆蓋遠端（危險）
echo 3. 重置並重新開始
echo 4. 取消
echo.

set /p choice=請選擇 (1-4): 

if "%choice%"=="1" goto force_sync
if "%choice%"=="2" goto force_overwrite
if "%choice%"=="3" goto reset_and_restart
if "%choice%"=="4" goto exit
echo 無效選項
pause
goto start

:force_sync
echo.
echo ================================
echo 🔄 強制同步遠端內容
echo ================================
echo.

echo 步驟1: 下載遠端內容...
git fetch origin main
if errorlevel 1 (
    echo ❌ 下載失敗
    pause
    exit /b 1
)
echo ✅ 遠端內容已下載

echo.
echo 步驟2: 合併遠端內容...
git merge origin/main --allow-unrelated-histories
if errorlevel 1 (
    echo ❌ 合併失敗，嘗試解決衝突...
    echo.
    echo 請手動解決衝突後執行：
    echo git add .
    echo git commit -m "解決合併衝突"
    echo git push origin main
    pause
    exit /b 1
)
echo ✅ 內容已合併

echo.
echo 步驟3: 推送到遠端...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失敗
    pause
    exit /b 1
)
echo ✅ 已成功推送到 GitHub

echo.
echo ================================
echo 🎉 同步完成！
echo ================================
echo.
pause
goto end

:force_overwrite
echo.
echo ================================
echo ⚠️ 強制覆蓋遠端內容
echo ================================
echo.

echo 警告：這將用本地內容完全覆蓋遠端內容！
echo 遠端的所有變更將會遺失！
echo.
set /p confirm=確定要繼續嗎？(y/n): 
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto end
)

echo.
echo 步驟1: 強制推送...
git push origin main --force
if errorlevel 1 (
    echo ❌ 強制推送失敗
    pause
    exit /b 1
)
echo ✅ 已強制覆蓋遠端內容

echo.
echo ================================
echo 🎉 覆蓋完成！
echo ================================
echo.
pause
goto end

:reset_and_restart
echo.
echo ================================
echo 🔄 重置並重新開始
echo ================================
echo.

echo 警告：這將刪除所有本地變更並重新開始！
echo.
set /p confirm=確定要重置嗎？(y/n): 
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto end
)

echo.
echo 步驟1: 備份當前檔案...
if not exist "backup_before_reset" mkdir backup_before_reset
copy *.html backup_before_reset\ 2>nul
copy *.bat backup_before_reset\ 2>nul
copy *.css backup_before_reset\ 2>nul
copy *.js backup_before_reset\ 2>nul
echo ✅ 檔案已備份到 backup_before_reset 資料夾

echo.
echo 步驟2: 刪除 Git 倉庫...
rmdir /s /q .git 2>nul
echo ✅ Git 倉庫已刪除

echo.
echo 步驟3: 重新初始化...
git init
git remote add origin https://github.com/sky770825/housepolltex.git
git add .
git commit -m "重新初始化專案 - %date% %time%"
git push -u origin main --force
if errorlevel 1 (
    echo ❌ 重新初始化失敗
    pause
    exit /b 1
)
echo ✅ 重新初始化完成

echo.
echo ================================
echo 🎉 重置完成！
echo ================================
echo.
pause
goto end

:exit
echo 操作已取消
pause
goto end

:end
echo.
echo 您的網站地址：
echo https://sky770825.github.io/housepolltex/
echo.
exit /b 0
