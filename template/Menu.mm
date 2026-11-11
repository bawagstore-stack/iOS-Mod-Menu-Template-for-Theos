#import <Foundation/Foundation.h>
#import "Menu.h"

// sets the colors
void Menu::setColors() {
	style->Colors[ImGuiCol_WindowBg] = *winCol;
	style->Colors[ImGuiCol_Border] = ImColor(0, 0, 0, 0);
	style->Colors[ImGuiCol_Button] = *bgCol;
	style->Colors[ImGuiCol_ButtonActive] = *btnActiveCol;
	style->Colors[ImGuiCol_ButtonHovered] = *btnHoverCol;
	style->Colors[ImGuiCol_FrameBg] = *bgCol;
	style->Colors[ImGuiCol_FrameBgActive] = *frameCol;
	style->Colors[ImGuiCol_FrameBgHovered] = *hoverCol;
	style->Colors[ImGuiCol_Text] = *textCol;
	style->Colors[ImGuiCol_ChildBg] = *childCol;
	style->Colors[ImGuiCol_CheckMark] = *itemActiveCol;
	style->Colors[ImGuiCol_SliderGrab] = *itemCol;
	style->Colors[ImGuiCol_SliderGrabActive] = *itemActiveCol;
	style->Colors[ImGuiCol_Header] = *itemActiveCol;
	style->Colors[ImGuiCol_HeaderHovered] = *itemCol;
	style->Colors[ImGuiCol_HeaderActive] = *itemActiveCol;
	style->Colors[ImGuiCol_ResizeGrip] = *resizeGripCol;
	style->Colors[ImGuiCol_ResizeGripHovered] = *resizeGripHoverCol;
	style->Colors[ImGuiCol_ResizeGripActive] = *itemActiveCol;
	style->Colors[ImGuiCol_SeparatorHovered] = *resizeGripHoverCol;
	style->Colors[ImGuiCol_SeparatorActive] = *itemActiveCol;
	style->Colors[ImGuiCol_TitleBgActive] = *itemActiveCol;
}

// setup fonts
void Menu::loadFont() {
	ImGuiIO& io = ImGui::GetIO(); (void)io;
	io.Fonts->Clear();

	ImFontConfig font_cfg;
	font_cfg.FontDataOwnedByAtlas = false;
	io.Fonts->AddFontFromMemoryTTF((void*)poppinsFont, sizeof(poppinsFont), isIphone ? 20 : 24, &font_cfg);

	static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_FA, 0 };
	ImFontConfig icons_config;
	icons_config.MergeMode = true;
	icons_config.PixelSnapH = true;
	icons_config.FontDataOwnedByAtlas = false;
	io.Fonts->AddFontFromMemoryTTF((void*)fontAwesome, sizeof(fontAwesome), isIphone ? 20 : 24, &icons_config, icons_ranges);

	ImFontConfig bigFontCfg;
	bigFontCfg.FontDataOwnedByAtlas = false;
	bigFont = io.Fonts->AddFontFromMemoryTTF((void*)poppinsFont, sizeof(poppinsFont), isIphone ? 24 : 30, &bigFontCfg);
	io.Fonts->AddFontFromMemoryTTF((void*)fontAwesome, sizeof(fontAwesome), isIphone ? 20 : 24, &icons_config, icons_ranges);
}

// load theme
void Menu::loadTheme() {
	loadFont();

	style = &ImGui::GetStyle();

	style->WindowRounding = 6;
	style->ChildRounding = 6;
	style->FrameRounding = 2;
	style->GrabRounding = 2;
	style->PopupRounding = 2;

	style->ScrollbarSize = 9;
	style->FramePadding = ImVec2(6, 3);
	style->ItemSpacing = ImVec2(4, 4);

	setColors();
}

