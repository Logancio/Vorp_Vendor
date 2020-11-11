

local keys = {
    -- Letter E
    ["E"] = 0xCEFD9220,
}

local booze = Config.Booze

local function IsNearZone ( location )

	local player = PlayerPedId()
	local playerloc = GetEntityCoords(player, 0)

	for i = 1, #location do
		if #(playerloc - location[i]) < 2.0 then
			return true, i
		end
	end

end

local function DisplayHelp( _message, x, y, w, h, enableShadow, col1, col2, col3, a, centre )

	local str = CreateVarString(10, "LITERAL_STRING", _message, Citizen.ResultAsLong())

	SetTextScale(w, h)
	SetTextColor(col1, col2, col3, a)

	SetTextCentre(centre)

	if enableShadow then
		SetTextDropshadow(1, 0, 0, 0, 255)
	end

	Citizen.InvokeNative(0xADA9255D, 10);

	DisplayText(str, x, y)

end

Citizen.CreateThread( function()
	WarMenu.CreateMenu('bar', 'Bar')
	repeat
		if WarMenu.IsMenuOpened('bar') then
			for i = 1, #booze do
				if WarMenu.Button(booze[i]['Text'], booze[i]['SubText'], booze[i]['Desc']) then
					TriggerServerEvent('bar:comprar', booze[i]['Param'])
					WarMenu.CloseMenu()
				end
			end
			WarMenu.Display()
		end
		Citizen.Wait(0)
	until false
end)

Citizen.CreateThread(function()
	while true do

		local IsZone, IdZone = IsNearZone(Config.Coords)      
       
        if IsZone then 
			DisplayHelp(Config.Shoptext, 0.50, 0.95, 0.6, 0.6, true, 255, 255, 255, 255, true, 10000)
            if IsControlJustPressed(0, keys['E']) then
                WarMenu.OpenMenu('bar')
            end
        end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent('UI:DrawNotification')
AddEventHandler('UI:DrawNotification', function( _message )
	TriggerEvent("vorp:TipRight", _message, 100)
end)

Citizen.CreateThread(function()
	for k, v in pairs(Config.Blips) do
        local blip = N_0x554d9d53f696d002(1664425300, v.x, v.y, v.z)
		SetBlipSprite(blip, 1879260108, 1)
	  SetBlipScale(blip, 0.2)
	  Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Saloons')
	end  
end)