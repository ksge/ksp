C:\Users\oldboy\AppData\Local\Programs\Python\Python39\Scripts\pyinstaller.exe --noconsole --onefile --clean PokerView.py
C:\Users\oldboy\AppData\Local\Programs\Python\Python39\Scripts\pyinstaller.exe --noconsole --onefile --clean PokerModel.py
C:\Users\oldboy\AppData\Local\Programs\Python\Python39\Scripts\pyinstaller.exe --noconsole --onefile --clean poker-end.py

timeout /t 5

copy /V /Y dist\*.exe .

timeout /t 5

rd /S /Q dist
rd /S /Q build
rd /S /Q __pycache__

timeout /t 5

del /Q *.spec

timeout /t 5