// Top left part of the menu
void Menu::renderLogo() {
	ImGui::BeginGroup(); {
		ImGui::BeginChild(obf("Logo").c_str(), ImVec2(isIphone ? 118.5 : 158, isIphone ? 37.5 : 50), true);

		ImGui::PushFont(bigFont);
		ImGui::SameLine();
		ImGui::SetCursorPosY(isIphone ? 5 : 11);
		ImGui::TextUnformatted(obf("BAWA G STORE").c_str());
		ImGui::PopFont();

		ImGui::EndChild();
		ImGui::EndGroup();
	}
}

// Bottom Left Part of the menu 
void Menu::renderUser() {
	int height = isIphone * 110 + !isIphone * 140;
	ImGui::Dummy(ImVec2(0.0f, ImGui::GetContentRegionAvail().y - height - style->ItemSpacing.y));
	ImGui::BeginChild(obf("User").c_str(), ImVec2(isIphone ? 118.5 : 158, height), true);
	ImGui::Text("BAWA G STORE");
	ImGui::Spacing();
	if (ImGui::Button("Telegram")) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/bawagstore"] options:@{} completionHandler:nil];
	}
	if (ImGui::Button("WhatsApp")) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://chat.whatsapp.com/F9ZdAEk39iuGeAiALXZ6oJ"] options:@{} completionHandler:nil];
	}
	ImGui::EndChild();
}

// The One Responsible Drawing all of this
void Menu::renderPanel() {
	renderLogo();
	ImGui::Spacing();
	renderTabs();
	renderUser();
}

// the Selectable Buttons
void Menu::renderTabs() {
	ImGui::BeginChild(obf("tabs").c_str(), ImVec2(isIphone ? 118.5 : 158, isIphone ? 165 : 220), true);
	ImGui::Spacing();

	ImVec4 col(0, 0, 0, 0);
	ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 10);
	std::string tabNames[] = { obf(ICON_FA_CROSSHAIRS " Main"), obf(ICON_FA_EYE " Visuals"), obf(ICON_FA_COG " Misc"), obf(ICON_FA_TOOLS " Settings") };
	
	float buttonWidth = isIphone ? 100.0f : 140.0f;
	float buttonHeight = isIphone ? 30.0f : 40.0f;
	
	for (int i = 0; i < sizeof(tabNames) / sizeof(tabNames[0]); i++) {
		std::string it = tabNames[i];
		ImGui::PushStyleVar(ImGuiStyleVar_ButtonTextAlign, ImVec2(0, 0.5));
		ImGui::PushStyleColor(ImGuiCol_Button, selectedTab == i ? style->Colors[ImGuiCol_ButtonActive] : col);
		ImGui::PushStyleColor(ImGuiCol_Text, selectedTab == i ? style->Colors[ImGuiCol_Text] : *notSelectedTextColor);
		if (ImGui::Button(it.c_str(), ImVec2(buttonWidth, buttonHeight))) selectedTab = i;
		ImGui::PopStyleVar();
		ImGui::PopStyleColor(2);
	}
	ImGui::PopStyleVar();
	ImGui::EndChild();
}

