-- Mimi's DW Hub v0.2.9f (GitHub loader and workspace assets)
if not game:IsLoaded()then
game.Loaded:Wait()
end
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local CollectionService=game:GetService("CollectionService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
if not player then
warn("[Mimi Hub] A local player wasn't found.")
return
end
local playerGui=player:WaitForChild("PlayerGui")
local environment=_G
if type(getgenv)=="function"then
local ok,value=pcall(getgenv)
if ok and type(value)=="table"then
environment=value
end
end
if type(environment.MimiDWHubDestroy)=="function"then
pcall(environment.MimiDWHubDestroy)
end
local alive=true
local hidden=false
local rootConnections={}
local roomConnections={}
local mapConnections={}
local playerFolderConnections={}
local playerCharacterConnections={}
local folderConnections={Monsters={},PlayersESP={},Generators={},Items={}}
local folders={}
local room=nil
local map=nil
local active={
Monsters=false,
PlayersESP=false,
Generators=false,
Items=false,
Outlines=true,
Fullbright=false,
Noclip=false,
Stamina=false,
Popups=false,
Ichor=false,
}
local palette={
background=Color3.fromRGB(47,36,32),
panel=Color3.fromRGB(67,50,43),
row=Color3.fromRGB(85,64,54),
cream=Color3.fromRGB(247,231,205),
muted=Color3.fromRGB(202,176,150),
caramel=Color3.fromRGB(214,169,116),
sage=Color3.fromRGB(166,184,137),
off=Color3.fromRGB(111,86,70),
twisted=Color3.fromRGB(246,141,137),
teammate=Color3.fromRGB(184,206,158),
machine=Color3.fromRGB(138,217,206),
item=Color3.fromRGB(248,211,122),
}
local function connect(list,signal,callback)
local conn=signal:Connect(callback)
table.insert(list,conn)
return conn
end
local function disconnectAll(list)
for _,conn in ipairs(list)do
conn:Disconnect()
end
table.clear(list)
end
local function create(className,parent,props)
local instance=Instance.new(className)
for key,value in pairs(props or{})do
instance[key]=value
end
instance.Parent=parent
return instance
end
local function rounded(instance,pixels)
create("UICorner",instance,{CornerRadius=UDim.new(0,pixels)})
end
local function outline(instance,color)
create("UIStroke",instance,{
Color=color,
Thickness=1,
Transparency=0.32,
})
end
local gui=create("ScreenGui",playerGui,{
Name="MimiDWHub",
ResetOnSpawn=false,
IgnoreGuiInset=true,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
DisplayOrder=100,
})
local panel=create("Frame",gui,{
Name="Panel",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(404,535),
BackgroundColor3=palette.background,
BorderSizePixel=0,
})
rounded(panel,14)
outline(panel,palette.caramel)
local header=create("Frame",panel,{
Name="DragHandle",
Size=UDim2.new(1,0,0,75),
BackgroundColor3=palette.panel,
BorderSizePixel=0,
Active=true,
})
rounded(header,14)
create("TextLabel",header,{
BackgroundTransparency=1,
Size=UDim2.new(1,-112,0,30),
Position=UDim2.fromOffset(17,12),
Text="MIMI'S DW HUB  ✿",
TextColor3=palette.cream,
TextSize=21,
Font=Enum.Font.GothamBold,
TextXAlignment=Enum.TextXAlignment.Left,
})
create("TextLabel",header,{
BackgroundTransparency=1,
Size=UDim2.new(1,-112,0,19),
Position=UDim2.fromOffset(18,41),
Text="little fawn edition  •  v0.2.9",
TextColor3=palette.muted,
TextSize=12,
Font=Enum.Font.Gotham,
TextXAlignment=Enum.TextXAlignment.Left,
})
local function smallButton(text,x)
local b=create("TextButton",header,{
Size=UDim2.fromOffset(34,29),
Position=UDim2.new(1,x,0,18),
Text=text,
TextSize=18,
Font=Enum.Font.GothamBold,
TextColor3=palette.cream,
BackgroundColor3=palette.off,
AutoButtonColor=true,
BorderSizePixel=0,
})
rounded(b,8)
return b
end
local hideButton=smallButton("−",-83)
local closeButton=smallButton("×",-42)
local tabBar=create("Frame",panel,{
Name="Tabs",
Position=UDim2.fromOffset(14,82),
Size=UDim2.new(1,-28,0,34),
BackgroundTransparency=1,
})
local function newTabButton(text,xScale,xOffset)
local button=create("TextButton",tabBar,{
Size=UDim2.new(0.5,-5,1,0),
Position=UDim2.new(xScale,xOffset,0,0),
Text=text,
Font=Enum.Font.GothamBold,
TextSize=13,
BackgroundColor3=palette.row,
TextColor3=palette.cream,
BorderSizePixel=0,
})
rounded(button,9)
return button
end
local mainTabButton=newTabButton("MAIN",0,0)
local styleTabButton=newTabButton("ESP CUSTOMISE",0.5,5)
local function newScrollingFrame(name)
local frame=create("ScrollingFrame",panel,{
Name=name,
Position=UDim2.fromOffset(14,125),
Size=UDim2.new(1,-28,1,-180),
BackgroundTransparency=1,
BorderSizePixel=0,
ScrollBarThickness=3,
ScrollBarImageColor3=palette.caramel,
AutomaticCanvasSize=Enum.AutomaticSize.Y,
CanvasSize=UDim2.new(),
})
create("UIListLayout",frame,{
Padding=UDim.new(0,7),
SortOrder=Enum.SortOrder.LayoutOrder,
})
return frame
end
local scrolling=newScrollingFrame("MainSettings")
local styleScrolling=newScrollingFrame("ESPStyleSettings")
styleScrolling.Visible=false
local function showTab(tab)
local isMain=tab=="Main"
scrolling.Visible=isMain
styleScrolling.Visible=not isMain
mainTabButton.BackgroundColor3=isMain and palette.caramel or palette.row
mainTabButton.TextColor3=isMain and palette.background or palette.cream
styleTabButton.BackgroundColor3=isMain and palette.row or palette.caramel
styleTabButton.TextColor3=isMain and palette.cream or palette.background
end
connect(rootConnections,mainTabButton.MouseButton1Click,function()showTab("Main")end)
connect(rootConnections,styleTabButton.MouseButton1Click,function()showTab("Style")end)
showTab("Main")
local footer=create("TextLabel",panel,{
BackgroundTransparency=1,
Position=UDim2.new(0,14,1,-45),
Size=UDim2.new(1,-28,0,31),
Text="F8 hides the menu + ESP  •  Close = full cleanup",
TextColor3=palette.muted,
TextSize=11,
Font=Enum.Font.Gotham,
TextWrapped=true,
})
local function section(text)
create("TextLabel",scrolling,{
Size=UDim2.new(1,-8,0,27),
BackgroundTransparency=1,
Text="  ".. text,
TextColor3=palette.caramel,
Font=Enum.Font.GothamBold,
TextSize=12,
TextXAlignment=Enum.TextXAlignment.Left,
})
end
local setters={}
local rowRefresh={}
local function addToggle(id,title,subtitle)
local button=create("TextButton",scrolling,{
Size=UDim2.new(1,-8,0,52),
BackgroundColor3=palette.row,
BorderSizePixel=0,
Text="",
AutoButtonColor=true,
})
rounded(button,10)
create("TextLabel",button,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(13,6),
Size=UDim2.new(1,-90,0,20),
Text=title,
TextColor3=palette.cream,
Font=Enum.Font.GothamBold,
TextSize=14,
TextXAlignment=Enum.TextXAlignment.Left,
})
create("TextLabel",button,{
BackgroundTransparency=1,
Position=UDim2.fromOffset(13,27),
Size=UDim2.new(1,-90,0,18),
Text=subtitle,
TextColor3=palette.muted,
Font=Enum.Font.Gotham,
TextSize=11,
TextXAlignment=Enum.TextXAlignment.Left,
})
local pill=create("TextLabel",button,{
Position=UDim2.new(1,-65,0.5,-13),
Size=UDim2.fromOffset(53,26),
BorderSizePixel=0,
TextSize=12,
Font=Enum.Font.GothamBold,
})
rounded(pill,8)
rowRefresh[id]=function()
pill.Text=active[id]and "ON"or "OFF"
pill.BackgroundColor3=active[id]and palette.sage or palette.off
pill.TextColor3=active[id]and palette.background or palette.cream
end
rowRefresh[id]()
connect(rootConnections,button.MouseButton1Click,function()
if not alive then return end
local setter=setters[id]
if setter then
local ok,err=pcall(setter,not active[id])
if not ok then warn("[Mimi Hub] ".. id .. ": ".. tostring(err))end
rowRefresh[id]()
end
end)
end
local categories={"Monsters","PlayersESP","Generators","Items"}
local categoryLabels={
Monsters="Twisteds",
PlayersESP="Players",
Generators="Machines",
Items="Items",
}
local styleDefaults={
Monsters={FillColor=palette.twisted,OutlineColor=palette.twisted,FillTransparency=0.50,OutlineTransparency=0},
PlayersESP={FillColor=palette.teammate,OutlineColor=palette.teammate,FillTransparency=0.60,OutlineTransparency=0},
Generators={FillColor=palette.machine,OutlineColor=palette.machine,FillTransparency=0.55,OutlineTransparency=0},
Items={FillColor=palette.item,OutlineColor=palette.item,FillTransparency=0.55,OutlineTransparency=0},
}
local configDir="MimisDWHub"
local configPath=configDir.."/esp-settings.json"
if type(makefolder)=="function" then
 local exists=false
 if type(isfolder)=="function" then
  local ok,v=pcall(isfolder,configDir)
  exists=ok and v
 end
 if not exists then pcall(makefolder,configDir) end
