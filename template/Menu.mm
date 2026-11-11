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

// Top Welcome Card & Logo matching your requested style
void Menu::renderLogo() {
	ImGui::BeginGroup();
	
	float cardWidth = isIphone ? 300.0f : 360.0f;
	ImGui::SetCursorPosX((ImGui::GetWindowWidth() - cardWidth) * 0.5f);
	ImGui::BeginChild(obf("WelcomeCard").c_str(), ImVec2(cardWidth, isIphone ? 340.0f : 380.0f), true, ImGuiWindowFlags_NoScrollbar);
	
	ImGui::Spacing();
	
	// Title: WELCOME TO BAWA G STORE
	ImGui::PushFont(bigFont);
	std::string title1 = "WELCOME TO";
	std::string title2 = "BAWA G STORE";
	
	ImGui::SetCursorPosX((cardWidth - ImGui::CalcTextSize(title1.c_str()).x) * 0.5f);
	ImGui::TextColored(ImVec4(0.9f, 0.9f, 0.9f, 1.0f), "%s", title1.c_str());
	
	ImGui::SetCursorPosX((cardWidth - ImGui::CalcTextSize(title2.c_str()).x) * 0.5f);
	ImGui::TextColored(ImVec4(0.1f, 0.7f, 1.0f, 1.0f), "%s", title2.c_str());
	ImGui::PopFont();
	
	ImGui::Spacing();
	
	// Logo Placeholder (Centered)
	float imgSize = isIphone ? 65.0f : 85.0f;
	ImGui::SetCursorPosX((cardWidth - imgSize) * 0.5f);
	ImGui::Button(obf("BAWA G LOGO").c_str(), ImVec2(imgSize, imgSize));
	
	ImGui::Spacing();
	
	// Subtitle / Tagline
	std::string subtitle = "Enjoy, dear friend — BAWA G is everyone's friend";
	ImGui::SetCursorPosX((cardWidth - ImGui::CalcTextSize(subtitle.c_str()).x) * 0.5f);
	ImGui::TextColored(ImVec4(0.6f, 0.6f, 0.6f, 1.0f), "%s", subtitle.c_str());
	
	ImGui::Spacing();
	ImGui::Spacing();
	
	// Sleek Card Buttons (Telegram & WhatsApp)
	float btnW = cardWidth - 30.0f;
	float btnH = 42.0f;
	
	ImGui::SetCursorPosX(15.0f);
	if (ImGui::Button(obf("  Telegram Channel          >").c_str(), ImVec2(btnW, btnH))) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/bawagstore"] options:@{} completionHandler:nil];
	}
	
	ImGui::Spacing();
	ImGui::SetCursorPosX(15.0f);
	if (ImGui::Button(obf("  WhatsApp Group            >").c_str(), ImVec2(btnW, btnH))) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://chat.whatsapp.com/F9ZdAEk39iuGeAiALXZ6oJ"] options:@{} completionHandler:nil];
	}
	
	ImGui::EndChild();
	ImGui::EndGroup();
}

void Menu::renderUser() {}
void Menu::renderPanel() { renderLogo(); }
void Menu::renderTabs() {}
void Menu::renderSubTab0() {}
void Menu::renderSubTab1() {}
void Menu::renderSubTab2() {}

void Menu::render() {
	if (ImGui::Begin("ModMenu", nullptr, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoTitleBar)) {
		ImGuiWindow* CurrentWindow = ImGui::GetCurrentWindow();
		MenuSize   = CurrentWindow->Size;
		MenuOrigin = CurrentWindow->Pos;

		renderPanel();
		ImGui::End();
	}
}