// SubTabs
void Menu::renderSubTab0() {
	std::vector<std::string> arr = { obf("TAB1"), obf("TAB2"), obf("TAB3") };
	ImGuiHelper::drawTabHorizontally(obf("subtab-0"), ImVec2(ImGuiHelper::getWidth(), 50), arr, selectedSubTab0);
	ImGui::Spacing();

	ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0, 0, 0, 0));
	ImGui::BeginChild(obf("modules-wrapper").c_str(), ImVec2(ImGui::GetContentRegionAvail().x, ImGui::GetContentRegionAvail().y), false);
	ImGui::PopStyleColor();

	switch (selectedSubTab0) {
	case 0: {
		ImGui::Columns(2, nullptr, false);
		ImGui::SetColumnOffset(1, 300);
		ImGui::BeginChild(obf("aimassist").c_str(), ImVec2(ImGuiHelper::getWidth(), 300), true);
		ImGui::EndChild();
		ImGui::Spacing();
		ImGui::BeginChild(obf("aimassist2").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		ImGui::NextColumn();
		ImGui::BeginChild(obf("aimassist3").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		break;
	}
	case 1: break;
	case 2: break;
	}
	ImGui::EndChild();
}

void Menu::renderSubTab1() {
	ImGuiHelper::drawTabHorizontally(obf("subtab-1"), ImVec2(ImGuiHelper::getWidth(), 50), { obf("ESP"), obf("World"), obf("Other") }, selectedSubTab1);
	ImGui::Spacing();

	ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0, 0, 0, 0));
	ImGui::BeginChild(obf("modules-wrapper").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), false);
	ImGui::PopStyleColor();

	switch (selectedSubTab1) {
	case 0: {
		ImGui::Columns(2, nullptr, false);
		ImGui::SetColumnOffset(1, 300);
		ImGui::BeginChild(obf("esp").c_str(), ImVec2(ImGuiHelper::getWidth(), 300), true);
		ImGui::EndChild();
		ImGui::Spacing();
		ImGui::BeginChild(obf("Markers").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		ImGui::NextColumn();
		ImGui::BeginChild(obf("esp2").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		break;
	}
	case 1: break;
	case 2: break;
	}
	ImGui::EndChild();
}

void Menu::renderSubTab2() {
	std::vector<std::string> arr = { obf("General"), obf("Other") };
	ImGuiHelper::drawTabHorizontally(obf("subtab-2"), ImVec2(ImGuiHelper::getWidth(), 50), arr, selectedSubTab2);
	ImGui::Spacing();

	ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0, 0, 0, 0));
	ImGui::BeginChild(obf("modules-wrapper").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), false);
	ImGui::PopStyleColor();

	switch (selectedSubTab2) {
	case 0: {
		ImGui::Columns(2, nullptr, false);
		ImGui::SetColumnOffset(1, 300);
		ImGui::BeginChild(obf("misc##0-0").c_str(), ImVec2(ImGuiHelper::getWidth(), 300), true);
		ImGui::Checkbox("Streamer Mode", &StreamerMode);
		ImGui::EndChild();
		ImGui::Spacing();
		ImGui::BeginChild(obf("misc##0-1").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		ImGui::NextColumn();
		ImGui::BeginChild(obf("misc##0-2").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		break;
	}
	case 1: {
		ImGui::Columns(2, nullptr, false);
		ImGui::SetColumnOffset(1, 300);
		ImGui::BeginChild(obf("gui").c_str(), ImVec2(ImGui::GetContentRegionAvail().x, 300), true);
		ImGui::ColorEdit4(obf("Window Color##1").c_str(), (float*)winCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("BackGround Color##1").c_str(), (float*)childCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Frame Color##1").c_str(), (float*)frameCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Button Color##1").c_str(), (float*)bgCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Button Hovered Color##1").c_str(), (float*)btnHoverCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Button Active Color##1").c_str(), (float*)btnActiveCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Item Color##1").c_str(), (float*)itemCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		ImGui::ColorEdit4(obf("Item Active Color##1").c_str(), (float*)itemActiveCol, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
		setColors();
		ImGui::EndChild();
		ImGui::Spacing();
		ImGui::BeginChild(obf("smth").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		ImGui::NextColumn();
		ImGui::BeginChild(obf("whoknows").c_str(), ImVec2(ImGuiHelper::getWidth(), ImGuiHelper::getHeight()), true);
		ImGui::EndChild();
		break;
	}
	}
	ImGui::EndChild();
}

void Menu::render() {
	if (ImGui::Begin("ModMenu", nullptr, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoTitleBar)) {
		ImGuiWindow* CurrentWindow = ImGui::GetCurrentWindow();
		MenuSize   = CurrentWindow->Size;
		MenuOrigin = CurrentWindow->Pos;

		renderPanel();
		ImGui::SameLine();
		
		ImGui::BeginChild(obf("MainContent").c_str(), ImVec2(ImGui::GetContentRegionAvail().x, ImGui::GetContentRegionAvail().y), false);
		switch (selectedTab) {
		case 0: renderSubTab0(); break;
		case 1: renderSubTab1(); break;
		case 2: renderSubTab2(); break;
		case 3: break;
		}
		ImGui::EndChild();

		ImGui::End();
	}
}