end
local function decodeColor(v)
 if type(v)~="string" then return nil end
 local hex=v:gsub("#","")
 if #hex~=6 or not hex:match("^%x+$") then return nil end
 local n=tonumber(hex,16)
 return Color3.fromRGB(math.floor(n/65536)%256,math.floor(n/256)%256,n%256)
end
local function encodeColor(c)
 return string.format("#%02X%02X%02X",math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5))
end
local storedStyles=environment.MimiDWHubESPSettings
if type(storedStyles)~="table" and type(readfile)=="function" and type(isfile)=="function" then
 local existsOK,exists=pcall(isfile,configPath)
 if existsOK and exists then
  local loadedOK,loaded=pcall(function()return HttpService:JSONDecode(readfile(configPath))end)
  if loadedOK and type(loaded)=="table" then
   storedStyles={}
   for _,category in ipairs(categories)do
    local raw=loaded[category]
    if type(raw)=="table" then
     local style={}
     for _,key in ipairs({"FillColor","OutlineColor"})do style[key]=decodeColor(raw[key]) end
     for _,key in ipairs({"FillTransparency","OutlineTransparency"})do style[key]=raw[key] end
     storedStyles[category]=style
    end
   end
  end
 end
end
if type(storedStyles)~="table"then
storedStyles={}
end
environment.MimiDWHubESPSettings=storedStyles
local espStyles={}
for _,category in ipairs(categories)do
local defaults=styleDefaults[category]
local previous=storedStyles[category]
if type(previous)~="table"then previous={}end
local current={}
for key,default in pairs(defaults)do
local candidate=previous[key]
if typeof(default)=="Color3"then
current[key]=typeof(candidate)=="Color3"and candidate or default
else
current[key]=type(candidate)=="number"and math.clamp(candidate,0,1)or default
end
end
espStyles[category]=current
storedStyles[category]=current
end
local function applyHighlightStyle(category,highlight)
local style=espStyles[category]
if not style or not highlight or not highlight.Parent then return end
highlight.FillColor=style.FillColor
highlight.FillTransparency=style.FillTransparency
highlight.OutlineColor=style.OutlineColor
highlight.OutlineTransparency=style.OutlineTransparency
end
local markers={Monsters={},PlayersESP={},Generators={},Items={}}
local function updateLiveHighlights(category)
for _,record in pairs(markers[category])do
if record.highlight and record.highlight.Parent then
applyHighlightStyle(category,record.highlight)
end
end
end
local saveStylesPending=false
local saveStylesChangedAt=0
local function saveStylesToDisk()
 if type(writefile)~="function" then return end
 local data={}
 for _,category in ipairs(categories)do
  local s=espStyles[category]
  data[category]={FillColor=encodeColor(s.FillColor),OutlineColor=encodeColor(s.OutlineColor),FillTransparency=s.FillTransparency,OutlineTransparency=s.OutlineTransparency}
 end
 local ok,err=pcall(function()writefile(configPath,HttpService:JSONEncode(data))end)
 if not ok then warn("[Mimi Hub] Could not save ESP settings:",err) end
end
local function requestSaveStyles()
 saveStylesChangedAt=os.clock()
 if saveStylesPending then return end
 saveStylesPending=true
 task.spawn(function()
  while alive and os.clock()-saveStylesChangedAt < 0.8 do task.wait(0.25) end
  if alive then saveStylesToDisk() end
  saveStylesPending=false
 end)
