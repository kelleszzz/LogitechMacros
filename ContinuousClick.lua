function OnEvent(event, arg)
	if (event == "MOUSE_BUTTON_PRESSED" and arg == FORWARD) then --�����ǰ��������ʱ
		if XPlayMacro("ContinuousClick")==false then return end
		Sleep(10) --�ȴ�IsMouseButtonPressed״̬�ı�
		while XPressAndReleaseMouseButton(1)~=false do
			PrintPosition()
		end
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then --������м�����ʱ
		PrintPosition()
	end
end


--������������������������������BASIC������������������������������--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=BACKWARD --Ϊ����ʱ,��ʾ������ֹͣ;Ϊ����ʱ,��ʾ�ſ���ֹͣ
mRange=500
mSleep=10
mRunning=false
funcDoClear=nil
funcAbortLoop=nil --����������
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
	end
	if mRunning==false then 
		doAbort=true 
	end
	if (button~=nil and button>0) then
		if IsMouseButtonPressed(button) then doAbort=true end
	end
	if (button~=nil and button<0) then
		if IsMouseButtonPressed(-button)==false then doAbort=true end
	end
	if doAbort then
		--�˺���ֻ�����ж�,������������Ҫ�ٴε���XAbortMacro
		OutputLogMessage("XAbortLoop "..GetDate().."\n")
		return true
	end
end
function PrintPosition()
	local px,py=GetMousePosition()
	OutputLogMessage("(%s,%s) %s\n",""..px,""..py,GetDate().."")
end
--������������������������������BASIC������������������������������--
--������������������������������MOVEMOUSE������������������������������--
function XMoveMouseRelative(mx,my)
	--������Ҫ�ں��е������ô˺���
	if XAbortLoop(abortButton) then
		XAbortMacro()
		return
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
	Sleep(mSleep)
	XMoveMouseRelative(mx-nextXMove,my-nextYMove)
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	if (dx==nil or dy==nil or dx<0 or dx>65535 or dy<0 or dy>65535) then
		return
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
		XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
		return
	end
	XMoveMouseRelative(nextXMove,nextYMove) --����һ���ƶ���С��Χ��
	Sleep(mSleep)
	XMoveMouseTo(dx,dy)
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
	Sleep(XTimeShuffle())
	ReleaseMouseButton(button)
	Sleep(XTimeShuffle())
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
	Sleep(XTimeShuffle()/2)
	ReleaseMouseButton(button)
	Sleep(XTimeShuffle())
end

function XMoveMouseWheel(range)
	if (XAbortLoop(abortButton)) then
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
	XMoveMouseTo(px,dy)
	XPressMouseButton(1)
	XMoveMouseTo(px,py)
	ReleaseMouseButton(1) --����release
end

function XPressMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
end

--����Ϊ���ú���
function XPositionShuffle()
	local range=30
	return math.random()*range*2-range
end

function XTimeShuffle()
	return 50+math.random()*50
end
--������������������������������MOVEMOUSE������������������������������--



