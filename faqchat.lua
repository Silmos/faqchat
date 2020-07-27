-- Global
faqchatConfig = {}

SLASH_FAQCHAT1 = "/faqchat"
SLASH_FAQCHAT2 = "/faqc"
SLASH_FAQCHAT3 = "/faq"

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT");

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "faqchat" then
        print("FAQChat Loaded");
        RenderOptions();
    end
end
frame:SetScript("OnEvent", frame.OnEvent);

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
    -- Save Button
    local SaveButton = CreateFrame("Button", "SaveButton", ConfigFrame, "OptionsButtonTemplate");
    SaveButton:SetPoint("TOPLEFT", 100, -10);
    SaveButton:SetText("Save");
    SaveButton:SetScript("OnClick", CreateBuzzProfile);
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

function CreateBuzzProfile()
    print("Created new profile");
    buzzid = InputBuzzProfile:GetText();
    print(buzzid);
    print(faqchatConfig.buzz);
    faqchatConfig.buzz[buzzid] = InputTextBox:GetText();
    print("Done");
    BuzzProfileDropDownInitialize();
end

function BuzzProfileDropDownInitialize(self, level)
    for key, value in pairs(faqchatConfig.buzz) do
        print[k];
        print(value);
    end
end

SlashCmdList["FAQCHAT"] = OpenConfig;