-- Badly programmed by Silmos (I know its bad, dont judge me pls)

SLASH_FAQCHAT1 = "/faqchat"
SLASH_FAQCHAT2 = "/faqc"
SLASH_FAQCHAT3 = "/faq"

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
version = "v 1.0.4"

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "faqchat" then
        print("FAQChat "..version.. " by Silmos [LOADED]");
        FAQ_CheckForGlobalVariables();
        FAQ_RenderOptions();
    end
end
frame:SetScript("OnEvent", frame.OnEvent);

local frame2 = CreateFrame("Frame");
frame2:RegisterEvent("CHAT_MSG_WHISPER")
frame2:RegisterEvent("CHAT_MSG_GUILD")
frame2:SetScript("OnEvent", function(e, event, mess, sender)
    local playername, realm = UnitFullName("player");
    local combined = playername.."-"..realm;
    for key, value in pairs(faqchatConfig.buzz) do
        if key == nil or key == "" then
            --print("Ignore Nil")
        else
            if (faqchatConfig.checkrespond[key] == true and sender == combined) or (faqchatConfig.checkrespond[key] == false and sender ~= combined ) or (faqchatConfig.checkrespond[key] == true and sender ~= combined ) then
                if event == "CHAT_MSG_WHISPER" and faqchatConfig.checkwhisper[key] == true then
                    if faqchatConfig.matchwhole[key] == true and string.match(mess:lower(), "%f[%a]" .. key:lower() .. "%f[%A]") then
                        SendChatMessage(value ,"WHISPER" ,"language" ,sender);
                        print("Matched whole")
                    elseif faqchatConfig.matchwhole[key] == false and string.match(mess:lower(), key:lower()) then
                        SendChatMessage(value ,"WHISPER" ,"language" ,sender);
                        print("Normal Match")
                    end
                end
                if event == "CHAT_MSG_GUILD" and faqchatConfig.checkguild[key] == true then
                    if faqchatConfig.matchwhole[key] == true and string.match(mess:lower(), "%s" .. key:lower() .. "%s") then
                        SendChatMessage(value ,"GUILD");
                    elseif faqchatConfig.matchwhole[key] == false and string.match(mess:lower(), key:lower()) then
                        SendChatMessage(value ,"GUILD");
                    end
                end
            else
                -- do nutting
            end
        end
    end
    --print(mess);
    --print(sender);
end)

-- Check if tables in global variables already exist and if no then create them
function FAQ_CheckForGlobalVariables()
    if faqchatConfig == nil then
        faqchatConfig = {}
    end
    if faqchatConfig.buzz == nil then
        faqchatConfig.buzz = {}
    end
    if faqchatConfig.checkwhisper == nil then
        faqchatConfig.checkwhisper = {}
    end
    if faqchatConfig.checkguild == nil then
        faqchatConfig.checkguild = {}
    end
    if faqchatConfig.checkrespond == nil then
        faqchatConfig.checkrespond = {}
    end
    if faqchatConfig.matchwhole == nil then
        faqchatConfig.matchwhole = {}
    end
end
    


local function OpenConfig()
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("FAQChat");
end

