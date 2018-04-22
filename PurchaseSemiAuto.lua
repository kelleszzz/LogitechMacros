--ˢ�������ɶ���,���ٹ��������Ϊȫ��״̬�µĲ��ɶ���
status=nil
enableSwiftBuying=true
skipBackwardOnce=false --����ǰ����ˢ��ʱ,����ٰ����˺��˼�,���˼�Ҳ�����ִ��һ�κ�,������Ҫ����β���Ҫ��ִ������
function OnEvent(event, arg)
	--����
	abortButton=nil
	funcDoClear=function()
		status=nil
	end
	--�߼�
	if (event == "MOUSE_BUTTON_PRESSED" and arg == FORWARD) then --�����ǰ��������ʱ
		if XPlayMacro("Refresh")==false then return end
		--����
		abortButton=BACKWARD
		funcDoClear=function()
			status=nil
			skipBackwardOnce=true
		end
		while mRunning==true do
			Refresh()
		end
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == BACKWARD and enableSwiftBuying==true) then --����귵�ؼ�����ʱ
		if skipBackwardOnce==true then
			skipBackwardOnce=false
			return
		end
		if XPlayMacro("Refresh")==false then return end
		--����
		abortButton=-BACKWARD
		while mRunning==true do
			SwiftBuying()
		end
		XAbortMacro()
	end
	if (event == "MOUSE_BUTTON_PRESSED" and arg == MIDDLE) then --������м�����ʱ
		local px,py=GetMousePosition()
		if status==nil then status=PRESS_WANTED_CATEGORY end
		if status==PRESS_WANTED_CATEGORY then 
			pressWantedCategory.px=px
			pressWantedCategory.py=py
			OutputLogMessage("[Wanted Category] = (%s,%s) ----> [Refresh-Token] \n",""..px,""..py)
			status=PRESS_REFRESH_TOKEN 
		elseif status==PRESS_REFRESH_TOKEN then
			pressRefreshToken.px=px
			pressRefreshToken.py=py
			OutputLogMessage("[Refresh-Token] = (%s,%s) ----> [Wanted Item] \n",""..px,""..py)
			status=PRESS_WANTED_ITEM
		elseif status==PRESS_WANTED_ITEM then
			pressWantedItem.px=px
			pressWantedItem.py=py
			OutputLogMessage("[Wanted Item] = (%s,%s) ----> [Restart - Wanted Category] \n",""..px,""..py)
			status=nil
		else
			PrintPosition()
		end
	end
end

function Refresh()
	positionValid=true
	if (CheckPositionValid(pressWantedCategory)==false) then positionValid=false end
	if (CheckPositionValid(pressRefreshToken)==false) then positionValid=false end
	if (CheckPositionValid(pressWantedItem)==false) then positionValid=false end
	if (positionValid==true) then
		--��ʼ���
		if XMoveMouseToPosition(pressRefreshToken,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(pressWantedCategory,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(pressWantedItem,XWaitLongTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		Sleep(XTimeShuffle()*2)
	else
		OutputLogMessage("Not all the positions are valid.\n")
		return false
	end
end

--������������������������������PURCHASEBASIC������������������������������--
PRESS_WANTED_CATEGORY,PRESS_REFRESH_TOKEN,PRESS_WANTED_ITEM,PRESS_BUYING_ITEM,ADD_NUMBER,PURCHASE,PURCHASE_CONFIRM,CANCEL_SUBSTITUTION=1,2,3,4,5,6,7,8
pressWantedCategory={px=9665,py=22898}
pressRefreshToken={px=9801,py=30125}
pressWantedItem={px=31623,py=23566}
pressBuyingItem={px=31555,py=24052}
addNumber={px=38658,py=32919}
purchase={px=32750,py=45188}
purchaseConfirm={px=42927,py=45067}
cancelSubstitution={px=22744,py=44824}
buyingNumber=3 --һ����3��
function SwiftBuying()
	positionValid=true
	if (CheckPositionValid(pressBuyingItem)==false) then positionValid=false end
	if (CheckPositionValid(addNumber)==false) then positionValid=false end
	if (CheckPositionValid(purchase)==false) then positionValid=false end
	if (CheckPositionValid(purchaseConfirm)==false) then positionValid=false end
	if (CheckPositionValid(cancelSubstitution)==false) then positionValid=false end
	if (positionValid==true) then
		if XMoveMouseToPosition(pressBuyingItem,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(addNumber,XWaitShortTime)==false then return false end
		for t=1,(buyingNumber-1) do
			if XPressAndReleaseMouseButton(1)==false then return false end
		end
		if XMoveMouseToPosition(purchase,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(purchaseConfirm,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
		if XMoveMouseToPosition(cancelSubstitution,XWaitShortTime)==false then return false end
		if XPressAndReleaseMouseButton(1)==false then return false end
	else
		OutputLogMessage("Not all the positions are valid.\n")
		return false
	end
end

function XWaitMicroTime()
	Sleep(XTimeShuffle()/4)
end

function XWaitShortTime()
	Sleep(XTimeShuffle())
end

function XWaitLongTime()
	Sleep(XTimeShuffle()*5)
end

function XMoveMouseToPosition(tab,sleepFunc)
	if tab==nil then return end
	if XMoveMouseTo(tab.px,tab.py)==false then return false end
	if sleepFunc~=nil then
		sleepFunc()
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
--������������������������������PURCHASEBASIC������������������������������--
--������������������������������BASIC������������������������������--
MIDDLE,BACKWARD,FORWARD=3,4,5
abortButton=nil --Ϊ����ʱ,��ʾ������ֹͣ;Ϊ����ʱ,��ʾ�ſ���ֹͣ
mRange=1200
mSleep=3
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
	return math.random()*range*2-range
end

function XTimeShuffle()
	return 50+math.random()*50
end
--������������������������������MOUSE������������������������������--
