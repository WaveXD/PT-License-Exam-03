@echo off
chcp 65001 >nul
title Deploy PT Exam 03 to GitHub

set PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Programs\gh;%PATH%

echo ========================================================
echo   ระบบนำคลังข้อสอบวิชา 03 ขึ้นสู่ GitHub (Deploy to Git)
echo ========================================================
echo.

echo ตรวจสอบสถานะการล็อกอิน GitHub...
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo ยังไม่ได้ล็อกอินเข้าสู่ GitHub
    echo กำลังเปิดหน้าต่างเบราว์เซอร์เพื่อเข้าสู่ระบบ (กด Enter เพื่อทำรายการ)...
    pause
    gh auth login -w -p https
)

echo.
echo เข้าสู่ระบบสำเร็จแล้ว!
echo กำลังสร้าง GitHub Repository และ Push ข้อมูลทั้งหมด...
echo.

set REPO_NAME=PT-Exam-03-Review

gh repo view %REPO_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo กำลังสร้าง Repository: %REPO_NAME% (Public)...
    gh repo create %REPO_NAME% --public --source=. --remote=origin --push
) else (
    echo พบ Repository เดิม กำลัง Push ข้อมูลอัปเดต...
    git push -u origin main
)

echo.
echo กำลังเปิดใช้งาน GitHub Pages สำหรับระบบทำข้อสอบออนไลน์...
gh api --method POST /repos/:owner/%REPO_NAME%/pages -f source='{"branch":"main","path":"/"}' >nul 2>&1

echo.
echo ========================================================
echo   [SUCCESS] นำขึ้น GitHub เรียบร้อยแล้ว!
echo ========================================================
echo สามารถเข้าดูคลังข้อสอบได้ที่ GitHub ของคุณ:
gh repo view --web
echo.
pause
