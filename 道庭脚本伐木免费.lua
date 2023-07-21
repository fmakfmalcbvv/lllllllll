local DTlib = loadstring(game:HttpGet('https://pastebin.com/raw/xmLF2xRN'))()

    local _CONFIGS = {  --> 游戏配置列表, 如果不懂请勿修改, 可以改数字
	   ["UI_NAME"] = define,
	   ["总开关"] = nil,
	   ["防误触开关"] = true,
	   ["cutPlankByDT"] = nil,
	   ["无限跳"] = false,
	   ["穿墙开关"] = false,
	   ["飞行开关"] = false,
	   ["isBuying"] = false,
	   ["取消购买"] = false,
	   ["处理木头"] = false,
	   ["处理木头并加工"] = false,
	   ["点击砍树"] = false,
	   ["填充工具"] = false,
	   ["刷粉车"] = false,
	   ["粉车器"] = nil,
	   ["自动砍树"] = nil,
	   ["UI长"] = 250,
	   ["UI宽"] = 300,
	   ["传送模式"] = 2,
	   ["飞行速度"] = 4,
	   ["步行速度"] = 16,
	   ["跳跃力"] = 50,  --> 比如这个50  代表加载脚本初始的跳跃力是50, 可以改 100或者150等等
	   ["悬浮高度"] = 0,
	   ["重力"] = 198,
	   ["相机焦距"] = 100,
	   ["广角"] = 70,
	};
	
	local function ClearConfig()  --> 清除游戏配置功能
		if _CONFIGS["总开关"] ~= nil then
			_CONFIGS["总开关"]:Disconnect()
			_CONFIGS["总开关"] = nil;
			_CONFIGS["防误触开关"] = nil;
			_CONFIGS["无限跳"] = false;
			_CONFIGS["穿墙开关"] = false;
			_CONFIGS["UI长"] = 250;
			_CONFIGS["UI宽"] = 300;
			_CONFIGS["飞行速度"] = 4
			_CONFIGS["飞行开关"] = false
			_CONFIGS["isBuying"] = false;
			getgenv()["点击出售木头"] = false;
			_CONFIGS["取消购买"] = false;
			_CONFIGS["传送模式"] = 2;
			_CONFIGS["处理木头"] = false;
			_CONFIGS["处理木头并加工"] = false
			_CONFIGS["点击砍树"] = false;
			_CONFIGS["填充工具"] = false
			_CONFIGS["刷粉车"] = false
			if getgenv().Test then
				getgenv().Test:Disconnect();
				getgenv().Test = nil;
			end
		

			if _CONFIGS["cutPlankByDT"] then
				_CONFIGS["cutPlankByDT"]:Disconnect();
				_CONFIGS["cutPlankByDT"] = nil;
			end
			if _G.OrigDrag then
				_G.OrigDrag = nil
			end
			if clickSellLog then
				clickSellLog:Disconnect();
				clickSellLog = nil;
			end
			if mod then
				mod:Disconnect();
				mod = nil;
			end
			if _CONFIGS["自动砍树"] then
				_CONFIGS["自动砍树"]:Disconnect();
				_CONFIGS["自动砍树"] = nil;
			end
			if DayOfNight then
			    DayOfNight:Disconnect()
			    DayOfNight = nil
			end
			if getgenv().PlankToBp then
			    getgenv().PlankToBp:Disconnect()
			    getgenv().PlankToBp = nil
			end
			if _CONFIGS["粉车器"] then
				_CONFIGS["粉车器"]:Disconnect();
				_CONFIGS["粉车器"] = nil;
			end
		end
	end
	ClearConfig()
	
	function ifError(msg)
		warn("脚本出问题辣!")
		writefile(string.format("道庭DT错误日志%s.txt", os.date():sub(11):gsub(" ", "-")), string.format("具体错误原因为:\n %s", msg))
	end
	
	local DT = {
		GS = function(...)
			return game.GetService(game, ...);
		end;
	}
	
	
	DT.RS = DT.GS"RunService"
	DT.RES = DT.GS"ReplicatedStorage"
	DT.LIGHT = DT.GS"Lighting"
	DT.TPS = DT.GS"TeleportService"
	DT.LP = DT.GS"Players".LocalPlayer
	DT.WKSPC = DT.GS"Workspace"
	DT.COREGUI = DT.GS "CoreGui";
	local Mouse = DT.LP:GetMouse()
	
	
	function DT:printf(...)
		print(string.format(...));
	end
	
	function DT:SelectNotify(...)
		local Args = {
			...
		}
		local NotificationBindable = Instance.new("BindableFunction")
		NotificationBindable.OnInvoke = Args[6]
		game.StarterGui:SetCore("SendNotification", {
			Title = Args[1],
			Text = Args[2],
			Icon = nil,
			Duration = Args[5],
			Button1 = Args[3],
			Button2 = Args[4],
			Callback = NotificationBindable
		})
		return Args
	end
	
	
	function DT:DragModel(...)  --> 移动模型功能
		local Args = {
			...
		};
		assert(Args[1]:IsA("Model") == true, "参数1必须是模型!");
		if _CONFIGS["传送模式"] == 1 then
			pcall(function()
				self.RES.Interaction.ClientIsDragging:FireServer(Args[1])
			end);
			Args[1]:PivotTo(Args[2]);
		elseif _CONFIGS["传送模式"] == 2 then
			pcall(function()
				self.RES.Interaction.ClientIsDragging:FireServer(Args[1])
			end);
			if not Args[1].PrimaryPart then
				Args[1].PrimaryPart = Args[1]:FindFirstChildOfClass("Part")
			end
			Args[1]:SetPrimaryPartCFrame(Args[2])
		end
	end
	
	function DT:Teleport(...)  --> 传送功能
		local Args = {
			...
		};
		if self.LP.Character.Humanoid.SeatPart then
			spawn(function()
				for i = 1, 15 do
					self:DragModel(self.LP.Character.Humanoid.SeatPart.Parent, Args[1]);
				end
			end)
			return;
		end
		for i = 1, 3 do
			self:DragModel(self.LP.Character, Args[1]);
			task.wait();
		end
	end
	
	function DT:TP(x, y, z)
		self:Teleport(CFrame.new(x, y, z));
	end
	
	function DT:ServiceTP(ID)  --> 跳转服务器功能, 用于重进服务器
		DT.TPS:Teleport(ID, DT.LP)
    end

				--↓ 以下请勿修改
	    _CONFIGS["总开关"] = DT.RS.RenderStepped:Connect(function()
		pcall(function()
			DT.LP.Character.Humanoid.WalkSpeed = _CONFIGS["步行速度"]
			DT.LP.Character.Humanoid.JumpPower = _CONFIGS["跳跃力"]
			DT.LP.Character.Humanoid.HipHeight = _CONFIGS["悬浮高度"]
			DT.WKSPC.Gravity = _CONFIGS["重力"]
			DT.LP.CameraMaxZoomDistance = _CONFIGS["相机焦距"]
			DT.WKSPC.Camera.FieldOfView = _CONFIGS["广角"]
		end)
	end)
	
	
	function DT:NOTIFY(title, text, duration) --> 通知功能
	    return library:Notify({
	           Title = title, 
	           Text = text,
	           Duration = duration
	       })
	end
	
	--↓ 双引号里面的中文可以修改, 对应的是脚本UI的菜单名字
	local DTwin1 = library:CreateTab("设置菜单");
	local DTwin2 = library:CreateTab("玩家菜单");
	local DTwin3 = library:CreateTab("购买菜单");
	local DTwin4 = library:CreateTab("木材菜单");
	local DTwin5 = library:CreateTab("传送菜单");
	local DTwin6 = library:CreateTab("环境菜单");
	local DTwin7 = library:CreateTab("基地菜单");
	local DTwin8 = library:CreateTab("汽车菜单");
	
	
	DTwin1:NewToggle("防误触", "Mistouch", true, function(v)
	    _CONFIGS["防误触开关"] = v;
	end)
	
	DTwin1:NewButton("关闭脚本", function()
	    	if _CONFIGS["防误触开关"] == true then
			DT:SelectNotify("防误触", "确定要关闭脚本吗?", "确定", "取消", 5, function(text) --> 双引号里面的中文可以改
				if text == "确定" then
					xpcall(function()
						for i, v in next, DT.COREGUI:GetDescendants() do
							if v.Name == _CONFIGS.UI_NAME then
								v:Destroy()
								ClearConfig()
							end
						end
					end, function(err)
						return DT:printf("错误是:  %s", err)
					end)
					return
				end
				DT:NOTIFY("通知", "已取消", 4) --> 双引号里面的中文可以改
			end)
			return
		end
		xpcall(function()
			for i, v in next, DT.COREGUI:GetDescendants() do
				if v.Name == _CONFIGS.UI_NAME then
					v:Destroy()
					ClearConfig()
				end
			end
		end, function(err)
			return DT:printf("错误是:  %s", err)
		end)
	end)
	
	DTwin1:NewButton("重进服务器", function()
		if _CONFIGS["防误触开关"] == true then
			DT:SelectNotify("防误触", "确定要重进服务器吗?", "确定", "取消", 5, function(text) --> 双引号里面的中文可以改
				if text == "确定" then
					xpcall(function()
						DT:ServiceTP(game.PlaceId)
					end, function(err)
						return DT:printf("错误是:  %s", err)
					end)
					return
				end
				DT:NOTIFY("通知", "已取消", 4) --> 双引号里面的中文可以改
			end)
			return
		end
		xpcall(function()
			DT:ServiceTP(game.PlaceId)
		end, function(err)
			return DT:printf("错误是:  %s", err)
		end)
	end)
	
	DTwin1:NewSeparator()
	
	
	DTwin1:NewButton("脚本作者  锋芒阿康", function()
		print("感谢 锋芒阿康")
	end)
	
	DTwin1:NewButton("脚本合作者  猫猫", function()
		print("感谢 猫猫")
	end)
	
	DTwin1:NewButton("Woof UI Library  平民", function()
		print("感谢 Step")
	end)
	
	DTwin1:NewButton("UI提供 紅", function()
		print("感谢 紅")
	end)
	
	DTwin1:NewButton("部分功能来源 紅", function()
		print("感谢 紅")
	end)
	
	DTwin1:NewButton("感谢粉丝们的支持", function()
		print("感谢粉丝")
	end)
	
	
	DTwin1:NewButton("最大支持  你们", function()
		print("感谢 你们")
	end)
	
	
	DTwin2:NewSlider("步行速度", "步行速度slider", 50, 16, 300, false, function(v)
		_CONFIGS["步行速度"] = v;
	end)
	
	DTwin2:NewSlider("跳跃力", "跳跃力slider", 50, 50, 300, false, function(v)
		_CONFIGS["跳跃力"] = v;
	end)
	
	DTwin2:NewSlider("飞行速度","飞行速度slider", 4, 1, 100, false, function(v)
		_CONFIGS["飞行速度"] = tonumber(v)
	end)
	
	DTwin2:NewToggle("飞行", "fly", false, function(bool)
	    _CONFIGS["飞行开关"] = bool
		speeds = _CONFIGS["飞行速度"]
		if _CONFIGS["飞行开关"] == false then
			_CONFIGS["飞行开关"] = true
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
			DT.LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		else
			_CONFIGS["飞行开关"] = false
			for i = 1, speeds do
				spawn(
	                function()
					local hb = game:GetService("RunService").Heartbeat
					tpwalking = true
					local chr = DT.LP.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
			DT.LP.Character.Animate.Disabled = true
			local Char = DT.LP.Character
			local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
			for i, v in next, Hum:GetPlayingAnimationTracks() do
				v:AdjustSpeed(0)
			end
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
			DT.LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
			DT.LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		if DT.LP.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
			local torso = DT.LP.Character.Torso
			local flying = true
			local deb = true
			local ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local maxspeed = 50
			local speed = 0
			local bg = Instance.new("BodyGyro", torso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = torso.CFrame
			local bv = Instance.new("BodyVelocity", torso)
			bv.velocity = Vector3.new(0, 0.1, 0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if _CONFIGS["飞行开关"] == false then
				DT.LP.Character.Humanoid.PlatformStand = true
			end
			while _CONFIGS["飞行开关"] == false or DT.LP.Character.Humanoid.Health == 0 do
				game:GetService("RunService").RenderStepped:Wait()
				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed + .5 + (speed / maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed - 1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
					lastctrl = {
						f = ctrl.f,
						b = ctrl.b,
						l = ctrl.l,
						r = ctrl.r
					}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end
				bg.cframe = DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.Angles(- math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
			end
			ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			DT.LP.Character.Humanoid.PlatformStand = false
			DT.LP.Character.Animate.Disabled = false
			tpwalking = false
		else
			local UpperTorso = DT.LP.Character.UpperTorso
			local flying = true
			local deb = true
			local ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			local maxspeed = 50
			local speed = 0
			local bg = Instance.new("BodyGyro", UpperTorso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = UpperTorso.CFrame
			local bv = Instance.new("BodyVelocity", UpperTorso)
			bv.velocity = Vector3.new(0, 0.1, 0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if _CONFIGS["飞行开关"] == false then
				DT.LP.Character.Humanoid.PlatformStand = true
			end
			while _CONFIGS["飞行开关"] == false or DT.LP.Character.Humanoid.Health == 0 do
				wait()
				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed + .5 + (speed / maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed - 1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
					lastctrl = {
						f = ctrl.f,
						b = ctrl.b,
						l = ctrl.l,
						r = ctrl.r
					}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((DT.WKSPC.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - DT.WKSPC.CurrentCamera.CoordinateFrame.p)) * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end
				bg.cframe = DT.WKSPC.CurrentCamera.CoordinateFrame * CFrame.Angles(- math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
			end
			ctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			DT.LP.Charactder.Humanoid.PlatformStand = false
			DT.LP.Character.Animate.Disabled = false
			tpwalking = false
		end
	end)
	
	function togggleInvisible(num)
		for i, v in pairs(DT.LP.Character:children()) do
			if v:IsA("Accessory") then
				for i, k in pairs(v:children()) do
					if k:IsA("Part") then
						k.Transparency = num
					end
				end
			end
			if v:IsA("Part") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = num;
				if v.Name == "Head" then
					v:FindFirstChild"face".Transparency = num;
				end
			end
		end
	end
	
	DTwin2:NewSlider("悬浮高度", "悬浮slider", 0, 0, 300, false, function(v)
		_CONFIGS["悬浮高度"] = v;
	end)
	
	DTwin2:NewSlider("重力", "重力slider", 198, 0, 300, false, function(v)
		_CONFIGS["重力"] = v;
	end)
	
	DTwin2:NewToggle("无限跳", "toggleInfJump", false, function(bool)
	    _CONFIGS["无限跳"] = bool;
		DT.GS("UserInputService").JumpRequest:Connect(function()
			if _CONFIGS["无限跳"] == true then
			 --   DT.WKSPC.Gravity = 198; -- 防止两个都开造成卡顿
				DT.LP.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
			end
		end)
	end)
	
	DTwin2:NewToggle("穿墙", "toggleNoclip", false, function(bool)
	    _CONFIGS["穿墙开关"] = bool;
		local IsNoclip = DT.RS.Stepped:Connect(function()
			for i, v in next, DT.LP.Character:GetDescendants() do
				if _CONFIGS["穿墙开关"] then
					if v:IsA"BasePart" then
						v.CanCollide = false
					else
						pcall(
	                            function()
							IsNoclip:Disconnect()
							IsNoclip = nil;
						end)
					end
				end
			end
		end)
	end)
	
	DTwin2:NewButton("安全自杀", function()
	    if not DT.LP.Character then
			return
		end
		DT.LP.Character.Head:Destroy()
		_CONFIGS["isBuying"] = false; --> 如果卡在了正在购买, 可以通过自杀来解决
	end)
	
	DTwin2:NewButton("点击传送 [工具]", function()
	    if DT.LP.Backpack:FindFirstChild"点击传送" or DT.LP.Character:FindFirstChild"点击传送" then
			DT.LP.Backpack["点击传送"]:Destroy()
		end
		local ClickToTeleport = Instance.new("Tool", DT.LP.Backpack)
		ClickToTeleport.Name = "点击传送"
		ClickToTeleport.RequiresHandle = false
		ClickToTeleport.Activated:Connect(function()
			local x = Mouse.hit.x
			local y = Mouse.hit.y
			local z = Mouse.hit.z
			DT:Teleport(CFrame.new(x, y, z) + Vector3.new(0, 3, 0))
		end)
	end)
	
	DTwin2:NewSeparator()
	
	DTwin2:NewSlider("相机焦距", "焦距slider", 2000, 100, 2000, false, function(v)
	    _CONFIGS["相机焦距"] = v;
	end)
	
	
	DTwin2:NewSlider("广角", "广角slider", 70, 70, 120, false, function(v)
	    _CONFIGS["广角"] = v;
	end)
	
	local cameraType = {  --> 游戏相机视角类型
		"Fixed";-- 静止
		"Follow";-- 跟随
	    "Attach"; -- 固定
		"Track";-- 不会自动旋转
		"Watch";-- 静止状态, 旋转保持
		"Custom";-- 默认
		"Scriptable";
	}
	
	DTwin2:NewDropdown("选择相机模式", "相机模式", cameraType, function(v)
	    cameraType = v;
	end)
	
	DTwin2:NewButton("确认选择", function()
	    if type(cameraType) == "table" then return end
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType[cameraType]
	end)
	
	DTwin2:NewButton("修复卡视角问题", function()
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType["Watch"]
		task.wait()
		DT.WKSPC.CurrentCamera.CameraType = Enum.CameraType["Custom"]
	end)
	
	DTwin2:NewButton("锁定视角脚本", function()
		xpcall(function()
			if DT.LP.PlayerGui:FindFirstChild("Shiftlock (StarterGui)") then
				return
			end
			local a = Instance.new("ScreenGui")
			local b = Instance.new("ImageButton")
			a.Name = "Shiftlock (StarterGui)"
			a.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			a.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
			b.Parent = a;
			b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			b.BackgroundTransparency = 1.000;
			b.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
			b.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
			b.SizeConstraint = Enum.SizeConstraint.RelativeXX;
			b.Image = "http://www.roblox.com/asset/?id=182223762"
			local function c()
				local a = Instance.new('LocalScript', b)
				local b = {}
				local c = game:GetService("Players")
				local d = game:GetService("RunService")
				local e = game:GetService("ContextActionService")
				local c = c.LocalPlayer;
				local c = c.Character or c.CharacterAdded:Wait()
				local f = c:WaitForChild("HumanoidRootPart")
				local c = c.Humanoid;
				local g = workspace.CurrentCamera;
				local a = a.Parent;
				uis = game:GetService("UserInputService")
				ismobile = uis.TouchEnabled;
				a.Visible = ismobile;
				local h = {
					OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
					ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
				}
				local i = 900000;
				local j = false;
				local k = CFrame.new(1.7, 0, 0)
				local l = CFrame.new(- 1.7, 0, 0)
				local function m(b)
					a.Image = h[b]
				end;
				local function h(a)
					c.AutoRotate = a
				end;
				local function c(a, a)
					return CFrame.new(f.Position, Vector3.new(a.CFrame.LookVector.X * i, f.Position.Y, a.CFrame.LookVector.Z * i))
				end;
				local function i()
					h(false)
					m("ON")
					f.CFrame = c(f, g)
					g.CFrame = g.CFrame * k
				end;
				local function c()
					h(true)
					m("OFF")
					g.CFrame = g.CFrame * l;
					pcall(function()
						j:Disconnect()
						j = nil
					end)
				end;
				m("OFF")
				j = false;
				function ShiftLock()
					if not j then
						j = d.RenderStepped:Connect(function()
							i()
						end)
					else
						c()
					end
				end;
				local f = e:BindAction("ShiftLOCK", ShiftLock, false, "On")
				e:SetPosition("ShiftLOCK", UDim2.new(0.8, 0, 0.8, 0))
				a.MouseButton1Click:Connect(function()
					if not j then
						j = d.RenderStepped:Connect(function()
							i()
						end)
					else
						c()
					end
				end)
				return b
			end;
			coroutine.wrap(c)()
			local function b()
				local a = Instance.new('LocalScript', a)
				local a = game:GetService("Players")
				local b = game:GetService("UserInputService")
				local c = UserSettings()
				local c = c.GameSettings;
				local d = {}
				while not a.LocalPlayer do
					wait()
				end;
				local a = a.LocalPlayer;
				local e = a:GetMouse()
				local f = a:WaitForChild("PlayerGui")
				local g, h, h;
				local i = true;
				local j = true;
				local k = false;
				local l = false;
				d.OnShiftLockToggled = Instance.new("BindableEvent")
				local function m()
					return a.DevEnableMouseLock and c.ControlMode == Enum.ControlMode.MouseLockSwitch and a.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and c.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and a.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
				end;
				if not b.TouchEnabled then
					i = m()
				end;
				local function n()
					j = not j;
					d.OnShiftLockToggled:Fire()
				end;
				local o = function()
					
				end;
				function d:IsShiftLocked()
					return i and j
				end;
				function d:SetIsInFirstPerson(a)
					l = a
				end;
				local function l(a, a, a)
					if i then
						n()
					end
				end;
				local function l()
					if g then
						g.Parent = nil
					end;
					i = false;
					e.Icon = ""
					if h then
						h:disconnect()
						h = nil
					end;
					k = false;
					d.OnShiftLockToggled:Fire()
				end;
				local e = function(a, b)
					if b then
						return
					end;
					if a.UserInputType ~= Enum.UserInputType.Keyboard or a.KeyCode == Enum.KeyCode.LeftShift or a.KeyCode == Enum.KeyCode.RightShift then
					end
				end;
				local function n()
					i = m()
					if i then
						if g then
							g.Parent = f
						end;
						if j then
							d.OnShiftLockToggled:Fire()
						end;
						if not k then
							h = b.InputBegan:connect(e)
							k = true
						end
					end
				end;
				c.Changed:connect(function(a)
					if a == "ControlMode" then
						if c.ControlMode == Enum.ControlMode.MouseLockSwitch then
							n()
						else
							l()
						end
					elseif a == "ComputerMovementMode" then
						if c.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
							l()
						else
							n()
						end
					end
				end)
				a.Changed:connect(function(b)
					if b == "DevEnableMouseLock" then
						if a.DevEnableMouseLock then
							n()
						else
							l()
						end
					elseif b == "DevComputerMovementMode" then
						if a.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or a.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
							l()
						else
							n()
						end
					end
				end)
				a.CharacterAdded:connect(function(a)
					if not b.TouchEnabled then
						o()
					end
				end)
				if not b.TouchEnabled then
					o()
					if m() then
						h = b.InputBegan:connect(e)
						k = true
					end
				end;
				n()
				return d
			end;
			coroutine.wrap(b)()
		end, ifError)
	end)
	
	getgenv()["物品总数"] = 1;
	
	DTwin3:NewSlider("物品数量", "buycountslider", 1, 1, 25, false, function(v)
	    getgenv()["物品总数"] = v;
	end)
	
	getgenv()["不想购买"] = false;
	
	DTwin3:NewButton("停止购买", function()
	    getgenv()["不想购买"] = true;
	    wait(1)
	    getgenv()["不想购买"] = false;
	end)
	
	DTwin3:NewSeparator();
	
	local WoodRus_Store = {
		"基础斧头 12$",
		"普通斧头 90$",
		"钢斧 190$",
		"硬化斧 550$",
		"银斧头 2040$",
		"破旧锯木厂 130$",
		"普通锯木厂 1600$",
		"锯木机01 11000$",
		"锯木机02 22500$",
		"锯木机02L 86500$",
		"多用途运载车 400$",
		"工作灯 80$",
		"沙子袋 1600$",
		"劈锯 12200$",
		"铁丝 205$",
		"按钮 320$",
		"控制杆 520$",
		"压力板 640$",
		"急弯传送带 100$",
		"直式传送带 80$",
		"漏斗式传送带 60$",
		"倾斜传送带 95$",
		"左转直式传送带 480$",
		"右转直式传送带 480$",
		"切换传送器 320$",
		"木头清扫机 430$",
		"传送带支架 12$",
	}
	
	local function newDragModel(model, cframe)
	    if not model.PrimaryPart then
	        model.PrimaryPart = model:FindFirstChildOfClass("Part")
	    end
	    DT.RES.Interaction.ClientIsDragging:FireServer(model)
	    model.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
	    model:PivotTo(cframe)
	end
	
	local function getShopId(c, n, i)
		return {
			["Character"] = c,
			["Name"] = n,
			["ID"] = tonumber(i)
		}
	end
	
	local Stores = {
		["WoodRUs"] = getShopId(DT.WKSPC.Stores.WoodRUs.Thom, "Thom", 7);
		["FurnitureStore"] = getShopId(DT.WKSPC.Stores.FurnitureStore.Corey, "Corey", 8);
		["CarStore"] = getShopId(DT.WKSPC.Stores.CarStore.Jenny, "Jenny", 9);
		["ShackShop"] = getShopId(DT.WKSPC.Stores.ShackShop.Bob, "Bob", 10);
		["LandStore"] = getShopId(DT.WKSPC.Stores.LandStore.Ruhven, "Ruhven", 1);
		["FineArt"] = getShopId(DT.WKSPC.Stores.FineArt.Timothy, "Timothy", 11);
		["LogicStore"] = getShopId(DT.WKSPC.Stores.LogicStore.Lincoln, "Lincoln", 12);
		["TollBooth0"] = getShopId(DT.WKSPC.Bridge.TollBooth0.Seranok, "Seranok", 14);
		["Ferry"] = getShopId(DT.WKSPC.Ferry.Ferry.Hoover, "Hoover", 15);
		["Region_Main"] = getShopId(DT.WKSPC.Region_Main:FindFirstChild("Strange Man"), "Strange Man", 3);
	};
	
	
	local function buyItem(count, store, item, name)
		if type(item) == "table" then
			DT:NOTIFY("错误", "请先选择商品!", 4)
			return
		end
		count = count or 1
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame;
		local sum = 0;
		while sum < count  do
		    if getgenv()["不想购买"] == true then
		        DT:Teleport(oldpos)
				return
		    end
		    
			local Item
			for i, v in next, DT.WKSPC.Stores:children() do
				if v.Name == "ShopItems" and v:FindFirstChild"Box" then
					for j, k in next, v:children() do
						if k.BoxItemName.Value == item then
							ltem = k
						end
					end
				end
			end
			repeat
				DT.RS.Heartbeat:wait()
			until ltem ~= nil
			DT:Teleport(ltem.Main.CFrame + Vector3.new(0, 1, 5))
			task.wait(0.5)
			repeat
			    if getgenv()["不想购买"] == true then
		            DT:Teleport(oldpos)
				    return
		        end
				newDragModel(ltem, DT.WKSPC.Stores[name].Counter.CFrame + Vector3.new(0, .6, 0))
				DT:Teleport(ltem.Main.CFrame + Vector3.new(0, 1, 5))
				task.wait(0.2)
	            --print((ltem.Main.Position - DT.WKSPC.Stores[name].Counter.Position).Magnitude)
			until (ltem.Main.Position - DT.WKSPC.Stores[name].Counter.Position).Magnitude < 5;
			task.wait(0.4)
			DT:Teleport(DT.WKSPC.Stores[name].Counter.CFrame + Vector3.new(0, 5, 5))
			DT.RS.Heartbeat:wait()
			repeat
				DT.RS.Heartbeat:wait()
				if getgenv()["不想购买"] == true then
		            DT:Teleport(oldpos)
				    return
		        end
				DT.RES.Interaction.ClientIsDragging:FireServer(ltem)
				DT.RES.NPCDialog.PlayerChatted:InvokeServer(store, "ConfirmPurchase")
			until ltem.Owner.Value == DT.LP or ltem.Owner.Value ~= nil
			for i = 1, 30 do
				newDragModel(ltem, oldpos)
				task.wait(0.01)
			end
			task.wait(0.5)
			sum = sum + 1
		end
		DT:Teleport(oldpos)
	end
	
	DTwin3:NewDropdown("反斗城商品", "shop_woodrus", WoodRus_Store, function(WShop)
	    if WShop == "基础斧头 12$" then
			WoodRus_Store = "BasicHatchet"
		end
		if WShop == "普通斧头 90$" then
			WoodRus_Store = "Axe1"
		end
		if WShop == "钢斧 190$" then
			WoodRus_Store = "Axe2"
		end
		if WShop == "硬化斧 550$" then
			WoodRus_Store = "Axe3"
		end
		if WShop == "银斧头 2040$" then
			WoodRus_Store = "SilverAxe"
		end
		if WShop == "破旧锯木厂 130$" then
			WoodRus_Store = "Sawmill"
		end
		if WShop == "普通锯木厂 1600$" then
			WoodRus_Store = "Sawmill2"
		end
		if WShop == "锯木机01 11000$" then
			WoodRus_Store = "Sawmill3"
		end
		if WShop == "锯木机02 22500$" then
			WoodRus_Store = "Sawmill4"
		end
		if WShop == "锯木机02L 86500$" then
			WoodRus_Store = "Sawmill4L"
		end
		if WShop == "多用途运载车 400$" then
			WoodRus_Store = "UtilityTruck"
		end
		if WShop == "工作灯 80$" then
			WoodRus_Store = "WorkLight"
		end
		if WShop == "沙子袋 1600$" then
			WoodRus_Store = "BagOfSand"
		end
		if WShop == "劈锯 12200$" then
			WoodRus_Store = "ChopSaw"
		end
		if WShop == "铁丝 205$" then
			WoodRus_Store = "Wire"
		end
		if WShop == "按钮 320$" then
			WoodRus_Store = "Button0"
		end
		if WShop == "控制杆 520$" then
			WoodRus_Store = "Lever0"
		end
		if WShop == "压力板 640$" then
			WoodRus_Store = "PressurePlate"
		end
		if WShop == "急弯传送带 100$" then
			WoodRus_Store = "TightTurnConveyor"
		end
		if WShop == "直式传送带 80$" then
			WoodRus_Store = "StraightConveyor"
		end
		if WShop == "漏斗式传送带 60$" then
			WoodRus_Store = "ConveyorFunnel"
		end
		if WShop == "倾斜传送带 95$" then
			WoodRus_Store = "TiltConveyor"
		end
		if WShop == "左转直式传送带 480$" then
			WoodRus_Store = "StraightSwitchConveyorLeft"
		end
		if WShop == "右转直式传送带 480$" then
			WoodRus_Store = "StraightSwitchConveyorRight"
		end
		if WShop == "切换传送器 320$" then
			WoodRus_Store = "ConveyorSwitch"
		end
		if WShop == "木头清扫机 430$" then
			WoodRus_Store = "LogSweeper"
		end
		if WShop == "传送带支架 12$" then
			WoodRus_Store = "ConveyorSupports"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["WoodRUs"], WoodRus_Store, "WoodRUs"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local BluePrintStore = {
		"篱笆[宽] 80$",
		"篱笆[窄] 80$",
		"篱笆角 80$",
		"矮篱笆[宽] 80$",
		"矮篱笆[窄] 80$",
		"矮篱笆角 80$",
		"光滑的墙[宽] 80$",
		"光滑的墙[窄] 80$",
		"光滑墙角 80$",
		"矮光滑墙[宽] 80$",
		"矮光滑墙[窄] 80$",
		"又矮又光滑的墙角 80$",
		"光滑墙立柱[宽] 80$",
		"光滑墙立柱[窄] 80$",
		"光滑墙角立柱 80$",
		"波纹墙[宽] 80$",
		"波纹墙[窄] 80$",
		"波纹墙角 80$",
		"矮波纹墙[宽] 80$",
		"矮波纹墙[窄] 80$",
		"矮波纹墙角 80$",
		"波纹墙立柱[宽] 80$",
		"波纹墙立柱[窄] 80$",
		"波纹墙角立柱 80$",
		"微型瓷砖 80$",
		"小型瓷砖 80$",
		"瓷砖 80$",
		"大型瓷砖 80$",
		"微型地板 80$",
		"小型地板 80$",
		"地板 80$",
		"大型地板 80$",
		"方桌 80$",
		"长桌 80$",
		"普通椅子 80$",
		"陡峭楼梯 80$",
		"楼梯 80$",
		"梯子 80$",
		"标志杆 80$",
		"普通门 80$",
		"半截门 80$",
		"宽敞门 80$",
		"4/4木楔 80$",
		"4/4x1 木楔 80$",
		"3/4木楔 80$",
		"3/4x1 木楔 80$",
		"2/4木楔 80$",
		"2/4x1木楔 80$",
		"1/4木楔 80$",
		"1/4x1木楔 80$",
		"3/3木楔 80$",
		"3/3x1 木楔 80$",
		"2/3木楔 80$",
		"2/3x1木楔 80$",
		"1/3木楔 80$",
		"1/3x1木楔 80$",
		"2/2木楔 80$",
		"2/2x1木楔 80$",
		"1/2木楔 80$",
		"1/2x1木楔 80$",
		"1/1木楔 80$",
		"1/1x1木楔 80$"
	}
	
	DTwin3:NewDropdown("蓝图商品", "shop_blueprint", BluePrintStore, function(item)
	    if item == "篱笆[宽] 80$" then
			BluePrintStore = "Wall3Tall"
		end
		if item == "篱笆[窄] 80$" then
			BluePrintStore = "Wall3TallThin"
		end
		if item == "篱笆角 80$" then
			BluePrintStore = "Wall3TallCorner"
		end
		if item == "矮篱笆[宽] 80$" then
			BluePrintStore = "Wall3"
		end
		if item == "矮篱笆[窄] 80$" then
			BluePrintStore = "Wall3Thin"
		end
		if item == "矮篱笆角 80$" then
			BluePrintStore = "Wall3Corner"
		end
		if item == "光滑的墙[宽] 80$" then
			BluePrintStore = "Wall2Tall"
		end
		if item == "光滑的墙[窄] 80$" then
			BluePrintStore = "Wall2TallThin"
		end
		if item == "光滑墙角 80$" then
			BluePrintStore = "Wall2TallCorner"
		end
		if item == "矮光滑墙[宽] 80$" then
			BluePrintStore = "Wall2"
		end
		if item == "矮光滑墙[窄] 80$" then
			BluePrintStore = "Wall2Thin"
		end
		if item == "又矮又光滑的墙角 80$" then
			BluePrintStore = "Wall2Corner"
		end
		if item == "光滑墙立柱[宽] 80$" then
			BluePrintStore = "Wall2Short"
		end
		if item == "光滑墙立柱[窄] 80$" then
			BluePrintStore = "Wall2ShortThin"
		end
		if item == "光滑墙角立柱 80$" then
			BluePrintStore = "Wall2ShortCorner"
		end
		if item == "波纹墙[宽] 80$" then
			BluePrintStore = "Wall1Tall"
		end
		if item == "波纹墙[窄] 80$" then
			BluePrintStore = "Wall1TallThin"
		end
		if item == "波纹墙角 80$" then
			BluePrintStore = "Wall1TallCorner"
		end
		if item == "矮波纹墙[宽] 80$" then
			BluePrintStore = "Wall1"
		end
		if item == "矮波纹墙[窄] 80$" then
			BluePrintStore = "Wall1Thin"
		end
		if item == "矮波纹墙角 80$" then
			BluePrintStore = "Wall1Corner"
		end
		if item == "波纹墙立柱[宽] 80$" then
			BluePrintStore = "Wall1Short"
		end
		if item == "波纹墙立柱[窄] 80$" then
			BluePrintStore = "Wall1ShortThin"
		end
		if item == "波纹墙角立柱 80$" then
			BluePrintStore = "Wall1ShortCorner"
		end
		if item == "微型瓷砖 80$" then
			BluePrintStore = "Floor2Tiny"
		end
		if item == "小型瓷砖 80$" then
			BluePrintStore = "Floor2Small"
		end
		if item == "瓷砖 80$" then
			BluePrintStore = "Floor2"
		end
		if item == "大型瓷砖 80$" then
			BluePrintStore = "Floor2Large"
		end
		if item == "微型地板 80$" then
			BluePrintStore = "Floor1Tiny"
		end
		if item == "小型地板 80$" then
			BluePrintStore = "Floor1Small"
		end
		if item == "地板" then
			BluePrintStore = "Floor1"
		end
		if item == "大型地板 80$" then
			BluePrintStore = "Floor1Large"
		end
		if item == "方桌 80$" then
			BluePrintStore = "Table1"
		end
		if item == "长桌 80$" then
			BluePrintStore = "Table2"
		end
		if item == "普通椅子 80$" then
			BluePrintStore = "Chair1"
		end
		if item == "陡峭楼梯 80$" then
			BluePrintStore = "Stair1"
		end
		if item == "楼梯 80$" then
			BluePrintStore = "Stair2"
		end
		if item == "梯子 80$" then
			BluePrintStore = "Ladder1"
		end
		if item == "标志杆 80$" then
			BluePrintStore = "Post"
		end
		if item == "普通门 80$" then
			BluePrintStore = "Door1"
		end
		if item == "半截门 80$" then
			BluePrintStore = "Door2"
		end
		if item == "宽敞门 80$" then
			BluePrintStore = "Door3"
		end
		if item == "4/4木楔 80$" then
			BluePrintStore = "Wedge1"
		end
		if item == "4/4x1 木楔 80$" then
			BluePrintStore = "Wedge1_Thin"
		end
		if item == "4/4木楔 80$" then
			BluePrintStore = "Wedge1"
		end
		if item == "4/4x1 木楔 80$" then
			BluePrintStore = "Wedge1_Thin"
		end
		if item == "3/4木楔 80$" then
			BluePrintStore = "Wedge2"
		end
		if item == "3/4x1 木楔 80$" then
			BluePrintStore = "Wedge2_Thin"
		end
		if item == "2/4木楔 80$" then
			BluePrintStore = "Wedge3"
		end
		if item == "2/4x1 木楔 80$" then
			BluePrintStore = "Wedge3_Thin"
		end
		if item == "1/4木楔 80$" then
			BluePrintStore = "Wedge4"
		end
		if item == "1/4x1 木楔 80$" then
			BluePrintStore = "Wedge4_Thin"
		end
		if item == "3/3木楔 80$" then
			BluePrintStore = "Wedge5"
		end
		if item == "3/3x1 木楔 80$" then
			BluePrintStore = "Wedge5_Thin"
		end
		if item == "2/3木楔 80$" then
			BluePrintStore = "Wedge6"
		end
		if item == "2/3x1 木楔 80$" then
			BluePrintStore = "Wedge6_Thin"
		end
		if item == "1/3木楔 80$" then
			BluePrintStore = "Wedge7"
		end
		if item == "1/3x1 木楔 80$" then
			BluePrintStore = "Wedge7_Thin"
		end
		if item == "2/2木楔 80$" then
			BluePrintStore = "Wedge8"
		end
		if item == "2/2x1 木楔 80$" then
			BluePrintStore = "Wedge8_Thin"
		end
		if item == "1/2木楔 80$" then
			BluePrintStore = "Wedge9"
		end
		if item == "1/2x1 木楔 80$" then
			BluePrintStore = "Wedge9_Thin"
		end
		if item == "1/1木楔 80$" then
			BluePrintStore = "Wedge10"
		end
		if item == "1/1x1 木楔 80$" then
			BluePrintStore = "Wedge10_Thin"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["WoodRUs"], BluePrintStore, "WoodRUs"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	DTwin3:NewButton("购买土地", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores.LandStore, "EnterPurchase")
	end)
	
	DTwin3:NewSeparator();
	
	local Car_Store = {
		"小型拖车 1800$",
		"531式拖车 13000$",
		"多用途运载车XL 5000$",
		"瓦尔的全功能拖车 19000$"
	}
	
	DTwin3:NewDropdown("盒子车行", "shop_woodrus", Car_Store, function(item)
	    if item == "小型拖车 1800$" then
			Car_Store = "SmallTrailer"
		end
		if item == "531式拖车 13000$" then
			Car_Store = "Trailer2"
		end
		if item == "多用途运载车XL 5000$" then
			Car_Store = "UtilityTruck2"
		end
		if item == "瓦尔的全功能拖车 19000$" then
			Car_Store = "Pickup1"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["CarStore"], Car_Store, "CarStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Furniture_Store = {
		"洗碗机 380$",
		"火炉 340$",
		"冰箱 310$",
		"马桶 90$",
		"床2 350$",
		"床1 250$",
		"大型玻璃板 550$",
		"玻璃板 220$",
		"小型玻璃板 50$",
		"微型玻璃板 12$",
		"普通玻璃门 720$",
		"灯泡 2600$",
		"照明灯 90$",
		"墙灯 90$",
		"台灯 90$",
		"落地灯 110$",
		"长沙发 320$",
		"双人沙发 200$",
		"扶手椅 140$",
		"惊悚冰柱灯串 910$",
		"琥珀色冰柱灯串 750$",
		"蓝色冰柱灯串 750$",
		"绿色冰柱灯串 750$",
		"红色冰柱灯串 750$",
		"烟花发射器 7500$",
		"薄柜子 80$",
		"橱柜 80$",
		"橱柜角 80$",
		"宽橱柜角 80$",
		"薄工作台面 80$",
		"工作台面 80$",
		"带水槽的工作台面 80$"
	}
	
	DTwin3:NewDropdown("家具店商品", "shop_f", Furniture_Store, function(item)
	    if item == "洗碗机 380$" then
			Furniture_Store = "Dishwasher"
		end
		if item == "火炉 340$" then
			Furniture_Store = "Stove"
		end
		if item == "冰箱 310$" then
			Furniture_Store = "Refridgerator"
		end
		if item == "马桶 90$" then
			Furniture_Store = "Toilet"
		end
		if item == "床2 350$" then
			Furniture_Store = "Bed2"
		end
		if item == "床1 250$" then
			Furniture_Store = "Bed1"
		end
		if item == "大型玻璃板 550$" then
			Furniture_Store = "GlassPane4"
		end
		if item == "玻璃板 220$" then
			Furniture_Store = "GlassPane3"
		end
		if item == "小型玻璃板 50$" then
			Furniture_Store = "GlassPane2"
		end
		if item == "微型玻璃板 12$" then
			Furniture_Store = "GlassPane1"
		end
		if item == "普通玻璃门 720$" then
			Furniture_Store = "GlassDoor1"
		end
		if item == "灯泡 2600$" then
			Furniture_Store = "LightBulb"
		end
		if item == "照明灯 90$" then
			Furniture_Store = "WallLight2"
		end
		if item == "墙灯 90$" then
			Furniture_Store = "WallLight1"
		end
		if item == "台灯 90$" then
			Furniture_Store = "Lamp1"
		end
		if item == "落地灯 110$" then
			Furniture_Store = "FloorLamp1"
		end
		if item == "长沙发 320$" then
			Furniture_Store = "Seat_Couch"
		end
		if item == "双人沙发 200$" then
			Furniture_Store = "Seat_Loveseat"
		end
		if item == "扶手椅 140$" then
			Furniture_Store = "Seat_Armchair"
		end
		if item == "惊悚冰柱灯串 910$" then
			Furniture_Store = "IcicleWireHalloween"
		end
		if item == "琥珀色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireAmber"
		end
		if item == "蓝色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireBlue"
		end
		if item == "绿色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireGreen"
		end
		if item == "红色冰柱灯串 750$" then
			Furniture_Store = "IcicleWireRed"
		end
		if item == "烟花发射器 7500$" then
			Furniture_Store = "FireworkLauncher"
		end
		if item == "薄柜子 80$" then
			Furniture_Store = "Cabinet1Thin"
		end
		if item == "橱柜 80$" then
			Furniture_Store = "Cabinet1"
		end
		if item == "橱柜角 80$" then
			Furniture_Store = "Cabinet1CornerTight"
		end
		if item == "宽橱柜角 80$" then
			Furniture_Store = "Cabinet1CornerWide"
		end
		if item == "薄工作台面 80$" then
			Furniture_Store = "CounterTop1Thin"
		end
		if item == "工作台面 80$" then
			Furniture_Store = "CounterTop1"
		end
		if item == "带水槽的工作台面 80$" then
			Furniture_Store = "CounterTop1Sink"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["FurnitureStore"], Furniture_Store, "FurnitureStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Shack_Shop = {
		"炸药 220$",
		"毛毛虫软糖罐 3200$",
	}
	
	DTwin3:NewDropdown("鲍勃小屋", "shop_shack", Shack_Shop, function(item)
		if item == "炸药 220$" then
			Shack_Shop = "Dynamite"
		end
		if item == "毛毛虫软糖罐 3200$" then
			Shack_Shop = "CanOfWorms"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["ShackShop"], Shack_Shop, "ShackShop"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local FineArts = {
		"北极灯串 16000$",
		"孤独的长颈鹿 26800$",
		"未知标题 5980$",
		"户外水彩素描 6$",
		"困扰装饰画 2006$",
		"阴郁的黄昏海景 16800$",
		"菠萝 2406000$"
	}
	
	DTwin3:NewDropdown("艺术品商店", "shop_fineart", FineArts, function(item)
	    if item == "北极灯串 16000$" then
			FineArts = "Painting7"
		end
		if item == "孤独的长颈鹿 26800$" then
			FineArts = "Painting9"
		end
		if item == "未知标题 5980$" then
			FineArts = "Painting1"
		end
		if item == "户外水彩素描 6$" then
			FineArts = "Painting3"
		end
		if item == "困扰装饰画 2006$" then
			FineArts = "Painting2"
		end
		if item == "阴郁的黄昏海景 16800$" then
			FineArts = "Painting6"
		end
		if item == "菠萝 2406000$" then
			FineArts = "Painting8"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["FineArt"], FineArts, "FineArt"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	local Logic_Store = {
		"铁丝 205$",
		"按钮 320$",
		"控制杆 520$",
		"压力板 640$",
		"激光探测器 3200$",
		"激光 11300$",
		"木材探测器 11300$",
		"定时开关 902$",
		"异或门 260$",
		"或门 260$",
		"与门 260$",
		"信号变换器 200$",
		"白色霓虹灯线 720$",
		"紫罗兰色霓虹灯线 720$",
		"蓝色霓虹灯线 720$",
		"蓝绿色霓虹灯线 720$",
		"绿色霓虹灯线 720$",
		"黄色霓虹灯线 720$",
		"橙色霓虹灯线 720$",
		"红色霓虹灯线 720$",
		"舱门 830$",
		"信号延迟 520$",
		"信号维持 520$"
	}
	
	DTwin3:NewDropdown("连接逻辑店", "shop_logic", Logic_Store, function(item)
		if item == "铁丝 205$" then
			Logic_Store = "Wire"
		end
		if item == "按钮 320$" then
			Logic_Store = "Button0"
		end
		if item == "控制杆 520$" then
			Logic_Store = "Lever0"
		end
		if item == "压力板 640$" then
			Logic_Store = "PressurePlate"
		end
		if item == "激光探测器 3200$" then
			Logic_Store = "LaserReceiver"
		end
		if item == "激光 11300$" then
			Logic_Store = "Laser"
		end
		if item == "木材探测器 11300$" then
			Logic_Store = "WoodChecker"
		end
		if item == "定时开关 902$" then
			Logic_Store = "ClockSwitch"
		end
		if item == "异或门 260$" then
			Logic_Store = "GateXOR"
		end
		if item == "或门 260$" then
			Logic_Store = "GateOR"
		end
		if item == "与门 260$" then
			Logic_Store = "GateAND"
		end
		if item == "信号变换器 200$" then
			Logic_Store = "GateNOT"
		end
		if item == "白色霓虹灯线 720$" then
			Logic_Store = "NeonWireWhite"
		end
		if item == "紫罗兰色霓虹灯线 720$" then
			Logic_Store = "NeonWireViolet"
		end
		if item == "蓝色霓虹灯线 720$" then
			Logic_Store = "NeonWireBlue"
		end
		if item == "蓝绿色霓虹灯线 720$" then
			Logic_Store = "NeonWireCyan"
		end
		if item == "绿色霓虹灯线 720$" then
			Logic_Store = "NeonWireGreen"
		end
		if item == "黄色霓虹灯线 720$" then
			Logic_Store = "NeonWireYellow"
		end
		if item == "橙色霓虹灯线 720$" then
			Logic_Store = "NeonWireOrange"
		end
		if item == "红色霓虹灯线 720$" then
			Logic_Store = "NeonWireRed"
		end
		if item == "舱门 830$" then
			Logic_Store = "Hatch"
		end
		if item == "信号延迟 520$" then
			Logic_Store = "SignalDelay"
		end
		if item == "信号维持 520$" then
			Logic_Store = "SignalSustain"
		end
	end)
	
	DTwin3:NewButton("购买", function()
		xpcall(buyItem(getgenv()["物品总数"], Stores["LogicStore"], Logic_Store, "LogicStore"), function(err)
			print("");
		end)
	end)
	
	DTwin3:NewSeparator();
	
	DTwin3:NewButton("购买桥票 $100", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["TollBooth0"], "ConfirmPurchase")
	end)
	
	DTwin3:NewButton("购买船票 $400", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["Ferry"], "ConfirmPurchase")
	end)
	
	
	DTwin3:NewButton("购买超级蓝图 $10009000", function()
		DT.RES.NPCDialog.PlayerChatted:InvokeServer(Stores["Region_Main"], "ConfirmPurchase")
	end)
		
	DTwin4:NewSeparator();
	
	DTwin4:NewToggle("点击出售木材", "clicksell", false, function(v)
	    getgenv()["点击出售木头"] = v;
		local UserInputService = game:GetService("UserInputService")
		clickSellLog = UserInputService.TouchTap:Connect(function()
			if getgenv()["点击出售木头"] == false then
				if clickSellLog then
					clickSellLog:Disconnect();
					clickSellLog = nil;
					return
				end
				return
			end
			pcall(function()
				spawn(function()
					local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
					local wood = Mouse.Target.Parent;
					local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
					if wood:FindFirstChild("WoodSection") and (wood:FindFirstChild("Owner") and (wood.Owner.Value == DT.LP) or (wood.Owner.Value == nil)) then
						if not wood:FindFirstChild"RootCut" and wood.Parent.Name == "TreeRegion" then
							return library:Notify({
							           Title = "错误!", 
							           Text = "这棵树还没有砍!",
							           Duration = 4
							       })
						end
						DT.LP.Character:MoveTo(wood.WoodSection.CFrame.p);
						for i = 1, 20 do
							DT:DragModel(wood, sell)
							task.wait(0.1)
						end
					end
				end)
			end)
		end)
	end)
	
	local sellAllLog = true;
	
	DTwin4:NewToggle("出售全部木头", "sellallwood", false, function(v)
	    sellAllLog = v;
		local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		for _, v in next, DT.WKSPC.LogModels:GetDescendants() do
			if sellAllLog == false then --> 如果不想买了, 就中断且传送到原来的位置
				DT:Teleport(oldpos);
				return
			end
			if v:FindFirstChild"Owner" then
				if v.Owner.Value == DT.LP or v.Owner.Value == nil then
					pcall(function()
						DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
						for i = 1, 20 do
							DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
							DT:DragModel(v, sell)
							task.wait(0.1)
						end
					end)
				end
			end
		end
		DT:Teleport(oldpos);
	end)
	
	local function teleport(config)
		local config = config or {};
		config.CFrame = config.CFrame or CFrame.new(0, 0, 0);
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = config.CFrame;
	end
	
	DTwin4:NewToggle("点击自动砍树", "clickautocut", false, function(v)
	    _CONFIGS["点击砍树"] = v;
		local Mouse = DT.LP:GetMouse()
		
		local UserInputService = game:GetService("UserInputService")
		_CONFIGS["自动砍树"] = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["点击砍树"] == false then
					_CONFIGS["自动砍树"]:Disconnect();
					_CONFIGS["自动砍树"] = nil;
				end
				local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
				local wood = Mouse.Target		
				local height = wood.CFrame:pointToObjectSpace(Mouse.Hit.p).Y + wood.Size.Y/2			
		
				if wood.Name == "WoodSection" then				
					repeat
						cutTree({
							Cutevent = wood.Parent.CutEvent;
							Tool = getAxe(wood.Parent.TreeClass.Value);
							Height = height;
						})
						task.wait()
					until wood:FindFirstChild("Tree Weld") == nil
				end
			end)
		end)
	end)
	
	
	_CONFIGS["处理木头"] = false
	
	
	DTwin4:NewButton("处理木材", function()
	    if getgenv()["点击出售木头"] == true then
	        _CONFIGS["处理木头"] = false
	        return library:Notify({
			           Title = "错误!", 
			           Text = "请先关闭点击出售木头!",
			           Duration = 4
			       })
	    end
		_CONFIGS["处理木头"] = true
		
		local UserInputService = game:GetService("UserInputService")
		library:Notify({
	       Title = "处理树", 
	       Text = "请点击一颗已砍的树, 自动分解",
	       Duration = 4
	   })		      
		getgenv().Test = UserInputService.TouchTap:Connect(function()
			if _CONFIGS["处理木头"] == false then
				if getgenv().Test then
					getgenv().Test:Disconnect();
					getgenv().Test = nil;
				end
				return
			end
			pcall(function()
				local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
				local wood = Mouse.Target.Parent;
				if wood:FindFirstChild("WoodSection") and (wood:FindFirstChild("Owner") and (wood.Owner.Value == DT.LP) or (wood.Owner.Value == nil)) then
					if not wood:FindFirstChild"RootCut" and wood.Parent.Name == "TreeRegion" then
						return library:Notify({
	    		           Title = "错误!", 
	    		           Text = "这棵树还没有砍!",
	    		           Duration = 4
	    		       })
					end
					
					local index = 0;
					_CONFIGS["处理木头"] = false;
					for i, v in pairs(wood:GetDescendants()) do
						if v:FindFirstChild("SelectionBox") then
							v:FindFirstChild("SelectionBox"):Destroy()
						end
						if v.Name == "WoodSection" then
							index = index + 1
							local selection = Instance.new("SelectionBox")
							selection.Parent = v
							selection.Adornee = selection.Parent
							if v:WaitForChild("ID") then
								if v.ID.Value == index then
									DT.LP.Character:MoveTo(v.CFrame.p)
									repeat
										cutTree({
											Cutevent = v.Parent.CutEvent;
											SectionId = v.ID.Value;
											Tool = getAxe(v.Parent.TreeClass.Value);
											Height = v.Size.y;
										})         
										task.wait()
									until v:FindFirstChild("Tree Weld") == nil
									--> warn("砍完", index)
									task.wait()
									if v:FindFirstChild("SelectionBox") then
										v:FindFirstChild("SelectionBox"):Destroy()
									end
								else
									index = index + 1
								end
							end
						end
					end
					task.wait()
					DT:Teleport(oldpos)
				end
			end)
		end)
	end)
	_CONFIGS["处理木头并加工"] = false
	
	DTwin4:NewButton("处理木材并加工", function()
	    if getgenv()["点击出售木头"] == true then
	        return library:Notify({
			           Title = "错误!", 
			           Text = "请先关闭点击出售木头!",
			           Duration = 4
			       })
	    end
		_CONFIGS["处理木头并加工"] = true
		
		local UserInputService = game:GetService("UserInputService")
		library:Notify({
	       Title = "处理树!", 
	       Text = "请点击一颗已砍的树和加工机, 自动分解并加工",
	       Duration = 4
	   })
			       
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		local sawmill = nil;
		local wood = nil;
		getgenv().CutWoodToSawmill = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if _CONFIGS["处理木头并加工"] == false then
					if getgenv().CutWoodToSawmill then
						getgenv().CutWoodToSawmill:Disconnect();
						getgenv().CutWoodToSawmill = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
				if model:FindFirstChild("Owner") then
					if model.Owner.Value == DT.LP or model.Owner.Value == nil then
						if model:FindFirstChild("WoodSection") then
							if not model:FindFirstChild"RootCut" and model.Parent.Name == "TreeRegion" then
								return DT:NOTIFY("错误!", "这棵树还没有砍!", 4)
							end
							wood = model;
							DT:NOTIFY("处理树", "已选择树", 4)
						end
					end
					if model:FindFirstChild("ItemName") then
						if model.Name:sub(1, 7) == "Sawmill" or model.ItemName.Value:sub(1, 7) == "Sawmill" then
							sawmill = model;
							DT:NOTIFY("处理树", "已选择加工机", 4)
						end
					end
				end
			end)
		end)
		
	-- local UserInputService = game:GetService("UserInputService")
		-- local delta = UserInputService:GetMouseDelta()
		
	
	
		repeat
			task.wait()
		until wood ~= nil and sawmill ~= nil;
		getgenv().CutWoodToSawmill:Disconnect()
		getgenv().CutWoodToSawmill = nil
		local sawCF = sawmill.Particles.CFrame;
		local index = 0;
	
		for i, v in pairs(wood:GetDescendants()) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
			if v.Name == "WoodSection" then
				index = index + 1
				local selection = Instance.new("SelectionBox")
	                  -->selection.Color3=Color3.new(95,95,95)
				selection.Parent = v
				selection.Adornee = selection.Parent
				if v:WaitForChild("ID") then
					if v.ID.Value == index then
	                     --    DT:Teleport(v.CFrame + Vector3.new(0, 5, 5))
						DT.LP.Character:MoveTo(v.CFrame.p)
						repeat
							cutTree({
								Cutevent = v.Parent.CutEvent;
								SectionId = v.ID.Value;
								Tool = getAxe(v.Parent.TreeClass.Value);
								Height = v.Size.y;
							})         
	                            -- DT.RS.Heartbeat:wait()
							task.wait()
						until v:FindFirstChild("Tree Weld") == nil
	                        --warn("砍完", index)
						task.wait()
						if v:FindFirstChild("SelectionBox") then
							v:FindFirstChild("SelectionBox"):Destroy()
						end
						task.wait(1)
						for i = 1, 20 do
							DT.RS.Heartbeat:wait()
							DT:DragModel(v.Parent, sawCF)
						end
					else
						index = index + 1
					end
				end
			end
			task.wait()
		end
		DT.RS.Heartbeat:wait()
		for _, v in next, DT.WKSPC.LogModels:GetDescendants() do
			if v.Name == wood.Name then
				local ws = {}
				for _, c in next, v:GetChildren() do
					if c.Name == "WoodSection" then
						table.insert(ws, c)
					end
				end
				if # ws == 1 then
					for i = 1, 20 do
						DT.RS.Heartbeat:wait()
						DT:DragModel(v, sawCF)
					end
				end
			end
		end
		DT:NOTIFY("处理树","已完成加工",4)
		task.wait()
		DT:Teleport(oldpos)
	end)
	
	DTwin4:NewSeparator();
	
	plank1x1ByBark = function(v1)
		local v2 = {};
		v2[1] = v1;
		v2[2] = 1 / (v1.Size.x * v1.Size.z);
		if v2[2] < 0.2 then
			v2[2] = 0.3;
		end
		v2[3] = math.floor(v1.Size.y / v2[2]);
		if v2[3] < 1 then
			v2[3] = 0;
		end
		v2[4] = v1.Size.y;
		return v2;
	end
	
	DTwin4:NewButton("木板1x1 测试", function()
	    if getgenv()["点击出售木头"] == true then
	        return DT:NOTIFY("错误","请先关闭点击出售木头",4)
	    end
		getgenv()["木板1x1"] = true	
		local UserInputService = game:GetService("UserInputService")
		DT:NOTIFY("木板1x1", "请点击一块木板, 自动切割一单位", 4)
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		local plank = nil;
		_CONFIGS["cutPlankByDT"] = UserInputService.TouchTap:Connect(function()
			pcall(function()
				if getgenv()["木板1x1"] == false then
					if _CONFIGS["cutPlankByDT"] then
						_CONFIGS["cutPlankByDT"]:Disconnect();
						_CONFIGS["cutPlankByDT"] = nil;
					end
					return
				end
				local model = Mouse.Target.Parent;
				if model.Name == "Plank" then
					if model:FindFirstChild("Owner") then
						if model.Owner.Value == DT.LP or model.Owner.Value == nil then
							if model:FindFirstChild("WoodSection") then
								plank = model.WoodSection;
								DT:NOTIFY("木板1x1", "已选择木板", 4)
							end
						end
					end
				end
			end)
		end)
		
		repeat
			task.wait()
		until plank ~= nil
		_CONFIGS["cutPlankByDT"]:Disconnect();
		_CONFIGS["cutPlankByDT"] = nil;
		local v0 = plank1x1ByBark(plank)
		local v1 = {}
		local v2 = v0[3]
		local v3 = false;
		if v2 == 0 then
			return
		end;
		local v4 = DT.WKSPC.PlayerModels.ChildAdded:Connect(function(model)
			if model:WaitForChild("Owner").Value == DT.LP and model:FindFirstChild'WoodSection' and math.floor(plank1x1ByBark(model.WoodSection)[4]) == math.floor(v0[4] - v0[2]) then
				v3 = true;
				v1 = plank1x1ByBark(model:FindFirstChild'WoodSection')
			end
		end)
		for i, v in pairs(plank.Parent:GetDescendants()) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
		end
		for i = 1, v0[3] do
			local selection = Instance.new("SelectionBox")
			selection.Parent = v0[1]
			selection.Adornee = selection.Parent
			v3 = false;
			DT.LP.Character:MoveTo(v0[1].CFrame.p)
			repeat
				task.wait()
				cutTree({
					Cutevent = v0[1].Parent.CutEvent;
					Tool = getAxe(v0[1].Parent.TreeClass.Value);
					Height = v0[2];
					FaceVector = Vector3.new(- 1, - 0, - 0);
				})
			until v3 or (i == v0[3] and wait(6)) or v0[1].Size.y <= 2
			if v0[1]:FindFirstChild("SelectionBox") then
				v0[1]:FindFirstChild("SelectionBox"):Destroy()
			end
			v0 = v1
		end
		v4:Disconnect()
	end)
	
	local sellAllPlank = true;
	
	DTwin4:NewToggle("出售全部木板", "sellallplank", false, function(v)
	    sellAllPlank = v;
		local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
		local oldpos = DT.LP.Character.HumanoidRootPart.CFrame
		for _, v in next, DT.WKSPC.PlayerModels:GetDescendants() do
			if sellAllPlank == false then --> 如果不想卖了, 就中断且传送到原来的位置
				DT:Teleport(oldpos);
				return
			end
			if v:FindFirstChild"Owner" then
				if v.Owner.Value == DT.LP then
					if v.Name == "Plank" and v:FindFirstChild("WoodSection") then
						pcall(function()
							DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
							for i = 1, 25 do
	                             DT.LP.Character:MoveTo(v.WoodSection.CFrame.p);
								DT:DragModel(v, sell)
								DT.RS.Heartbeat:wait()
							end
							DT.RS.Heartbeat:wait()
						end)
					end
				end
			end
		end
		DT:Teleport(oldpos);
	end)
	
	
	DTwin4:NewSeparator();
	
	DTwin4:NewToggle("拖拽器", "dragmode", false, function(state)
	    	if state then
			_G.HardDraggerConnection = game.Workspace.ChildAdded:connect(
	            function(a)
				if a.Name == "Dragger" then
					local b = a:WaitForChild("BodyGyro")
					local c = a:WaitForChild("BodyPosition")
					local d = {
						bp_p = c.P,
						bp_d = c.D,
						bp_maxforce = c.maxForce,
						bg_p = b.P,
						bg_d = b.D,
						bg_maxtorque = b.maxTorque,
						color_backup = a.BrickColor
					}
					local e = BrickColor.new("Bright blue")
					a.BrickColor = e
					repeat
						task.wait()
						c.P = 120000
						c.D = 1000
						c.maxForce = Vector3.new(1, 1, 1) * 1000000
						b.maxTorque = Vector3.new(1, 1, 1) * 200
						b.P = 1200
						b.D = 140
					until a.Parent ~= game.Workspace
					c.maxForce = d["bp_maxforce"]
					c.D = d["bp_d"]
					c.P = d["bp_p"]
					b.maxTorque = d["bg_maxtorque"]
					b.P = d["bg_p"]
					b.D = d["bg_d"]
					a.BrickColor = d["color_backup"]
				end
			end)
			if not _G.OrigDrag then
				_G.OrigDrag = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag
				getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag = function(f)
					if _G.OrigDrag(f) == true then
						return true
					end
					local g = game.Players.LocalPlayer.Character
					if not g then
						return
					end
					if g:FindFirstChildOfClass("Tool") then
						return
					end
					if f then
						if f.Parent then
							if 0 <= g.Humanoid.Health and f.Name == "LeafPart" then
								return false
							else
								local h = f
								repeat
									h = h.Parent
								until h.Parent.Name == "PlayerModels" or h.Parent == game.Workspace or h.Parent == game or h.Parent.Name == "LogModels"
								if h.Parent.Name == "PlayerModels" or h.Parent.Name == "LogModels" then
								end
							end
						end
					end
					return false
				end
			end
		else
			_G.HardDraggerConnection:Disconnect()
			_G.HardDraggerConnection = nil
			getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag = _G.OrigDrag
			_G.OrigDrag = nil
		end
	end)
		
	local WoodTP = {
	    "火山",
	    "蓝木",
	    "雪光木",
	    "冰木",
	    "僵尸木",
	    "橡木",
	    "樱桃木",
	    "白桦木",
	    "棕树",
	    "雪松",
	    "幻影木",
	    "椰子树",
	    "胡桃木"
	}
	local StoreTP = {
	    "木材反斗城",
	    "土地商店",
	    "盒子车行",
	    "家具店",
	    "鲍勃沙克",
	    "艺术品商店",
	    "连接逻辑店",
	    "建筑大师"
	}
	local OtherTP = {
	    "生成地",
	    "汽车杀人",
	    "小绿盒",
	    "小鸟斧",
	    "桥",
	    "幻影木出口",
	    "木材出售地",
	    "鲨鱼斧",
	    "灯塔",
	    "英灵神殿",
	    "火山秘密基地"
	}
	
	DTwin5:NewDropdown("商店地点", "shop_tp", StoreTP, function(new)
	    StoreTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(StoreTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if StoreTP == "木材反斗城" then
	        DT:TP(273, 3, 56)
	    end
	    if StoreTP == "土地商店" then
	        DT:TP(294, 3, -100)
	    end
	    if StoreTP == "盒子车行" then
	        DT:TP(510, 3, -1445)
	    end
	    if StoreTP == "家具店" then
	        DT:TP(497, 3, -1747)
	    end
	    if StoreTP == "鲍勃沙克" then
	        DT:TP(260, 8, -2542)
	    end
	    if StoreTP == "艺术品商店" then
	        DT:TP(5251, -166, 719)
	    end
	    if StoreTP == "连接逻辑店" then
	        DT:TP(4608, 7, -809)
	    end
	    if StoreTP == "建筑大师" then
	        DT:TP(1060, 17, 1131)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewDropdown("木材地点", "wood_tp", WoodTP, function(new)
	    WoodTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(WoodTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if WoodTP == "火山" then
	        DT:TP(-1613, 623, 1082)
	    end
	    if WoodTP == "蓝木" then
	        DT:TP(3515, -195, 426)
	    end
	    if WoodTP == "雪光木" then
	        DT:TP(-1135, 1, -945)
	    end
	    if WoodTP == "冰木" then
	        DT:TP(1461, 412, 3228)
	    end
	    if WoodTP == "僵尸木" then
	        DT:TP(-1054, 132, -1177)
	    end
	    if WoodTP == "橡木" then
	        DT:TP(-126, 3, -1702)
	    end
	    if WoodTP == "白桦木" then
	        DT:TP(-601, 275, 1174)
	    end
	    if WoodTP == "棕树" then
	        DT:TP(4782, 4, -682)
	    end
	    if WoodTP == "雪松" then
	        DT:TP(1263, 81, 1985)
	    end
	    if WoodTP == "幻影木" then
	        DT:TP(-59, -207, -1334)
	    end
	    if WoodTP == "椰子树" then
	        DT:TP(4330, -6, -1841)
	    end
	    if WoodTP == "胡桃木" then
	        DT:TP(348, 3, -1536)
	    end
	    if WoodTP == "樱桃木" then
	        DT:TP(111, 60, 1233)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewDropdown("其他地点", "other_tp", OtherTP, function(new)
	    OtherTP = new;
	end)
	
	DTwin5:NewButton("传送!", function()
	    if type(OtherTP) == "table" then
	        DT:NOTIFY("错误!", "请先选择地点!", 4)
	        return
	    end
	    if OtherTP == "生成地" then
	        DT:TP(155, 3, 74)
	    end
	    if OtherTP == "小绿盒" then
	        DT:TP(-1668, 350, 1475)
	    end
	    if OtherTP == "小鸟斧" then
	        DT:TP(4797, 19, -983)
	    end
	    if OtherTP == "桥" then
	        DT:TP(134, 5, -608)
	    end
	    if OtherTP == "幻影木出口" then
	        DT:TP(-586, 74, -1414)
	    end
	    if OtherTP == "木材出售地" then
	        DT:TP(307, -3, 105)
	    end
	    if OtherTP == "鲨鱼斧" then
	        DT:TP(324, 46, 1923)
	    end
	    if OtherTP == "灯塔" then
	        DT:TP(1454, 375, 3257)
	    end
	    if OtherTP == "英灵神殿" then
	        DT:TP(-1618, 195, 938)
	    end
	    if OtherTP == "火山秘密基地" then
	        DT:TP(-1432, 444, 1185)
	    end
	    if OtherTP == "汽车杀人" then
	        DT:TP(-1636, 198, 1296)
	    end
	end)
	
	DTwin5:NewSeparator();
	
	getgenv()["玩家们"] = {}
	
	for _, v in next, DT.GS("Players"):GetPlayers() do
	    table.insert(getgenv()["玩家们"], v.Name)
	end
	
	DTwin5:NewDropdown("选择玩家", "player_tp", getgenv()["玩家们"], function(plr)
	    getgenv()["玩家们"] = plr;
	end)
	
	DTwin5:NewButton("传送到玩家身边!", function() 
	    if type(getgenv()["玩家们"]) == "table" then
	        return DT:NOTIFY("错误", "请先选择玩家", 4)
	    end
	    DT:Teleport(DT.GS("Players")[tostring(getgenv()["玩家们"])].Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
	end)
	
	DTwin5:NewButton("传送到玩家基地!", function() 
	    if type(getgenv()["玩家们"]) == "table" then
	        return DT:NOTIFY("错误", "请先选择玩家", 4)
	    end
	    
	    for i, v in next, DT.WKSPC.Properties:GetChildren() do
	        if v:FindFirstChild("Owner") and v.Owner.Value == DT.GS("Players")[tostring(getgenv()["玩家们"])] then
	            DT:Teleport(v.OriginSquare.CFrame + Vector3.new(0, 5, 0))
	        end
	    end
	end)
	
	DTwin5:NewToggle("查看玩家", "viewPlayer", false, function(state)
	    if state then
	        if type(getgenv()["玩家们"]) == "table" then
	            return DT:NOTIFY("错误", "请先选择玩家", 4)
	        end
	        DT:NOTIFY("正在观察", tostring(DT.GS("Players")[tostring(getgenv()["玩家们"])].Name), 4)
	        DT.WKSPC.Camera.CameraSubject = DT.GS("Players")[tostring(getgenv()["玩家们"])].Character
	    else
	        DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	    end
	end)
	
	DTwin5:NewToggle("查看玩家基地", "viewPlayerBase", false, function(state)
	    if state then
	        for i, v in next, DT.WKSPC.Properties:GetChildren() do
	            if v:FindFirstChild("Owner") and v.Owner.Value == DT.GS("Players")[tostring(getgenv()["玩家们"])] then
	            DT.WKSPC.Camera.CameraSubject = v.OriginSquare
	            DT:NOTIFY("正在观察", tostring(DT.GS("Players")[tostring(getgenv()["玩家们"])].Name.."的基地"), 4)
	            end
	        end    
	    else
	        DT.WKSPC.Camera.CameraSubject = DT.LP.Character
	    end
	end)
	
	DT.GS("Players").PlayerRemoving:Connect(function(player)  
	    if getgenv()["玩家们"] ~= nil and #getgenv()["玩家们"] >= 1 then
	        pcall(table.remove, getgenv()["玩家们"], table.find(player.Name))
	        
	        plr:refresh(getgenv()["玩家们"])
	        library.flags["player_tp1"]:RemoveOption(player.Name)
	    end
	    DT:NOTIFY("玩家离开", ("%s离开了服务器"):format(player.Name), 4);
	end)
	
	DT.GS("Players").PlayerAdded:Connect(function(player)
	    if getgenv()["玩家们"] ~= nil and #getgenv()["玩家们"] >= 1 then
	        if not table.find(getgenv()["玩家们"], tostring(player.Name)) then
	            table.insert(getgenv()["玩家们"], player.Name);
	        end        
	        library.flags["player_tp"]:AddOption(player.Name)
	    end
	    DT:NOTIFY("玩家加入", ("%s加入了服务器"):format(player.Name), 4);
	end)
	
	DTwin5:NewSeparator();
	
	DTwin5:NewButton("设置位置!", function() 
	        if DT.WKSPC:FindFirstChild("IIIII") then
	            DT.WKSPC.IIIII:Destroy()
	        end
	        p = Instance.new("Part", DT.WKSPC)
	        p.Name = "IIIII"
	        p.Transparency = 1
	        p.Anchored = true
	        p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	        p.CanCollide = false
	        p.Size = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
	        
	    local posBox = Instance.new("SelectionBox", p)
	    posBox.Name = "posBox"
	    posBox.Color3=Color3.new(255, 255, 255)
	    posBox.Adornee = posBox.Parent
	end)
	
	DTwin5:NewButton("删除位置!", function() 
	    if DT.WKSPC:FindFirstChild("IIIII") then
	        DT.WKSPC.IIIII:Destroy()
	    end
	end)
	
	DTwin5:NewButton("传送!", function() 
	    if DT.WKSPC:FindFirstChild("IIIII") then
	        DT:Teleport(DT.WKSPC.IIIII.CFrame)
	    end
	end)
	
	
	DayOfNight = DT.LIGHT.Changed:Connect(function()
	    if Day then
	        DT.LIGHT.TimeOfDay = "11:30:00"
	    end
	
	    if Night then
	        DT.LIGHT.TimeOfDay = "24:00:00"
	    end
	
	    if NoFog then
	        DT.LIGHT.FogEnd = math.huge
	    end
	end)
	
	DTwin6:NewToggle("白天", "day", true, function(state)
	    Day = state;
	end)
	
	DTwin6:NewToggle("黑夜", "night", false, function(state)
	    Night = state;
	end)
	
	DTwin6:NewToggle("删除雾", "nofog", true, function(state)
	    NoFog = state;
	end)
	
	DTwin6:NewToggle("阴影", "shadow", false, function(state)
	    DT.LIGHT.GlobalShadows = state;
	end)
	
	DTwin6:NewSlider("场景亮度", "bring", 2, 0, 10, false, function(v)
	    DT.LIGHT.Brightness = v
	end)
	
	DTwin6:NewSeparator();
	
	DTwin6:NewToggle("删除水", "deletewater", false, function(state)
	    local water = {}
	    if state then
	        for _, v in next, DT.WKSPC.Water:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 1
	    			v.CanCollide = false
	    		end
	        end
	        for _, v in next, DT.WKSPC.Bridge.VerticalLiftBridge.WaterModel:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 1
	    			v.CanCollide = false
	    		end
	    	end
	 
	    else
	        for _, v in next, DT.WKSPC.Water:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 0
	    			v.CanCollide = false
	    		end
	        end
	        for _, v in next, DT.WKSPC.Bridge.VerticalLiftBridge.WaterModel:GetChildren() do
	    		if v.Name == "Water" then
	    			v.Transparency = 0
	    			v.CanCollide = false
	    		end
	    	end
	    end
	end)
	
	
	DTwin7:NewButton("免费土地", function() 
	    DT:FreeLand()
	end)
	
	DTwin7:NewButton("出售土地牌子", function() 
	    local oldtime = tick();
	    local oldpos = DT.LP.Character.HumanoidRootPart.CFrame;
	    local sell = CFrame.new(315.12146, - 0.190167814, 85.0448074);
	    
	    for _, v in next, DT.WKSPC.PlayerModels:GetChildren() do
	        if v.Name == "Model" and v:FindFirstChild("Owner") then
	            if v.Owner.Value == DT.LP then
	                DT:Teleport(v:FindFirstChildOfClass("Part").CFrame)
	                task.wait()
	                DT.RES.Interaction.ClientInteracted:FireServer(v, "Take down sold sign")
	                task.wait()
	                for i=1, 25 do
	                    DT:DragModel(v, sell)
	                    task.wait()
	                end
	                break;
	            end
	        end
	    end
	    DT:NOTIFY("完成", ("耗时%.3f秒"):format(tick() - oldtime), 4);
	    DT:Teleport(oldpos)
	end)
	
	
	maxland = function()
	    local oldtime = tick();
	    for i, v in pairs(game:GetService("Workspace").Properties:GetChildren()) do
	        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
	            base = v
	            square = v.OriginSquare
	            break;
	        end
	    end
	    function makebase(pos)
	        local Event = game:GetService("ReplicatedStorage").PropertyPurchasing.ClientExpandedProperty
	        Event:FireServer(base, pos)
	    end
	    spos = square.Position
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X, spos.Y, spos.Z - 80))
	--Corners--
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 80))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 80))
	--Corners--
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z + 80))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X + 80, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z + 40))
	    makebase(CFrame.new(spos.X - 80, spos.Y, spos.Z - 40))
	    makebase(CFrame.new(spos.X + 40, spos.Y, spos.Z - 80))
	    makebase(CFrame.new(spos.X - 40, spos.Y, spos.Z - 80))
	    DT:NOTIFY("完成", ("耗时%.3f秒"):format(tick() - oldtime), 4);
	end
	
	DTwin7:NewButton("最大土地", function() 
	    maxland()
	end)
	
	DTwin7:NewSeparator();
	
	DTwin7:NewButton("设置位置!", function() 
	    if DT.WKSPC:FindFirstChild("BRING") then
	        DT.WKSPC.BRING:Destroy()
	    end
	    p = Instance.new("Part", DT.WKSPC)
	    p.Name = "BRING"
	    p.Transparency = 1
	    p.Anchored = true
	    p.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	    p.CanCollide = false
	    p.Size = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
	        
	    local posBox = Instance.new("SelectionBox", p)
	    posBox.Name = "BRINGBOX"
	    posBox.Color3=Color3.new(0, 255, 0)
	    posBox.Adornee = posBox.Parent
	end)
	
	DTwin7:NewButton("删除位置!", function() 
	    if DT.WKSPC:FindFirstChild("BRING") then
	        DT.WKSPC.BRING:Destroy()
	    end
	end)
	
	DTwin7:NewButton("获取传送工具!", function() 
	    if DT.LP.Backpack:FindFirstChild"点击传送任何物品" or DT.LP.Character:FindFirstChild"点击传送任何物品" then
		DT.LP.Backpack["点击传送任何物品"]:Destroy()
	    end;
	    local a = Instance.new("Tool", DT.LP.Backpack)
	    a.Name = "点击传送任何物品"
	    a.RequiresHandle = false;
	    a.Activated:Connect(function()
	    	if DT.WKSPC:FindFirstChild("BRING") then
	    		local b = DT.WKSPC.BRING.CFrame;
	    		local c = Mouse.Target.Parent;
	    		if not c:FindFirstChild"RootCut" and c.Parent.Name == "TreeRegion" then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Blueprint" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Vehicle Spot" then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Furniture" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Wire" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("Type") and c.Type.Value == "Structure" and not c:FindFirstChild("PurchasedBoxItemName") then
	    			return
	    		end;
	    		if c:FindFirstChild("TreeClass") or c.Name == "Plank" or c:FindFirstChild("Type") then
	    			local d = DT.LP.Character.HumanoidRootPart.CFrame;
	    			if c:FindFirstChild"Owner" then
	    				local e = c:FindFirstChildOfClass("Part")
	    				pcall(function()
	    					DT.LP.Character:MoveTo(e.CFrame.p)
	    				end)
	    				c.PrimaryPart = e;
	    				for f = 1, 60 do
	    					c.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
	    					DT.RES.Interaction.ClientIsDragging:FireServer(c)
	    					c:PivotTo(b)
	    					task.wait(0.01)
	    				end
	    			end
	    		else
	    			return
	    		end
	    	end
	    end)
	end)
	
	
	DTwin8:NewSlider("汽车速度", "carSpeedSlider", 1, 0, 10, false, function(v)
	    if DT.LP.Character.Humanoid.SeatPart ~= nil then
	    	local Vehicle = DT.LP.Character.Humanoid.SeatPart.Parent
	        if not Vehicle then
	            return
	        end
	      Vehicle.Configuration:FindFirstChild'MaxSpeed'.Value = v;
	    end
	end)
	
	DTwin8:NewButton("翻转汽车", function() 
	    if DT.LP.Character.Humanoid.SeatPart ~= nil then
	        cf = DT.LP.Character.HumanoidRootPart.CFrame * CFrame.fromEulerAnglesXYZ(90, 0, 0)
	        local plr = DT.LP
	        local plrc = plr.Character
	        local mdl = plrc.Humanoid.SeatPart.Parent
	        if plrc.Humanoid.SeatPart.Name ~= "DriveSeat" then return end
	        if (cf.p-plrc.HumanoidRootPart.CFrame.p).Magnitude >= 175 then
	            local ocf = mdl.PrimaryPart.CFrame + Vector3.new(0,5,0)
	            local intensity = 20
	            if mdl.Seat:FindFirstChild'SeatWeld' then intensity = 30 end
	            local rotmag = intensity
	            for i = 1,intensity do
	                rotmag = rotmag * 1.05
	                DT.RS.RenderStepped:wait()
	                mdl:SetPrimaryPartCFrame(ocf*CFrame.Angles(0, math.rad(rotmag*i), 0))
	            end
	            for i=1,0.8*intensity do
	                DT.RS.RenderStepped:wait()
	                mdl:SetPrimaryPartCFrame(cf)
	            end
	        else
	            mdl:SetPrimaryPartCFrame(cf)
	        end
	    end
	end)

	
