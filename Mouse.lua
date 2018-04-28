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
	if XSleep(mSleep)==false then return false end
	if XMoveMouseRelative(mx-nextXMove,my-nextYMove)==false then return false end
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
		return XMoveMouseRelative(nextXMove+XPositionShuffle(),nextYMove+XPositionShuffle()) 
	end
	--����һ���ƶ���С��Χ��
	if XMoveMouseRelative(nextXMove,nextYMove)==false then return false end
	if XSleep(mSleep)==false then return false end
	if XMoveMouseTo(dx,dy)==false then return false end
end

function XPressAndReleaseMouseButton(button)
	if (XAbortLoop(abortButton)) then
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

