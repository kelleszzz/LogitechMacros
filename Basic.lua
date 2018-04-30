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