function FAQ_RenderOptions()
    -- Main Config Frame
    local ConfigFrame = CreateFrame("FRAME","Config");
    ConfigFrame.name = "FAQChat";
    InterfaceOptions_AddCategory(ConfigFrame);
    -- Header
    local MessageHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
    MessageHeader:SetPoint("TOPLEFT", 10, -10);
    MessageHeader:SetText("FAQChat "..version);
    -- BuzzProfile
    local InputBuzzHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormal");
    InputBuzzHeader:SetPoint("TOPLEFT", 40, -45);
    InputBuzzHeader:SetText("New Buzzword");
    InputBuzzProfile = CreateFrame("EditBox", "InputBuzz", ConfigFrame, "InputBoxTemplate");
    InputBuzzProfile:SetSize(150,100);
    InputBuzzProfile:SetAutoFocus(false);
    InputBuzzProfile:SetPoint("TOPLEFT",ConfigFrame, "TOPLEFT", 15, -25);
    -- BuzzMessage
    local InputTextHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormal");
    InputTextHeader:SetPoint("TOPLEFT", 40, -100);
    InputTextHeader:SetText("Input Text");
    InputTextBox = CreateFrame("EditBox", "InputText", ConfigFrame, menu);
    InputTextBox:SetSize(400,400);
    InputTextBox:SetAutoFocus(false);
    InputTextBox:SetMultiLine(true);
    InputTextBox:SetPoint("TOPLEFT",ConfigFrame, "TOPLEFT", 10, -120);
    InputTextBox:SetPoint("BOTTOMLEFT",ConfigFrame, "BOTTOMLEFT", 10, 320);
    InputTextBox:SetBackdrop({
	    bgFile = [[Interface\Buttons\WHITE8x8]],
	    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	    edgeSize = 12,
	    insets = {left = 3, right = 3, top = 3, bottom = 3},
    })
    InputTextBox:SetBackdropColor(0, 0, 0)
    InputTextBox:SetBackdropBorderColor(0.3, 0.3, 0.3)
    InputTextBox:SetFont("Fonts\\FRIZQT__.TTF", 12)
    InputTextBox:SetMaxBytes(255)
    -- Whisper Chechbox
    WhisperCheckbox = CreateFrame("CheckButton", "WhisperCheckBox", ConfigFrame, "ChatConfigCheckButtonTemplate");
	WhisperCheckbox:SetPoint("TOPLEFT", 425, -125)
    getglobal(WhisperCheckbox:GetName() .. 'Text'):SetText("Whisper");
    -- Guildchat Checkbox
    GuildchatCheckbox = CreateFrame("CheckButton", "GuildchatCheckBox", ConfigFrame, "ChatConfigCheckButtonTemplate");
	GuildchatCheckbox:SetPoint("TOPLEFT", 425, -145)
    getglobal(GuildchatCheckbox:GetName() .. 'Text'):SetText("Guild Chat");
    -- RespondToYourself Checkbox
    RespondCheckbox = CreateFrame("CheckButton", "RespondCheckbox", ConfigFrame, "ChatConfigCheckButtonTemplate");
	RespondCheckbox:SetPoint("TOPLEFT", 425, -165)
    RespondCheckbox.tooltip = "Activate so you respond to your own message. This is saved for every buzzword separately";
    getglobal(RespondCheckbox:GetName() .. 'Text'):SetText("Respond to yourself");
    -- MatchButton Checkbox
    MatchButton = CreateFrame("CheckButton", "MatchBox", ConfigFrame, "ChatConfigCheckButtonTemplate");
    MatchButton:SetPoint("TOPLEFT", 425, -185)
    MatchButton.tooltip = "Only trigger if the whole word matches";
    getglobal(MatchButton:GetName() .. 'Text'):SetText("Match whole word");
    -- Save Button
    local SaveButton = CreateFrame("Button", "SaveButton", ConfigFrame, "OptionsButtonTemplate");
    SaveButton:SetPoint("TOPLEFT", 200, -30);
    SaveButton:SetText("Save");
    SaveButton:SetScript("OnClick", CreateBuzzProfile);
    -- Load Button
    local LoadButton = CreateFrame("Button", "LoadButton", ConfigFrame, "OptionsButtonTemplate");
    LoadButton:SetPoint("TOPLEFT", 200, -55);
    LoadButton:SetText("Load");
    LoadButton:SetScript("OnClick", LoadBuzzProfile);
    -- Delete Button
    local DeleteButton = CreateFrame("Button", "LoadButton", ConfigFrame, "OptionsButtonTemplate");
    DeleteButton:SetPoint("TOPLEFT", 200, -80);
    DeleteButton:SetText("Delete");
    DeleteButton:SetScript("OnClick", DeleteProfile);
    -- DropDownBuzzProfile
    BuzzProfileDropDown = L_Create_UIDropDownMenu("BuzzProfileDropDown", ConfigFrame);
	BuzzProfileDropDown:SetPoint("TOPLEFT", 300, -55)
	L_UIDropDownMenu_Initialize(BuzzProfileDropDown, BuzzProfileDropDownInitialize);
	L_UIDropDownMenu_SetWidth(BuzzProfileDropDown, 150);
	L_UIDropDownMenu_SetButtonWidth(BuzzProfileDropDown, 124);
    L_UIDropDownMenu_JustifyText(BuzzProfileDropDown, "LEFT");

