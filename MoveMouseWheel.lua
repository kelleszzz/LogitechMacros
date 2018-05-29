function OnEvent(event, arg)
	--����
	mRange=2000
	mSleep=5
	--�߼�
	if (event == "MOUSE_BUTTON_PRESSED" and arg == FORWARD) then --�����ǰ��������ʱ
		if XPlayMacro("MoveMouseWheel")==false then return end
		abortButton=BACKWARD
		while mRunning==true do
			--�»�
			XMoveMouseWheel(-8000)
			Sleep(XTimeShuffle())
		end
		abortButton=nil
		--XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == MIDDLE) then --������м�����ʱ
		PrintPosition()
	end
end


--������������������������������BASIC������������������������������--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=BACKWARD --Ϊ����ʱ,��ʾ������ֹͣ;Ϊ����ʱ,��ʾ�ſ���ֹͣ
mRange=1500
mSleep=5
mRunning=false
funcDoClear=nil
funcAbortLoop=nil --����������
maxSleepInterval=5
math.randomseed(GetDate("%I%M%S")+0)
function XPlayMacro(macro)
	if mRunning then
		return false
	end
	mRunning=true
	PlayMacro(macro)
	OutputLogMessage("XPlayMacro "..GetDate().."\n")
end
function XAbortMacro()
	--������Ҫ�ں��е������ô˺���;�ݵ�;��֤ÿ���˳�ʱ,�˺���ִֻ��һ��
	AbortMacro()
	mRunning=false
	if (funcDoClear~=nil) then 
		funcDoClear() 
	end
	--OutputLogMessage("XAbortMacro "..GetDate().."\n")
end
function XAbortLoop(button)
	local doAbort
	if funcAbortLoop~=nil and funcAbortLoop()==true then
		doAbort=true
		OutputLogMessage("XAbortLoop for [funcAbortLoop] "..GetDate().."\n")
	end
	if mRunning==false then 
		doAbort=true 
		OutputLogMessage("XAbortLoop for [mRunning] "..GetDate().."\n")
	end
	if (button~=nil and button>0) then
		if IsMouseButtonPressed(button) then 
			doAbort=true 
			OutputLogMessage("XAbortLoop for [abortButton"..button.."] "..GetDate().."\n")
		end
	end
	if (button~=nil and button<0) then
		if IsMouseButtonPressed(-button)==false then 
			doAbort=true 
			OutputLogMessage("XAbortLoop for [abortButton"..button.."] "..GetDate().."\n")
		end
	end
	if doAbort then
		--�˺���ֻ�����ж�,������������Ҫ�ٴε���XAbortMacro
		--OutputLogMessage("XAbortLoop "..GetDate().."\n")
		return true
	end
end
function PrintPosition()
	local px,py=GetMousePosition()
	OutputLogMessage("(%s,%s) %s\n",""..px,""..py,GetDate().."")
end
function XSleep(millis)
	--XAbortMacroԪ����,������Logitech API������,δ��������Xϵ�к���
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XSleep] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if (millis>maxSleepInterval) then
		Sleep(maxSleepInterval)
		return XSleep(millis-maxSleepInterval)
	end
	Sleep(millis)
end
XTimeShuffle=function()
	return 50+math.random()*50
end
--������������������������������BASIC������������������������������--
--������������������������������MOUSE������������������������������--
function XWaitMicroTime()
	return XSleep(XTimeShuffle()/4)
end

function XWaitShortTime()
	return XSleep(XTimeShuffle())
end

function XWaitLongTime()
	return XSleep(XTimeShuffle()*5)
end

function XMoveMouseToPosition(tab,sleepFunc)
	if tab==nil then return false end
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseToPosition] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if XMoveMouseTo(tab.px,tab.py)==false then return false end
	if sleepFunc~=nil then
		return sleepFunc()
	end
end

function ResetPosition(tab)
	if tab==nil then return end
	tab.px=nil
	tab.py=nil
