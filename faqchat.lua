-- Global
faqchatConfig = {}

SLASH_FAQCHAT1 = "/faqchat"
SLASH_FAQCHAT2 = "/faqc"
SLASH_FAQCHAT3 = "/faq"

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "faqchat" then
        print("FAQChat Loaded");
        RenderOptions();
    end
end
frame:SetScript("OnEvent", frame.OnEvent);

local frame2 = CreateFrame("Frame");
frame2:RegisterEvent("CHAT_MSG_WHISPER")
frame2:RegisterEvent("CHAT_MSG_GUILD")
frame2:SetScript("OnEvent", function(e, event, mess, sender)
    for key, value in pairs(faqchatConfig.buzz) do
        if key == nil or key == "" then
            print("Ignore Nil")
        else --mess:lower():match(key)
            if event == "CHAT_MSG_WHISPER" and string.match(mess:lower(), key:lower()) and faqchatConfig.checkwhisper[key] == true then
                SendChatMessage(value ,"WHISPER" ,"language" ,sender);
            end
            if event == "CHAT_MSG_GUILD" and string.match(mess:lower(), key:lower()) and faqchatConfig.checkguild[key] == true then
                SendChatMessage(value ,"GUILD");
            end
        end
    end
    print(mess);
    print(sender);
end)

local function OpenConfig()
    InterfaceOptionsFrame_Show();
    InterfaceOptionsFrame_OpenToCategory("FAQChat");
end

function RenderOptions()
    -- Main Config Frame
    local ConfigFrame = CreateFrame("FRAME","Config");
    ConfigFrame.name = "FAQChat";
    InterfaceOptions_AddCategory(ConfigFrame);
    -- Header
    local MessageHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
    MessageHeader:SetPoint("TOPLEFT", 10, -10);
    MessageHeader:SetText("FAQChat");
    -- BuzzProfile
    local InputBuzzHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormal");
    InputBuzzHeader:SetPoint("TOPLEFT", 10, -40);
    InputBuzzHeader:SetText("New BuzzProfile");
    InputBuzzProfile = CreateFrame("EditBox", "InputBuzz", ConfigFrame, "InputBoxTemplate");
    InputBuzzProfile:SetSize(100,100);
    InputBuzzProfile:SetAutoFocus(false);
    InputBuzzProfile:SetPoint("TOPLEFT",ConfigFrame, "TOPLEFT", 10, -15);
    -- BuzzMessage
    local InputTextHeader = ConfigFrame:CreateFontString(nil, "ARTWORK","GameFontNormal");
    InputTextHeader:SetPoint("TOPLEFT", 10, -75);
    InputTextHeader:SetText("Input Text");
    InputTextBox = CreateFrame("EditBox", "InputText", ConfigFrame, menu);
    InputTextBox:SetSize(400,400);
    InputTextBox:SetAutoFocus(false);
    InputTextBox:SetMultiLine(true);
    InputTextBox:SetPoint("TOPLEFT",ConfigFrame, "TOPLEFT", 10, -90);
    InputTextBox:SetBackdrop({
	    bgFile = [[Interface\Buttons\WHITE8x8]],
	    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	    edgeSize = 14,
	    insets = {left = 3, right = 3, top = 3, bottom = 3},
    })
    InputTextBox:SetBackdropColor(0, 0, 0)
    InputTextBox:SetBackdropBorderColor(0.3, 0.3, 0.3)
    InputTextBox:SetFont("Fonts\\FRIZQT__.TTF", 12)
    -- Whisper Chechbox
    WhisperCheckbox = CreateFrame("CheckButton", "WhisperCheckBox", ConfigFrame, "ChatConfigCheckButtonTemplate");
	WhisperCheckbox:SetPoint("TOPLEFT", 10, -125)
    getglobal(WhisperCheckbox:GetName() .. 'Text'):SetText("Whisper");
    -- Guildchat Checkbox
    GuildchatCheckbox = CreateFrame("CheckButton", "GuildchatCheckBox", ConfigFrame, "ChatConfigCheckButtonTemplate");
	GuildchatCheckbox:SetPoint("TOPLEFT", 10, -145)
    GuildchatCheckbox:SetText("Guildchat");
    getglobal(GuildchatCheckbox:GetName() .. 'Text'):SetText("Guild Chat");
    -- Save Button
    local SaveButton = CreateFrame("Button", "SaveButton", ConfigFrame, "OptionsButtonTemplate");
    SaveButton:SetPoint("TOPLEFT", 100, -10);
    SaveButton:SetText("Save");
    SaveButton:SetScript("OnClick", CreateBuzzProfile);
    -- Load Button
    local LoadButton = CreateFrame("Button", "LoadButton", ConfigFrame, "OptionsButtonTemplate");
    LoadButton:SetPoint("TOPLEFT", 100, -40);
    LoadButton:SetText("Load");
    LoadButton:SetScript("OnClick", LoadBuzzProfile);
    -- Delete Button
    local DeleteButton = CreateFrame("Button", "LoadButton", ConfigFrame, "OptionsButtonTemplate");
    DeleteButton:SetPoint("TOPLEFT", 100, -60);
    DeleteButton:SetText("Delete");
    DeleteButton:SetScript("OnClick", DeleteProfile);
    -- DropDownBuzzProfile
    BuzzProfileDropDown = L_Create_UIDropDownMenu("BuzzProfileDropDown", ConfigFrame);
	BuzzProfileDropDown:SetPoint("TOPLEFT", 500, -110)
	L_UIDropDownMenu_Initialize(BuzzProfileDropDown, BuzzProfileDropDownInitialize);
	L_UIDropDownMenu_SetWidth(BuzzProfileDropDown, 150);
	L_UIDropDownMenu_SetButtonWidth(BuzzProfileDropDown, 124);
	L_UIDropDownMenu_SetSelectedValue(BuzzProfileDropDown, GTFO.Settings.SoundChannel);
    L_UIDropDownMenu_JustifyText(BuzzProfileDropDown, "LEFT");