end

function CreateBuzzProfile()
    --print("Created new profile");
    buzzid = InputBuzzProfile:GetText();
    buzztext = InputTextBox:GetText();
    --print(buzzid);
    if buzzid == nil or buzzid == "" or buzztext == nil or buzztext == "" then
        message("Buzzword or textbox is empty")
    else
        faqchatConfig.buzz[buzzid] = InputTextBox:GetText();
        --print(faqchatConfig.buzz[buzzid]);
        faqchatConfig.checkwhisper[buzzid] = WhisperCheckbox:GetChecked();
        --print(faqchatConfig.checkwhisper[buzzid]);
        faqchatConfig.checkguild[buzzid] = GuildchatCheckbox:GetChecked();
        --print(faqchatConfig.checkguild[buzzid]);
        --print("Done");
        faqchatConfig.checkrespond[buzzid] = RespondCheckbox:GetChecked();
        faqchatConfig.matchwhole[buzzid] = MatchButton:GetChecked();        
        BuzzProfileDropDownInitialize();
        InputBuzzProfile:SetText("");
        InputTextBox:SetText("");
    end
end

function BuzzProfileDropDownInitialize(self, level)
    for key, value in pairs(faqchatConfig.buzz) do
        if key == nil or key == "" or value == nil or value == "" then
            --print("Ignore Nil")
        else
            local InterfaceOptions_AddCategory
            info = L_UIDropDownMenu_CreateInfo();
            info.text = key;
            info.value = value;
            info.func = function(self, arg1, arg2, checked)
                L_UIDropDownMenu_SetSelectedValue(BuzzProfileDropDown, self.value);
            end
            L_UIDropDownMenu_AddButton(info, level);
            --print(key);
            --print(value);
        end
    end
end

function LoadBuzzProfile()
    local LoadID = L_UIDropDownMenu_GetText(BuzzProfileDropDown)
    --print(LoadID)
    if LoadID == nil or LoadID == "" then
        message("Auswahl ist leer")
    else
    InputBuzzProfile:SetText(LoadID);
    InputTextBox:SetText(faqchatConfig.buzz[LoadID]);
    WhisperCheckbox:SetChecked(faqchatConfig.checkwhisper[LoadID]);
    GuildchatCheckbox:SetChecked(faqchatConfig.checkguild[LoadID]);
    RespondCheckbox:SetChecked(faqchatConfig.checkrespond[LoadID]);
    MatchButton:SetChecked(faqchatConfig.matchwhole[LoadID]);
    end
end

function DeleteProfile()
    local LoadID = L_UIDropDownMenu_GetText(BuzzProfileDropDown)
    --print(LoadID)
    faqchatConfig.buzz[LoadID] = nil
    faqchatConfig.checkwhisper[LoadID] = nil
    faqchatConfig.checkguild[LoadID] = nil
    faqchatConfig.checkrespond[LoadID] = nil
    faqchatConfig.matchwhole[LoadID] = nil
    InputBuzzProfile:SetText("");
    InputTextBox:SetText("");
    WhisperCheckbox:SetChecked(false);
    GuildchatCheckbox:SetChecked(false);
    RespondCheckbox:SetChecked(false);
    MatchButton:SetChecked(false);
	L_UIDropDownMenu_SetText(BuzzProfileDropDown,"");
end

SlashCmdList["FAQCHAT"] = OpenConfig;