/home/user/.local/bin/pyinstaller --noconsole --onefile PokerView.py
/home/user/.local/bin/pyinstaller --noconsole --onefile PokerModel.py
/home/user/.local/bin/pyinstaller --noconsole --onefile poker-end.py

sleep 5

cp -f dist/PokerView .
cp -f dist/PokerModel .
cp -f dist/poker-end .


sleep 5

rm -r -f -d dist
rm -r -f -d build
rm -r -f -d __pycache__

sleep 5

rm -r -f -d *.spec

sleep 5
