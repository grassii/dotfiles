
tell application "Finder"
	set _b to bounds of window of desktop
	set _screenWidth to item 3 of _b
	set _screenHeight to item 4 of _b
end tell

tell application "System Events"
	set _everyProcess to every process
	repeat with n from 1 to count of _everyProcess
		set _frontMost to frontmost of item n of _everyProcess
		if _frontMost is true then set _frontMostApp to process n
	end repeat
	
	-- Now we have the front most winddow in _frontmost
	set _windowOne to window 1 of _frontMostApp
	
	
	set yAxis to 150
	set xAxis to 1185
	set appHeight to 277
	set appWidth to 660
	
	set position of _windowOne to {xAxis, yAxis}
	set size of _windowOne to {appWidth, appHeight}
	
end tell