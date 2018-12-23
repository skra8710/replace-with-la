--
-- Replace all notes with "La" or 「ら」
--

--
-- Sakura
-- April 29, 2018 thru April 30, 2018
--

--
-- Manifest
--
function manifest()
    myManifest = {
        name          = "Type La",
        comment       = "Convert lyrics to La",
        author        = "Sakura",
        pluginID      = "{c7f86264-c1a3-4825-bc97-1e4e7f1ab5ca}",
        pluginVersion = "1.0",
        apiVersion    = "3.0.1.0"
    }
    
    return myManifest
end

-- 
-- Main Function
--
function main(processParam, envParam)
    -- Variables
    local note
    local noteCount
    local retCode
    local dlgStatus
    local lyrics = ""
    local la -- la or ら
    local phoneme = "4 a" -- [4 a] or [l0 Q]
    local k --counter variable
    
	-- Dialog Window Name
	VSDlgSetDialogTitle("Convert to La")

    -- Form to choose La or ら
	local field = {}
    
	-- find out if they want la or ら
    -- dropdown list
	field.name       = "laType"
	field.caption    = "Choose La or ら or 啦 or 라 or La"
	field.initialVal =
		"La [English],ら,啦,라,La [Español]"
	field.type = 4
	dlgStatus  = VSDlgAddField(field)
    
    -- get info from dialogue box
	dlgStatus = VSDlgDoModal()
	if (dlgStatus == 2) then
		-- When it was cancelled.
		return 0
	end
	if ((dlgStatus ~= 1) and (dlgStatus ~= 2)) then
		-- When it returned an error.
		return 1
	end
    
	-- get value of la
	dlgStatus, la = VSDlgGetStringValue("laType")
    
    -- English or Japanese phonemes
    -- note: Japanese by default
    if (la == "La [English]") then
        phoneme = "l0 Q"
    elseif (la == "啦") then
        phoneme = "l ia"
    elseif (la == "라") then
        phoneme = "l a"
    elseif (la == "La [Español]") then
        phoneme = "l a"
    else --la == "ら"
        phoneme = "4 a"
    end
    
	-- get list of notes
	k = 1
    local noteList = {}
	VSSeekToBeginNote()
	retCode, note = VSGetNextNoteEx()
    while (retCode == 1) do
        noteList[k] = note
        k = k + 1
        retCode, note = VSGetNextNoteEx()
    end
    
	-- check if part is empty
	noteCount = table.getn(noteList)
	if (noteCount == 0) then
		VSMessageBox("No notes in part!", 0)
		return 0
	end
    
    if ((la == "La [English]") or (la == "La [Español]")) then
        la = "La"
    end
    
    -- loop through musical part until you're done
	for k = 1, noteCount do
        noteList[k].lyric = la
        noteList[k].phonemes = phoneme
        lyrics = lyrics .. noteList[k].lyric
        retCode = VSUpdateNoteEx(noteList[k])
        if (retCode == 0) then
			VSMessageBox("Cannot update notes!", 0)
            break
        end
    end
    
    return 0
end