end
local function changeESPStyle(category,key,value)
espStyles[category][key]=value
updateLiveHighlights(category)
requestSaveStyles()
end
local function removeMarker(category,object)
local record=markers[category][object]
if not record then return end
markers[category][object]=nil
if record.completionWatcher then record.completionWatcher:Disconnect()end
if record.highlight then record.highlight:Destroy()end
end
local function clearMarkers(category)
for object in pairs(markers[category])do
removeMarker(category,object)
end
end
local function findVisiblePart(object)
if not object then return nil end
if object:IsA("BasePart")then return object end
if object:IsA("Model")then
return object.PrimaryPart
or object:FindFirstChild("HumanoidRootPart",true)
or object:FindFirstChildWhichIsA("BasePart",true)
end
return nil
end
local function addOutline(category,object,record)
local existing=record.highlight
if existing and(existing.Parent==nil or existing.Adornee ~=object)then
pcall(function()existing:Destroy()end)
record.highlight=nil
end
if hidden or not active.Outlines or record.highlight or not object.Parent then return end
if not findVisiblePart(object)then return end
record.highlight=create("Highlight",object,{
Name="MimiOutline_".. category,
Adornee=object,
Enabled=true,
FillColor=espStyles[category].FillColor,
FillTransparency=espStyles[category].FillTransparency,
OutlineColor=espStyles[category].OutlineColor,
OutlineTransparency=espStyles[category].OutlineTransparency,
DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
})
end
local function addMarker(category,object)
if not alive or not active[category]or not object or not object.Parent then return end
if not object:IsDescendantOf(Workspace)then return end
if not findVisiblePart(object)then return end
local record=markers[category][object]
if not record then
local completed=nil
if category=="Generators"then
local stats=object:FindFirstChild("Stats")
completed=stats and stats:FindFirstChild("Completed")
if completed and completed:IsA("BoolValue")and completed.Value then return end
end
record={highlight=nil,completionWatcher=nil}
markers[category][object]=record
if completed and completed:IsA("BoolValue")then
record.completionWatcher=completed:GetPropertyChangedSignal("Value"):Connect(function()
if completed.Value then removeMarker(category,object)end
end)
end
end
addOutline(category,object,record)
end
local function monsterTarget(tagged)
if not tagged or not tagged:IsDescendantOf(Workspace)then return nil end
local candidateFolders={
Workspace:FindFirstChild("Monsters"),
room and room:FindFirstChild("Monsters"),
map and map:FindFirstChild("Monsters"),
}
for _,folder in pairs(candidateFolders)do
if folder and tagged:IsDescendantOf(folder)then
local node=tagged
while node.Parent and node.Parent ~=folder do node=node.Parent end
if node.Parent==folder then return node end
end
end
local cursor=tagged
while cursor and cursor ~=Workspace do
if cursor:IsA("Model")and
(cursor:FindFirstChild("HumanoidRootPart")or cursor:FindFirstChildOfClass("Humanoid"))then
return cursor
end
cursor=cursor.Parent
end
return if tagged:IsA("Model")then tagged else tagged:FindFirstAncestorOfClass("Model")or tagged
end
local function reconcileMonsters()
if not alive or not active.Monsters then return end
local desired={}
for _,tagged in ipairs(CollectionService:GetTagged("Twisted"))do
local target=monsterTarget(tagged)
if target and findVisiblePart(target)then desired[target]=true end
end
local candidates={
Workspace:FindFirstChild("Monsters"),
room and room:FindFirstChild("Monsters"),
map and map:FindFirstChild("Monsters"),
}
for _,folder in pairs(candidates)do
if folder then
for _,child in ipairs(folder:GetChildren())do
local target=monsterTarget(child)
if target and(target:IsA("Model")or target:IsA("BasePart"))
and findVisiblePart(target)then
desired[target]=true
end
end
end
end
for object in pairs(markers.Monsters)do
if not desired[object]or not object:IsDescendantOf(Workspace)then
removeMarker("Monsters",object)
end
end
for object in pairs(desired)do addMarker("Monsters",object)end
end
local monsterRefreshPending=false
local function scheduleMonsterRefresh()
if monsterRefreshPending or not active.Monsters or not alive then return end
monsterRefreshPending=true
task.defer(function()
monsterRefreshPending=false
if alive then reconcileMonsters()end
end)
end
connect(rootConnections,CollectionService:GetInstanceAddedSignal("Twisted"),scheduleMonsterRefresh)
connect(rootConnections,CollectionService:GetInstanceRemovedSignal("Twisted"),scheduleMonsterRefresh)
local monsterFolderConnections={}
local monsterFolderPaths={}
local function refreshMonsterFolderWatches()
disconnectAll(monsterFolderConnections)
table.clear(monsterFolderPaths)
local seen={}
for _,folder in pairs({
Workspace:FindFirstChild("Monsters"),
room and room:FindFirstChild("Monsters"),
map and map:FindFirstChild("Monsters"),
})do
if folder and not seen[folder]then
seen[folder]=true
table.insert(monsterFolderPaths,folder)
connect(monsterFolderConnections,folder.ChildAdded,scheduleMonsterRefresh)
connect(monsterFolderConnections,folder.ChildRemoved,scheduleMonsterRefresh)
end
end
scheduleMonsterRefresh()
end
local function bindFolder(category,newFolder)
disconnectAll(folderConnections[category])
clearMarkers(category)
folders[category]=newFolder
if not newFolder then return end
connect(folderConnections[category],newFolder.ChildAdded,function(object)
addMarker(category,object)
end)
connect(folderConnections[category],newFolder.ChildRemoved,function(object)
removeMarker(category,object)
end)
if active[category]then
for _,object in ipairs(newFolder:GetChildren())do addMarker(category,object)end
end
end
local function updateFolders()
local machineFolder=(map and map:FindFirstChild("Generators"))
or(room and room:FindFirstChild("Generators"))
or Workspace:FindFirstChild("Generators")
local itemFolder=(map and map:FindFirstChild("Items"))
or(room and room:FindFirstChild("Items"))
if folders.Generators ~=machineFolder then bindFolder("Generators",machineFolder)end
if folders.Items ~=itemFolder then bindFolder("Items",itemFolder)end
end
local function bindMap()
disconnectAll(mapConnections)
map=room and room:FindFirstChildOfClass("Model")or nil
if map then
connect(mapConnections,map.ChildAdded,function()
updateFolders()
refreshMonsterFolderWatches()
end)
connect(mapConnections,map.ChildRemoved,function()
updateFolders()
refreshMonsterFolderWatches()
end)
end
updateFolders()
refreshMonsterFolderWatches()
end
local function bindRoom()
disconnectAll(roomConnections)
room=Workspace:FindFirstChild("CurrentRoom")
if room then
connect(roomConnections,room.ChildAdded,bindMap)
connect(roomConnections,room.ChildRemoved,bindMap)
end
bindMap()
end
connect(rootConnections,Workspace.ChildAdded,function(child)
if child.Name=="CurrentRoom"then bindRoom()end
if child.Name=="Generators"then updateFolders()end
if child.Name=="Monsters"then refreshMonsterFolderWatches()end
end)
connect(rootConnections,Workspace.ChildRemoved,function(child)
if child==room then bindRoom()end
if child==folders.Generators then updateFolders()end
if child.Name=="Monsters"then refreshMonsterFolderWatches()end
end)
bindRoom()
setters.Monsters=function(on)
active.Monsters=on
clearMarkers("Monsters")
if on then reconcileMonsters()end
end
for _,category in ipairs({"Generators","Items"})do
setters[category]=function(on)
active[category]=on
clearMarkers(category)
if on then
updateFolders()
local folder=folders[category]
if folder then
for _,object in ipairs(folder:GetChildren())do addMarker(category,object)end
end
end
end
end
local watchedPlayerFolder=nil
local playerRefreshPending=false
local function reconcilePlayers()
if not alive or not active.PlayersESP then return end
local desired={}
local inGamePlayers=Workspace:FindFirstChild("InGamePlayers")
for _,other in ipairs(Players:GetPlayers())do
if other ~=player then
local character=inGamePlayers and inGamePlayers:FindFirstChild(other.Name)
if not(character and character:IsA("Model"))then
character=other.Character
end
if character and character:IsA("Model")
and character:IsDescendantOf(Workspace)
and findVisiblePart(character)then
desired[character]=true
end
end
end
for character in pairs(markers.PlayersESP)do
if not desired[character]then
removeMarker("PlayersESP",character)
end
end
for character in pairs(desired)do
addMarker("PlayersESP",character)
end
end
local function schedulePlayerRefresh()
if playerRefreshPending or not alive or not active.PlayersESP then return end
playerRefreshPending=true
task.defer(function()
playerRefreshPending=false
if alive then reconcilePlayers()end
end)
end
local function watchRemotePlayer(other)
if other==player or playerCharacterConnections[other]then return end
local connections={}
playerCharacterConnections[other]=connections
connect(connections,other.CharacterAdded,schedulePlayerRefresh)
connect(connections,other.CharacterRemoving,schedulePlayerRefresh)
schedulePlayerRefresh()
end
local function watchInGamePlayersFolder()
local newFolder=Workspace:FindFirstChild("InGamePlayers")
if newFolder==watchedPlayerFolder then return end
disconnectAll(playerFolderConnections)
watchedPlayerFolder=newFolder
if newFolder then
connect(playerFolderConnections,newFolder.ChildAdded,schedulePlayerRefresh)
connect(playerFolderConnections,newFolder.ChildRemoved,schedulePlayerRefresh)
end
schedulePlayerRefresh()
end
connect(rootConnections,Players.PlayerAdded,watchRemotePlayer)
connect(rootConnections,Players.PlayerRemoving,function(other)
local connections=playerCharacterConnections[other]
if connections then
disconnectAll(connections)
playerCharacterConnections[other]=nil
end
if other.Character then removeMarker("PlayersESP",other.Character)end
local folder=Workspace:FindFirstChild("InGamePlayers")
if folder then
local model=folder:FindFirstChild(other.Name)
if model then removeMarker("PlayersESP",model)end
end
schedulePlayerRefresh()
end)
connect(rootConnections,Workspace.ChildAdded,function(child)
if child.Name=="InGamePlayers"then watchInGamePlayersFolder()end
end)
connect(rootConnections,Workspace.ChildRemoved,function(child)
if child==watchedPlayerFolder then watchInGamePlayersFolder()end
end)
for _,other in ipairs(Players:GetPlayers())do
watchRemotePlayer(other)
end
watchInGamePlayersFolder()
setters.PlayersESP=function(on)
active.PlayersESP=on
clearMarkers("PlayersESP")
if on then reconcilePlayers()end
end
task.spawn(function()
while alive do
task.wait(2.5)
if alive then
if active.Monsters then reconcileMonsters()end
if active.PlayersESP then reconcilePlayers()end
if active.Generators or active.Items then
updateFolders()
for _,category in ipairs({"Generators","Items"})do
if active[category]then
local folder=folders[category]
if folder then
for _,object in ipairs(folder:GetChildren())do
addMarker(category,object)
end
end
end
end
end
end
end
end)
local lightingOriginal=nil
local lightingNames={
"Brightness","ClockTime","FogEnd","GlobalShadows",
"Ambient","OutdoorAmbient","ExposureCompensation",
}
setters.Fullbright=function(on)
if on==active.Fullbright then return end
active.Fullbright=on
if on then
lightingOriginal={}
for _,name in ipairs(lightingNames)do
lightingOriginal[name]=Lighting[name]
end
Lighting.Brightness=3
Lighting.ClockTime=14
Lighting.FogEnd=100000
Lighting.GlobalShadows=false
Lighting.Ambient=Color3.fromRGB(220,220,220)
Lighting.OutdoorAmbient=Color3.fromRGB(220,220,220)
Lighting.ExposureCompensation=0.2
elseif lightingOriginal then
for name,value in pairs(lightingOriginal)do
Lighting[name]=value
end
lightingOriginal=nil
end
end
setters.Noclip=function(on)
active.Noclip=false
if on then
warn("[Mimi Hub] Noclip paused: the previous wall-scoped test could disable floor collision. Rejoin to reset physics if needed.")
end
end
setters.Stamina=function(on)
active.Stamina=false
if on then warn("[Mimi Hub] Stamina lock disabled: previous versions only changed the display, not real sprint capacity.")end
end
local suppressed={Popups={},Ichor={}}
local function isTargetGui(kind,obj)
if not obj:IsDescendantOf(playerGui)then return false end
if kind=="Popups"then
return obj.Name=="TemporaryPopUp"
and CollectionService:HasTag(obj,"PopUp")
and(obj:IsA("GuiObject")or obj:IsA("LayerCollector"))
end
return obj.Name=="IchorScreen"
and(obj:IsA("GuiObject")or obj:IsA("LayerCollector"))
end
local function stopSuppression(kind)
for obj,record in pairs(suppressed[kind])do
if record.conn then record.conn:Disconnect()end
if obj.Parent then
pcall(function()obj[record.property]=record.original end)
end
suppressed[kind][obj]=nil
end
end
local function suppressGui(kind,obj)
if not alive or not active[kind]or not isTargetGui(kind,obj)then return end
if suppressed[kind][obj]then return end
local property=obj:IsA("LayerCollector")and "Enabled"or "Visible"
local original=obj[property]
obj[property]=false
local conn=obj:GetPropertyChangedSignal(property):Connect(function()
if alive and active[kind]and obj.Parent and obj[property]then
obj[property]=false
end
end)
suppressed[kind][obj]={property=property,original=original,conn=conn}
end
local function scanVisuals(kind)
for _,obj in ipairs(playerGui:GetDescendants())do
if isTargetGui(kind,obj)then suppressGui(kind,obj)end
end
end
setters.Popups=function(on)
active.Popups=on
if on then scanVisuals("Popups")else stopSuppression("Popups")end
end
setters.Ichor=function(on)
active.Ichor=on
if on then scanVisuals("Ichor")else stopSuppression("Ichor")end
end
connect(rootConnections,playerGui.DescendantAdded,function(obj)
if active.Popups and obj.Name=="TemporaryPopUp"then
task.defer(function()
if alive then suppressGui("Popups",obj)end
end)
end
if active.Ichor and obj.Name=="IchorScreen"then
suppressGui("Ichor",obj)
end
end)
connect(rootConnections,CollectionService:GetInstanceAddedSignal("PopUp"),function(obj)
if active.Popups then suppressGui("Popups",obj)end
end)
local closeColorWheel
local function setHidden(on)
if on and closeColorWheel then closeColorWheel()end
hidden=on
panel.Visible=not on
for _,category in ipairs(categories)do
for object,record in pairs(markers[category])do
if on and record.highlight then
record.highlight:Destroy()
record.highlight=nil
elseif not on then
addOutline(category,object,record)
end
end
end
end
local function shutdown()
if not alive then return end
setters.Noclip(false)
setters.Fullbright(false)
setters.Popups(false)
setters.Ichor(false)
alive=false
disconnectAll(rootConnections)
disconnectAll(roomConnections)
disconnectAll(mapConnections)
disconnectAll(monsterFolderConnections)
disconnectAll(playerFolderConnections)
for other,connections in pairs(playerCharacterConnections)do
disconnectAll(connections)
playerCharacterConnections[other]=nil
end
for _,category in ipairs(categories)do
disconnectAll(folderConnections[category])
clearMarkers(category)
end
gui:Destroy()
if environment.MimiDWHubDestroy==shutdown then
environment.MimiDWHubDestroy=nil
end
print("[Mimi Hub] Closed and cleaned up.")
end
environment.MimiDWHubDestroy=shutdown
local selectedStyleCategory="Monsters"
local colorPresets={
Color3.fromRGB(246,141,137),
Color3.fromRGB(184,206,158),
Color3.fromRGB(138,217,206),
Color3.fromRGB(248,211,122),
Color3.fromRGB(197,164,236),
Color3.fromRGB(250,237,216),
}
local function toHex(color)
return string.format("#%02X%02X%02X",
math.floor(color.R * 255 + 0.5),
math.floor(color.G * 255 + 0.5),
math.floor(color.B * 255 + 0.5))
end
local function parseHex(text)
local compact=(text or ""):gsub("%s+","")
local digits=compact:match("^#?(%x%x%x%x%x%x)$")
if not digits then return nil end
return Color3.fromRGB(
tonumber(digits:sub(1,2),16),
tonumber(digits:sub(3,4),16),
tonumber(digits:sub(5,6),16)
)
end
create("TextLabel",styleScrolling,{
Size=UDim2.new(1,-8,0,39),
BackgroundTransparency=1,
Text="Choose an ESP group, then adjust its fill and outline independently. Changes appear live!",
TextColor3=palette.muted,
TextWrapped=true,
TextSize=12,
Font=Enum.Font.Gotham,
})
local selector=create("Frame",styleScrolling,{
Size=UDim2.new(1,-8,0,77),
BackgroundTransparency=1,
})
local categoryButtons={}
local refreshStyleEditor
for i,category in ipairs(categories)do
local col=(i - 1)% 2
local row=math.floor((i - 1)/ 2)
local button=create("TextButton",selector,{
Size=UDim2.new(0.5,-5,0,35),
Position=UDim2.new(col * 0.5,col==0 and 0 or 5,0,row * 41),
Text=categoryLabels[category],
Font=Enum.Font.GothamBold,
TextSize=12,
BackgroundColor3=palette.row,
TextColor3=palette.cream,
BorderSizePixel=0,
})
rounded(button,9)
categoryButtons[category]=button
connect(rootConnections,button.MouseButton1Click,function()
selectedStyleCategory=category
if refreshStyleEditor then refreshStyleEditor()end
end)
end
local editor=create("Frame",styleScrolling,{
Name="ColourEditor",
Size=UDim2.new(1,-8,0,394),
BackgroundColor3=palette.panel,
BorderSizePixel=0,
})
rounded(editor,11)
local editorHeading=create("TextLabel",editor,{
Size=UDim2.new(1,-24,0,25),
Position=UDim2.fromOffset(12,8),
BackgroundTransparency=1,
Text="",
TextColor3=palette.cream,
TextSize=16,
Font=Enum.Font.GothamBold,
TextXAlignment=Enum.TextXAlignment.Left,
})
create("TextLabel",editor,{
Size=UDim2.new(1,-24,0,23),
Position=UDim2.fromOffset(12,32),
BackgroundTransparency=1,
Text="Tap a colour swatch for the wheel, or enter #RRGGBB.",
TextColor3=palette.muted,
TextSize=11,
Font=Enum.Font.Gotham,
TextXAlignment=Enum.TextXAlignment.Left,
})
local colorControls={}
local openColorWheel
local function addColourRow(key,caption,y)
create("TextLabel",editor,{
Position=UDim2.fromOffset(12,y),
Size=UDim2.fromOffset(51,28),
BackgroundTransparency=1,
Text=caption,
TextColor3=palette.cream,
Font=Enum.Font.GothamBold,
TextSize=12,
TextXAlignment=Enum.TextXAlignment.Left,
})
local preview=create("TextButton",editor,{
Position=UDim2.fromOffset(63,y + 1),
Size=UDim2.fromOffset(26,26),
BackgroundColor3=palette.cream,
BorderSizePixel=0,
Text="◉",
Font=Enum.Font.GothamBold,
TextSize=16,
TextColor3=palette.background,
AutoButtonColor=true,
})
rounded(preview,6)
outline(preview,palette.cream)
connect(rootConnections,preview.MouseButton1Click,function()
if openColorWheel then openColorWheel(key)end
end)
local field=create("TextBox",editor,{
Position=UDim2.fromOffset(95,y),
Size=UDim2.fromOffset(98,28),
BackgroundColor3=palette.row,
TextColor3=palette.cream,
PlaceholderColor3=palette.muted,
PlaceholderText="#RRGGBB",
ClearTextOnFocus=false,
Text="",
TextSize=12,
Font=Enum.Font.Code,
BorderSizePixel=0,
})
rounded(field,7)
local fieldCategory=nil
connect(rootConnections,field.Focused,function()
fieldCategory=selectedStyleCategory
end)
connect(rootConnections,field.FocusLost,function()
local color=parseHex(field.Text)
if color then
changeESPStyle(fieldCategory or selectedStyleCategory,key,color)
end
fieldCategory=nil
if refreshStyleEditor then refreshStyleEditor()end
end)
for i,preset in ipairs(colorPresets)do
local chip=create("TextButton",editor,{
Position=UDim2.fromOffset(201 +(i - 1)* 26,y + 3),
Size=UDim2.fromOffset(21,22),
BackgroundColor3=preset,
BorderSizePixel=0,
Text="",
AutoButtonColor=true,
})
rounded(chip,5)
connect(rootConnections,chip.MouseButton1Click,function()
changeESPStyle(selectedStyleCategory,key,preset)
if refreshStyleEditor then refreshStyleEditor()end
end)
end
colorControls[key]={field=field,preview=preview}
end
addColourRow("FillColor","Fill",63)
addColourRow("OutlineColor","Edge",107)
local transparencySliders={}
local function addTransparencySlider(key,label,y)
local titleLabel=create("TextLabel",editor,{
Position=UDim2.fromOffset(15,y),
Size=UDim2.new(1,-30,0,22),
BackgroundTransparency=1,
Text=label,
TextColor3=palette.cream,
Font=Enum.Font.GothamBold,
TextSize=12,
TextXAlignment=Enum.TextXAlignment.Left,
})
local progressTrack=create("Frame",editor,{
Position=UDim2.fromOffset(16,y + 32),
Size=UDim2.new(1,-32,0,9),
BackgroundColor3=palette.row,
BorderSizePixel=0,
})
rounded(progressTrack,5)
local progress=create("Frame",progressTrack,{
Size=UDim2.fromScale(0.5,1),
BackgroundColor3=palette.sage,
BorderSizePixel=0,
})
rounded(progress,5)
local knob=create("Frame",progressTrack,{
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(17,17),
BackgroundColor3=palette.cream,
BorderSizePixel=0,
})
rounded(knob,9)
local hitArea=create("TextButton",editor,{
Position=UDim2.fromOffset(10,y + 21),
Size=UDim2.new(1,-20,0,29),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
})
local draggingSlider=false
local finger=nil
local function setFromX(x)
if progressTrack.AbsoluteSize.X <=0 then return end
local fraction=math.clamp(
(x - progressTrack.AbsolutePosition.X)/ progressTrack.AbsoluteSize.X,
0,1
)
fraction=math.floor(fraction * 100 + 0.5)/ 100
if espStyles[selectedStyleCategory][key]~=fraction then
changeESPStyle(selectedStyleCategory,key,fraction)
end
titleLabel.Text=label .. ": ".. tostring(math.floor(fraction * 100 + 0.5)).. "%"
progress.Size=UDim2.fromScale(fraction,1)
knob.Position=UDim2.fromScale(fraction,0.5)
end
connect(rootConnections,hitArea.InputBegan,function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1
or input.UserInputType==Enum.UserInputType.Touch then
draggingSlider=true
finger=input.UserInputType==Enum.UserInputType.Touch and input or nil
setFromX(input.Position.X)
end
end)
connect(rootConnections,UserInputService.InputChanged,function(input)
if not draggingSlider then return end
if(finger and input==finger)
or(not finger and input.UserInputType==Enum.UserInputType.MouseMovement)then
setFromX(input.Position.X)
end
end)
connect(rootConnections,UserInputService.InputEnded,function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 and not finger then
draggingSlider=false
elseif finger and input==finger then
draggingSlider=false
finger=nil
end
end)
transparencySliders[key]=function(value)
local percent=math.floor(value * 100 + 0.5)
titleLabel.Text=label .. ": ".. tostring(percent).. "%"
progress.Size=UDim2.fromScale(value,1)
knob.Position=UDim2.fromScale(value,0.5)
end
end
addTransparencySlider("FillTransparency","Fill transparency",162)
addTransparencySlider("OutlineTransparency","Outline transparency",235)
local resetStyleButton=create("TextButton",editor,{
Position=UDim2.new(0,13,1,-68),
Size=UDim2.new(1,-26,0,31),
BackgroundColor3=palette.row,
BorderSizePixel=0,
Text="Restore this group's default colours",
Font=Enum.Font.GothamBold,
TextSize=12,
TextColor3=palette.cream,
})
rounded(resetStyleButton,8)
connect(rootConnections,resetStyleButton.MouseButton1Click,function()
for key,value in pairs(styleDefaults[selectedStyleCategory])do
changeESPStyle(selectedStyleCategory,key,value)
end
if refreshStyleEditor then refreshStyleEditor()end
end)
create("TextLabel",editor,{
Position=UDim2.new(0,12,1,-30),
Size=UDim2.new(1,-24,0,24),
BackgroundTransparency=1,
Text="0% = solid  •  100% = invisible  •  F8 hides all ESP",
TextColor3=palette.muted,
TextSize=10,
Font=Enum.Font.Gotham,
TextWrapped=true,
})
refreshStyleEditor=function()
editorHeading.Text=categoryLabels[selectedStyleCategory].. "  •  ESP style"
local style=espStyles[selectedStyleCategory]
for category,button in pairs(categoryButtons)do
local chosen=category==selectedStyleCategory
button.BackgroundColor3=chosen and palette.caramel or palette.row
button.TextColor3=chosen and palette.background or palette.cream
end
for _,key in ipairs({"FillColor","OutlineColor"})do
local controls=colorControls[key]
controls.preview.BackgroundColor3=style[key]
controls.preview.TextColor3=style[key].R * .299 + style[key].G * .587 + style[key].B * .114 > 0.54
and palette.background or palette.cream
controls.field.Text=toHex(style[key])
end
for _,key in ipairs({"FillTransparency","OutlineTransparency"})do
transparencySliders[key](style[key])
end
end
refreshStyleEditor()
local wheelBackdrop,wheelSurface,wheelCursor,brightnessTrack
local brightnessCursor,brightnessGradient,wheelPreview,wheelHex,wheelHeading
local pickerCategory,pickerKey,pickerOriginal
local hue,saturation,brightness=0,0,1
local draggingWheelPart,draggingTouch=nil,nil
local renderPicker
closeColorWheel=function()
draggingWheelPart,draggingTouch=nil,nil
if wheelBackdrop then wheelBackdrop.Visible=false end
end
local function ensureColourWheel()
if wheelBackdrop then return end
wheelBackdrop=create("Frame",gui,{
Name="ESPColourWheelBackdrop",
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.38,
BorderSizePixel=0,
ZIndex=30,
Visible=false,
})
local modal=create("Frame",wheelBackdrop,{
Name="ESPColourWheel",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(304,389),
BackgroundColor3=palette.background,
BorderSizePixel=0,
ZIndex=31,
})
rounded(modal,14)
outline(modal,palette.caramel)
wheelHeading=create("TextLabel",modal,{
Position=UDim2.fromOffset(16,12),
Size=UDim2.fromOffset(262,25),
BackgroundTransparency=1,
Text="ESP colour wheel",
Font=Enum.Font.GothamBold,
TextSize=16,
TextColor3=palette.cream,
TextXAlignment=Enum.TextXAlignment.Left,
ZIndex=32,
})
create("TextLabel",modal,{
Position=UDim2.fromOffset(16,39),
Size=UDim2.fromOffset(272,33),
BackgroundTransparency=1,
Text="Drag on the wheel for hue / saturation. Use the bar for brightness.",
Font=Enum.Font.Gotham,
TextSize=11,
TextWrapped=true,
TextColor3=palette.muted,
ZIndex=32,
})
wheelSurface=create("Frame",modal,{
Name="HSVWheel",
Position=UDim2.fromOffset(18,83),
Size=UDim2.fromOffset(168,168),
BackgroundTransparency=1,
BorderSizePixel=0,
ZIndex=32,
})
-- A texture is much smoother than hundreds of tiny Frame tiles.
-- If you place our matching PNG in Madium's workspace, use it.
 -- Otherwise try a public circular HSV image from Roblox.
 local wheelTexture="rbxassetid://117857197662540"
 local wheelRotation=180 -- Public texture has red on left; our picker expects it on right.
 if type(getcustomasset)=="function" and type(isfile)=="function" then
  for _,path in ipairs({"MimisDWHub/wheel.png","mimis_smooth_hsv_wheel.png"}) do
   local existsOK,exists=pcall(isfile,path)
   if existsOK and exists then
    local assetOK,asset=pcall(getcustomasset,path)
    if assetOK and type(asset)=="string" and #asset>0 then
     wheelTexture=asset
     wheelRotation=0
     break
    end
   end
  end
 end
 create("ImageLabel",wheelSurface,{
 Name="SmoothHSVDisc",
 Size=UDim2.fromScale(1,1),
 BackgroundTransparency=1,
 BorderSizePixel=0,
 Image=wheelTexture,
 Rotation=wheelRotation,
 ZIndex=33,
 })
 local wheelRing=create("Frame",wheelSurface,{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BorderSizePixel=0,
ZIndex=34,
})
create("UICorner",wheelRing,{CornerRadius=UDim.new(0.5,0)})
create("UIStroke",wheelRing,{
Color=palette.caramel,Thickness=2,Transparency=0.1,
})
wheelCursor=create("Frame",wheelSurface,{
Name="WheelMarker",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(15,15),
BackgroundTransparency=1,
BorderSizePixel=0,
ZIndex=35,
})
rounded(wheelCursor,20)
create("UIStroke",wheelCursor,{
Color=Color3.new(0,0,0),Thickness=4,Transparency=0.2,
})
local innerCursor=create("Frame",wheelCursor,{
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.fromScale(0.5,0.5),
Size=UDim2.fromOffset(12,12),
BackgroundTransparency=1,
BorderSizePixel=0,
ZIndex=36,
})
rounded(innerCursor,20)
create("UIStroke",innerCursor,{Color=palette.cream,Thickness=2})
local wheelHit=create("TextButton",wheelSurface,{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
ZIndex=37,
})
brightnessTrack=create("Frame",modal,{
Name="Brightness",
Position=UDim2.fromOffset(228,83),
Size=UDim2.fromOffset(24,168),
BorderSizePixel=0,
BackgroundColor3=palette.cream,
ZIndex=32,
})
rounded(brightnessTrack,6)
brightnessGradient=create("UIGradient",brightnessTrack,{
Rotation=90,
Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(0,0,0)),
})
brightnessCursor=create("Frame",brightnessTrack,{
Name="BrightnessMarker",
AnchorPoint=Vector2.new(0.5,0.5),
Size=UDim2.fromOffset(36,8),
Position=UDim2.fromScale(0.5,0),
BackgroundColor3=palette.cream,
BorderSizePixel=0,
ZIndex=34,
})
rounded(brightnessCursor,3)
outline(brightnessCursor,palette.background)
local brightnessHit=create("TextButton",brightnessTrack,{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
ZIndex=37,
})
create("TextLabel",modal,{
Position=UDim2.fromOffset(205,256),
Size=UDim2.fromOffset(69,17),
BackgroundTransparency=1,
Text="Brightness",
Font=Enum.Font.Gotham,
TextSize=10,
TextColor3=palette.muted,
ZIndex=32,
})
wheelPreview=create("Frame",modal,{
Position=UDim2.fromOffset(18,276),
Size=UDim2.fromOffset(41,35),
BackgroundColor3=palette.cream,
BorderSizePixel=0,
ZIndex=32,
})
rounded(wheelPreview,8)
wheelHex=create("TextLabel",modal,{
Position=UDim2.fromOffset(73,276),
Size=UDim2.fromOffset(205,35),
BackgroundTransparency=1,
Text="#FFFFFF",
TextColor3=palette.cream,
Font=Enum.Font.Code,
TextSize=17,
TextXAlignment=Enum.TextXAlignment.Left,
ZIndex=32,
})
local cancelButton=create("TextButton",modal,{
Position=UDim2.fromOffset(18,325),
Size=UDim2.fromOffset(125,35),
BackgroundColor3=palette.off,
TextColor3=palette.cream,
Text="Cancel",
Font=Enum.Font.GothamBold,
TextSize=13,
BorderSizePixel=0,
ZIndex=32,
})
rounded(cancelButton,9)
local doneButton=create("TextButton",modal,{
Position=UDim2.fromOffset(157,325),
Size=UDim2.fromOffset(129,35),
BackgroundColor3=palette.caramel,
TextColor3=palette.background,
Text="Done ♡",
Font=Enum.Font.GothamBold,
TextSize=13,
BorderSizePixel=0,
ZIndex=32,
})
rounded(doneButton,9)
create("TextLabel",modal,{
Position=UDim2.fromOffset(15,364),
Size=UDim2.fromOffset(272,17),
BackgroundTransparency=1,
TextColor3=palette.muted,
Text="Live preview  •  F8 still hides your ESP",
Font=Enum.Font.Gotham,
TextSize=10,
ZIndex=32,
})
renderPicker=function()
if not pickerCategory or not pickerKey then return end
local colour=Color3.fromHSV(hue,saturation,brightness)
changeESPStyle(pickerCategory,pickerKey,colour)
wheelCursor.Position=UDim2.fromOffset(
84 + math.cos(hue * math.pi * 2)* saturation * 84,
84 - math.sin(hue * math.pi * 2)* saturation * 84
)
brightnessCursor.Position=UDim2.fromScale(0.5,1 - brightness)
brightnessGradient.Color=ColorSequence.new(
Color3.fromHSV(hue,saturation,1),Color3.new(0,0,0)
)
wheelPreview.BackgroundColor3=colour
wheelHex.Text=toHex(colour)
if refreshStyleEditor and selectedStyleCategory==pickerCategory then
refreshStyleEditor()
end
end
local function pickHueSat(position)
local centre=wheelSurface.AbsolutePosition + wheelSurface.AbsoluteSize / 2
local dx=position.X - centre.X
local dy=position.Y - centre.Y
local radius=wheelSurface.AbsoluteSize.X / 2
if radius <=0 then return end
hue=(math.atan2(-dy,dx)/(2 * math.pi))% 1
saturation=math.clamp(math.sqrt(dx * dx + dy * dy)/ radius,0,1)
renderPicker()
end
local function pickBrightness(position)
if brightnessTrack.AbsoluteSize.Y <=0 then return end
brightness=1 - math.clamp(
(position.Y - brightnessTrack.AbsolutePosition.Y)/ brightnessTrack.AbsoluteSize.Y,
0,1
)
renderPicker()
end
local function startDrag(kind,input)
if not wheelBackdrop.Visible or not alive then return end
if input.UserInputType ~=Enum.UserInputType.MouseButton1
and input.UserInputType ~=Enum.UserInputType.Touch then return end
draggingWheelPart=kind
draggingTouch=input.UserInputType==Enum.UserInputType.Touch and input or nil
if kind=="wheel"then pickHueSat(input.Position)
else pickBrightness(input.Position)end
end
connect(rootConnections,wheelHit.InputBegan,function(input)
startDrag("wheel",input)
end)
connect(rootConnections,brightnessHit.InputBegan,function(input)
startDrag("brightness",input)
end)
connect(rootConnections,UserInputService.InputChanged,function(input)
if not draggingWheelPart or not wheelBackdrop.Visible then return end
if(draggingTouch and input ~=draggingTouch)or
(not draggingTouch and input.UserInputType ~=Enum.UserInputType.MouseMovement)then
return
end
if draggingWheelPart=="wheel"then pickHueSat(input.Position)
else pickBrightness(input.Position)end
end)
connect(rootConnections,UserInputService.InputEnded,function(input)
if not draggingWheelPart then return end
if(draggingTouch and input==draggingTouch)or
(not draggingTouch and input.UserInputType==Enum.UserInputType.MouseButton1)then
draggingWheelPart,draggingTouch=nil,nil
end
end)
connect(rootConnections,cancelButton.MouseButton1Click,function()
if pickerCategory and pickerKey and pickerOriginal then
changeESPStyle(pickerCategory,pickerKey,pickerOriginal)
if refreshStyleEditor then refreshStyleEditor()end
end
closeColorWheel()
end)
connect(rootConnections,doneButton.MouseButton1Click,closeColorWheel)
end
openColorWheel=function(key)
if not alive or not espStyles[selectedStyleCategory][key]then return end
ensureColourWheel()
pickerCategory,pickerKey=selectedStyleCategory,key
pickerOriginal=espStyles[pickerCategory][pickerKey]
hue,saturation,brightness=pickerOriginal:ToHSV()
wheelHeading.Text=categoryLabels[pickerCategory].. "  •  "
..(key=="FillColor"and "Fill colour"or "Outline colour")
wheelBackdrop.Visible=true
renderPicker()
end
section("VISION & EXPLORATION")
addToggle("Monsters","Twisted ESP","Custom fill + outline; recovers late spawns")
addToggle("PlayersESP","Player ESP","Custom fill + outline for teammates; no labels")
addToggle("Generators","Machine ESP","Custom fill + outline; no stud limit")
addToggle("Items","Item ESP","Custom fill + outline; no stud limit")
local espStatusButton=create("TextButton",scrolling,{
Size=UDim2.new(1,-8,0,38),
BackgroundColor3=palette.row,
BorderSizePixel=0,
Text="Print ESP status / refresh",
TextColor3=palette.cream,
Font=Enum.Font.GothamBold,
TextSize=13,
})
rounded(espStatusButton,10)
connect(rootConnections,espStatusButton.MouseButton1Click,function()
reconcileMonsters()
reconcilePlayers()
local counts={}
for _,category in ipairs(categories)do
local n=0
for _,record in pairs(markers[category])do
if record.highlight and record.highlight.Parent then n +=1 end
end
counts[category]=n
end
print("[Mimi ESP] Twisted tags:",#CollectionService:GetTagged("Twisted"),
"live outline objects:",counts.Monsters,
"Players:",counts.PlayersESP,"Machines:",counts.Generators,"Items:",counts.Items)
for _,folder in ipairs(monsterFolderPaths)do
print("[Mimi ESP] Monster folder:",folder:GetFullName(),"children:",#folder:GetChildren())
end
if #monsterFolderPaths==0 then
print("[Mimi ESP] No Monsters folder watched; using Twisted tags only")
end
local i=0
for monster,record in pairs(markers.Monsters)do
i +=1
if i > 12 then break end
local h=record.highlight
print("[Mimi ESP] Target:",monster:GetFullName(),
"hasHighlight:",h ~=nil and h.Parent ~=nil,
"hasPart:",findVisiblePart(monster)~=nil,
"tagged:",CollectionService:HasTag(monster,"Twisted"))
end
end)
addToggle("Fullbright","Fullbright","Brightens dark floors")
section("MOVEMENT — SAFETY PAUSE")
create("TextLabel",scrolling,{
BackgroundTransparency=1,
Size=UDim2.new(1,-12,0,54),
Text="Noclip is disabled for safety: v0.2.5 affected floor collision. Rejoin if you are falling through the map.",
TextColor3=palette.muted,
Font=Enum.Font.Gotham,
TextWrapped=true,
TextSize=12,
})
create("TextLabel",scrolling,{
BackgroundTransparency=1,
Size=UDim2.new(1,-12,0,38),
Text="Stamina lock remains unavailable: previous tests changed only the bar, not sprint capacity.",
TextColor3=palette.muted,
Font=Enum.Font.Gotham,
TextWrapped=true,
TextSize=12,
})
section("SCREEN COMFORT")
addToggle("Popups","Anti popup • selective","Hides TemporaryPopUp UI; can hide important dialogs")
addToggle("Ichor","Hide ichor screen effect","Hides IchorScreen GUI if the effect uses PlayerGui")
section("COMING NEXT")
create("TextLabel",scrolling,{
BackgroundTransparency=1,
Size=UDim2.new(1,-12,0,50),
Text="Auto skill checks are under investigation. This version does not simulate inputs or offer working infinite stamina.",
TextColor3=palette.muted,
Font=Enum.Font.Gotham,
TextWrapped=true,
TextSize=12,
})
connect(rootConnections,hideButton.MouseButton1Click,function()
setHidden(true)
end)
connect(rootConnections,closeButton.MouseButton1Click,shutdown)
connect(rootConnections,UserInputService.InputBegan,function(input)
if input.KeyCode==Enum.KeyCode.F8 then
setHidden(not hidden)
end
end)
local dragging=false
local dragInput=nil
local dragStart=nil
local panelStart=nil
connect(rootConnections,header.InputBegan,function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1
or input.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragInput=input
dragStart=input.Position
panelStart=panel.Position
end
end)
connect(rootConnections,header.InputEnded,function(input)
if input==dragInput then dragging=false end
end)
connect(rootConnections,UserInputService.InputChanged,function(input)
if not dragging then return end
if input.UserInputType ~=Enum.UserInputType.MouseMovement and input ~=dragInput then
return
end
local delta=input.Position - dragStart
panel.Position=UDim2.new(
panelStart.X.Scale,panelStart.X.Offset + delta.X,
panelStart.Y.Scale,panelStart.Y.Offset + delta.Y
)
end)
print("[Mimi Hub] Little Fawn Edition v0.2.9f loaded. Smooth wheel + saved ESP settings; F8 privacy.")
