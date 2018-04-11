MENU,START_LINE,END_LINE=1,2,3
menu={px=56178,py=2915}
startLine={px=50816,py=8382}
endLine={px=51431,py=54177}
status=nil
function OnEvent(event, arg)
	maxLineNumber,currentLineNumber,startLineNumber=8,20,1
	--�߼�
	if (event == "MOUSE_BUTTON_PRESSED" and arg == FORWARD) then --�����ǰ��������ʱ
		if XPlayMacro("ChangeLine")==false then return end
		positionValid=true
		if (CheckPositionValid(menu)==false) then positionValid=false end
		if (CheckPositionValid(startLine)==false) then positionValid=false end
		if (CheckPositionValid(endLine)==false) then positionValid=false end
		if (positionValid==true) then
			--����ÿ����·������
			local span
			if currentLineNumber<=maxLineNumber then
				span=(endLine.py-startLine.py)/(currentLineNumber-1)
			else
				span=(endLine.py-startLine.py)/(maxLineNumber-1)
			end
			local breakLoop=false
			for i=startLineNumber,currentLineNumber do
				OutputLogMessage("Change to Line %s\n",i.."")
				if XMoveMouseToPosition(menu)==false then break end
				if XPressAndReleaseMouseButton(1)==false then break end
				local currentLine={}
				currentLine.px=startLine.px
				if i<=maxLineNumber then
					--����Ҫ��ҳ,ֱ�ӵ��
					currentLine.py=startLine.py+span*(i-1)
					if XMoveMouseToPosition(currentLine)==false then break end
					if XPressAndReleaseMouseButton(1)==false then break end
				else
					--��Ҫ��ҳ,��������
					currentLine.py=endLine.py
					if XMoveMouseToPosition(startLine)==false then break end
					if XLongMoveMouseWheel(-span*(i-maxLineNumber),span*(maxLineNumber-1))==false then break end
					if XMoveMouseToPosition(currentLine)==false then break end
					if XPressAndReleaseMouseButton(1)==false then break end
				end
				XSleep(XTimeShuffle()*10)
			end
		end
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then --������м�����ʱ
		local px,py=GetMousePosition()
		if status==nil then status=MENU end
		if status==MENU then 
			menu.px=px
			menu.py=py
			OutputLogMessage("[Menu] = (%s,%s) ----> [Start Line] \n",""..px,""..py)
			status=START_LINE
		elseif status==START_LINE then
			startLine.px=px
			startLine.py=py
			OutputLogMessage("[Start Line] = (%s,%s) ----> [End Line] \n",""..px,""..py)
			status=END_LINE
		elseif status==END_LINE then
			endLine.px=px
			endLine.py=py
			OutputLogMessage("[End Line] = (%s,%s) ----> [Restart - Menu] \n",""..px,""..py)
			status=nil
		else
			PrintPosition()
		end
	end
end

function XLongMoveMouseWheel(range,maxRange)
	if range==0 then return end
	if maxRange<=0 then return false end
	if math.abs(range)<=maxRange then
		return XSlowMoveMouseWheel(range)
	end
	if XSlowMoveMouseWheel(maxRange*range/math.abs(range))==false then
		return false
	end
	return XLongMoveMouseWheel(range-maxRange*range/math.abs(range),maxRange)
end

function XMoveMouseToPosition(tab)
	if tab==nil then return end
	XMoveMouseTo(tab.px,tab.py)
	XSleep(XTimeShuffle()*5)
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

function XSlowMoveMouseWheel(range)
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
	XSleep(XTimeShuffle()*10)
	ReleaseMouseButton(1) --����release
end

--������������������������������BASIC������������������������������--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=BACKWARD --Ϊ����ʱ,��ʾ������ֹͣ;Ϊ����ʱ,��ʾ�ſ���ֹͣ
mRange=1000
mSleep=5
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
function XSleep(millis)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	Sleep(millis)
end
--������������������������������BASIC������������������������������--
--������������������������������MOUSE������������������������������--
function XMoveMouseRelative(mx,my)
	--������Ҫ�ں��е������ô˺���
	if XAbortLoop(abortButton) then
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
	XSleep(mSleep)
	XMoveMouseRelative(mx-nextXMove,my-nextYMove)
end

function XMoveMouseTo(dx,dy)
	if (XAbortLoop(abortButton)) then
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
		XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
		return
	end
	XMoveMouseRelative(nextXMove,nextYMove) --����һ���ƶ���С��Χ��
	XSleep(mSleep)
	XMoveMouseTo(dx,dy)
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
	XSleep(XTimeShuffle())
	ReleaseMouseButton(button)
	XSleep(XTimeShuffle())
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
	XSleep(XTimeShuffle()/2)
	ReleaseMouseButton(button)
	XSleep(XTimeShuffle())
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
	return flag
end

function XPressMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	PressMouseButton(button)
end

function XReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
		XAbortMacro()
		return false
	end
	ReleaseMouseButton(button)
end

--����Ϊ���ú���
function XPositionShuffle()
	local range=30
	--return math.random()*range*2-range
	return 0
end

function XTimeShuffle()
	return 50+math.random()*50
end
--������������������������������MOUSE������������������������������--