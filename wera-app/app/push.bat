git status
set /p Input=Comment:
git add .
git commit -m "%Input%"
git push