end

function CheckPositionValid(tab)
	if tab~=nil and tab.px~=nil and tab.py~=nil then
		return true
	else
		return false
	end
end

function XMoveMouseRelative(mx,my)
	--������Ҫ�ں��е������ô˺���
	if XAbortLoop(abortButton) then
		OutputLogMessage("XAbortMacro while [XMoveMouseRelative] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	local px,py=GetMousePosition()
	local lastStep=false
	local nextXMove,nextYMove
	if (math.abs(mx)<=mRange and math.abs(my)<=mRange) then lastStep=true end --һ���ƶ����ɵ����յ�,���ٵݹ�
	if math.abs(mx)<=mRange then nextXMove=mx else nextXMove=mx*mRange/math.abs(mx) end
	if math.abs(my)<=mRange then nextYMove=my else nextYMove=my*mRange/math.abs(my) end
	--�߽��ж�,���ɳ����߽�
	local nextXPos=px+nextXMove
	local nextYPos=py+nextYMove
	if (nextXPos<0) then nextXPos=0 end
	if (nextXPos>65535) then nextXPos=65535 end
	if (nextYPos<0) then nextYPos=0 end
	if (nextYPos>65535) then nextYPos=65535 end
	MoveMouseTo(nextXPos,nextYPos)
	if lastStep then return end
	if XSleep(mSleep)==false then return false end
	if XMoveMouseRelative(mx-nextXMove,my-nextYMove)==false then return false end
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseTo] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if (dx==nil or dy==nil or dx<0 or dx>65535 or dy<0 or dy>65535) then
		return false
	end
	local px,py=GetMousePosition()
	local mx,my=dx-px,dy-py
	local lastStep=false
	local nextXMove,nextYMove
	if (math.abs(mx)<=mRange and math.abs(my)<=mRange) then lastStep=true end
	if math.abs(mx)<=mRange then nextXMove=mx else nextXMove=mx*mRange/math.abs(mx) end
	if math.abs(my)<=mRange then nextYMove=my else nextYMove=my*mRange/math.abs(my) end
	if lastStep then 
		--���һ���ƶ�
		return XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
	end
	--����һ���ƶ���С��Χ��
	if XMoveMouseRelative(nextXMove,nextYMove)==false then return false end
	if XSleep(mSleep)==false then return false end
	if XMoveMouseTo(dx,dy)==false then return false end
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XPressAndReleaseMouseButton] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	if XPressMouseButton(button)==false then return false end
	if XSleep(XTimeShuffle())==false then
		XReleaseMouseButton(button) --����release
		return false
	end
	XReleaseMouseButton(button) --����release
	if XSleep(XTimeShuffle())==false then return false end
end

function XMoveMouseWheel(range)
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XMoveMouseWheel] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	local px,py=GetMousePosition()
	local dy=py-range
	if (dy>65535) then
		dy=65534
	end
	if (dy<0) then
		dy=0
	end
	if XMoveMouseTo(px,dy)==false then return false end
	if XPressMouseButton(1)==false then
		XReleaseMouseButton(1) --����release
		return false
	end
	if XMoveMouseTo(px,py)==false then
		XReleaseMouseButton(1) --����release
		return false
	end
	XReleaseMouseButton(1) --����release
end

function XPressMouseButton(button)
	--XAbortMacroԪ����,������Logitech API������,δ��������Xϵ�к���
	if (XAbortLoop(abortButton)) then
		OutputLogMessage("XAbortMacro while [XPressMouseButton] "..GetDate().."\n")
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
end

function XReleaseMouseButton(button)
	--XAbortMacroԪ����,������Logitech API������,δ��������Xϵ�к���
	ReleaseMouseButton(button) --����release
end

--����Ϊ���ú���
XPositionShuffle=function()
	local range=30
	return math.random()*range*2-range
end
--������������������������������MOUSE������������������������������--