end

faqchatConfig.buzz = {}
faqchatConfig.checkwhisper = {}
faqchatConfig.checkguild = {}

function CreateBuzzProfile()
    print("Created new profile");
    buzzid = InputBuzzProfile:GetText();
    print(buzzid);
    if buzzid == nil or buzzid == "" then
        message("BuzzID ist leer")
    else
        faqchatConfig.buzz[buzzid] = InputTextBox:GetText();
        print(faqchatConfig.buzz[buzzid]);
        faqchatConfig.checkwhisper[buzzid] = WhisperCheckbox:GetChecked();
        print(faqchatConfig.checkwhisper[buzzid]);
        faqchatConfig.checkguild[buzzid] = GuildchatCheckbox:GetChecked();
        print(faqchatConfig.checkguild[buzzid]);
        print("Done");
        BuzzProfileDropDownInitialize();
        InputBuzzProfile:SetText("");
        InputTextBox:SetText("");
    end
end

function BuzzProfileDropDownInitialize(self, level)
    for key, value in pairs(faqchatConfig.buzz) do
        if key == nil or key == "" or value == nil or value == "" then
            print("Ignore Nil")
        else
            local InterfaceOptions_AddCategory
            info = L_UIDropDownMenu_CreateInfo();
            info.text = key;
            info.value = value;
            info.func = function(self, arg1, arg2, checked)
                L_UIDropDownMenu_SetSelectedValue(BuzzProfileDropDown, self.value);
            end
            L_UIDropDownMenu_AddButton(info, level);
            print(key);
            print(value);
        end
    end
end

function LoadBuzzProfile()
    local LoadID = L_UIDropDownMenu_GetText(BuzzProfileDropDown)
    print(LoadID)
    InputBuzzProfile:SetText(LoadID);
    InputTextBox:SetText(faqchatConfig.buzz[LoadID]);
    WhisperCheckbox:SetChecked(faqchatConfig.checkwhisper[LoadID]);
    GuildchatCheckbox:SetChecked(faqchatConfig.checkguild[LoadID]);
end

function DeleteProfile()
    local LoadID = L_UIDropDownMenu_GetText(BuzzProfileDropDown)
    print(LoadID)
    faqchatConfig.buzz[LoadID] = nil
    faqchatConfig.checkwhisper[LoadID] = nil
    faqchatConfig.checkguild[LoadID] = nil
end

SlashCmdList["FAQCHAT"] = OpenConfig;