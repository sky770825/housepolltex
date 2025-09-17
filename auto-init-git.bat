@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ================================
echo 🚀 自動化 Git 初始化工具
echo ================================
echo.

echo 正在檢查 Git 狀態...

:: 檢查是否已經是 Git 倉庫
git status >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ 已經是 Git 倉庫
    echo.
    echo 當前 Git 狀態：
    git status --short
    echo.
    set /p continue=是否要重新初始化？(y/n): 
    if /i not "!continue!"=="y" (
        echo 操作已取消
        pause
        exit /b 0
    )
    echo.
    echo 正在清理現有 Git 設定...
    rmdir /s /q .git 2>nul
)

echo.
echo 步驟1: 初始化 Git 倉庫...
git init
if errorlevel 1 (
    echo ❌ Git 初始化失敗
    pause
    exit /b 1
)
echo ✅ Git 倉庫已初始化

echo.
echo 步驟2: 設定 Git 使用者資訊...
set /p username=請輸入您的 Git 使用者名稱: 
set /p email=請輸入您的 Git 電子郵件: 

git config user.name "!username!"
git config user.email "!email!"
echo ✅ Git 使用者資訊已設定

echo.
echo 步驟3: 設定 GitHub 遠端倉庫...
set /p repo_url=請輸入 GitHub 倉庫 URL (例如: https://github.com/username/repo.git): 

git remote add origin "!repo_url!"
if errorlevel 1 (
    echo ❌ 遠端倉庫設定失敗
    pause
    exit /b 1
)
echo ✅ GitHub 遠端倉庫已設定

echo.
echo 步驟4: 建立 .gitignore 檔案...
if not exist .gitignore (
    echo # 依賴檔案 > .gitignore
    echo node_modules/ >> .gitignore
    echo temp_backup/ >> .gitignore
    echo. >> .gitignore
    echo # 系統檔案 >> .gitignore
    echo .DS_Store >> .gitignore
    echo Thumbs.db >> .gitignore
    echo. >> .gitignore
    echo # 編輯器檔案 >> .gitignore
    echo .vscode/ >> .gitignore
    echo .idea/ >> .gitignore
    echo *.swp >> .gitignore
    echo *.swo >> .gitignore
    echo. >> .gitignore
    echo # 日誌檔案 >> .gitignore
    echo *.log >> .gitignore
    echo npm-debug.log* >> .gitignore
    echo. >> .gitignore
    echo # 建置檔案 >> .gitignore
    echo dist/ >> .gitignore
    echo build/ >> .gitignore
    echo. >> .gitignore
    echo # 環境變數 >> .gitignore
    echo .env >> .gitignore
    echo .env.local >> .gitignore
    echo .env.development.local >> .gitignore
    echo .env.test.local >> .gitignore
    echo .env.production.local >> .gitignore
    echo. >> .gitignore
    echo # 備份檔案 >> .gitignore
    echo *.bak >> .gitignore
    echo *.backup >> .gitignore
    echo ✅ .gitignore 檔案已建立
) else (
    echo ✅ .gitignore 檔案已存在
)

echo.
echo 步驟5: 添加檔案到 Git...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    exit /b 1
)
echo ✅ 檔案已添加到 Git

echo.
echo 步驟6: 提交初始版本...
git commit -m "初始化專案 - %date% %time%"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    exit /b 1
)
echo ✅ 初始版本已提交

echo.
echo 步驟7: 推送到 GitHub...
git push -u origin main
if errorlevel 1 (
    echo ❌ 推送到 GitHub 失敗
    echo.
    echo 可能的原因：
    echo 1. 網路連接問題
    echo 2. GitHub 認證問題
    echo 3. 倉庫不存在或權限不足
    echo.
    echo 請檢查後手動執行：git push -u origin main
    pause
    exit /b 1
)
echo ✅ 已成功推送到 GitHub

echo.
echo ================================
echo 🎉 Git 初始化完成！
echo ================================
echo.
echo 專案資訊：
echo 本地倉庫：%cd%
echo 遠端倉庫：!repo_url!
echo 分支：main
echo.
echo 現在您可以使用「ai網站管理工具.bat」進行日常管理了！
echo.

pause
