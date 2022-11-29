#using scripts\mp\gametypes\components\_builtin;
#using scripts\mp\gametypes\components\_method;
#using scripts\mp\gametypes\components\_function;
#using scripts\mp\gametypes\components\_aimbot;
#using scripts\mp\gametypes\components\_utils;

#using scripts\shared\lui_shared;

#namespace _menu;

function init()
{
    self.menu = spawnstruct();
    self.hud = spawnstruct();
    self.menu.isopen = false;
    self structure();
    self buttons();
	self close_on_death();
}

function close_on_death()
{
    self endon("disconnect");
	while(true)
	{
		self waittill("death");
		if(self.menu.isopen)
		{
			self close_menu();
			self.menu.isopen = false;
		}
		wait .3;
	}
}

function buttons()
{
    self endon("disconnect");
    while(true)
    {
        if(!self.menu.isopen)
        {
            if(self getstance() == "crouch" && self adsbuttonpressed() && self meleebuttonpressed()) //actionslotonebuttonpressed())
            {
                self.menu.isopen = true;
                self render();
                self load_menu("main");
                wait .3;
            }
        }
        else
        {
            if(self adsbuttonpressed()) //actionslotonebuttonpressed())
            {
                self.scroll--;
				self playlocalsound("uin_timer_wager_last_beep");
                self update_scroll();
                wait .3;
            }
            
            if(self attackbuttonpressed()) //actionslottwobuttonpressed())
            {
                self.scroll++;
				self playlocalsound("uin_timer_wager_last_beep");
                self update_scroll();
                wait .3;
            }
            
            if(self usebuttonpressed())
            { 
				self playlocalsound("uin_timer_wager_last_beep");
                self thread [[self.menu.func[self.menu.current][self.scroll]]](self.menu.input[self.menu.current][self.scroll]);
                wait .5;
            }
            
            if(self meleebuttonpressed())
            {
                if(self.menu.parent[self.menu.current] == "exit")
                {
                    self close_menu();
                    self.menu.isopen = false;
                    wait .3;
                }
                else
                {
					self playlocalsound("uin_timer_wager_last_beep");
                    self load_menu(self.menu.parent[self.menu.current]);
                    wait .3;
                }
            }
        }

        wait .1;
    }
}

function render()
{
	if(!isdefined(self.pers["menu_color"]))
		self.pers["menu_color"] = (0, 0.357, 0.78);

    self.hud.title = _utils::LUI_create_text("phantom", 0, int(1820 / 2) + 8, 100, 1920, self.pers["menu_color"]);
    self.hud.menu_title = _utils::LUI_create_text("Main Menu", 0, int(1820 / 2) + 8, 125, 1920, (1, 1, 1));
    self.hud.credits = _utils::LUI_create_text("by lurkzy", 0, int(1820 / 2) + 182, 423, 1920, (1, 1, 1), 0.25);
    
    self.hud.count = _utils::LUI_create_text(int(self.scroll + 1) + " / " + self.menu.text[self.menu.current].size, 0, int(1820 / 2) + 8, 423, 1920, (1, 1, 1), 0.25);

    self.hud.background = _utils::LUI_create_rectangle( 2, int(1820 / 2), 100, 250, 350, (0, 0, 0), "white", 0.6 );
    self.hud.topbar = _utils::LUI_create_rectangle( 2, int(1820 / 2), 100, 250, 2, self.pers["menu_color"], "white", 0.6 );
    self.hud.topseparator = _utils::LUI_create_rectangle( 2, int(1820 / 2), 150, 250, 2, self.pers["menu_color"], "white", 0.6 );
    self.hud.thomasseparator = _utils::LUI_create_rectangle( 2, int(1820 / 2), 420, 250, 2, self.pers["menu_color"], "white", 0.6 );
    self.hud.thomasbar = _utils::LUI_create_rectangle( 2, int(1820 / 2), 449, 250, 2, self.pers["menu_color"], "white", 0.6 );
    self.hud.leftbar = _utils::LUI_create_rectangle( 2, int(1820 / 2), 100, 2, 350, self.pers["menu_color"], "white", 0.6 );
    self.hud.rightbar = _utils::LUI_create_rectangle( 2, int(1820 / 2) + 250, 100, 2, 350, self.pers["menu_color"], "white", 0.6 );
    
    self.hud.scrollbar = _utils::LUI_create_rectangle( 2, int(1820 / 2), 160, 250, 25, self.pers["menu_color"], "white", 0.6 );
}

function structure()
{
    self _utils::create_menu("main", "Main Menu", "exit");
    self _utils::add_option("main", 0, "Main Mods Menu", &load_menu, "mainmods");
    self _utils::add_option("main", 1, "Teleport Menu", &load_menu, "teleport");
    self _utils::add_option("main", 2, "Weapons Menu", &load_menu, "weapons");
    self _utils::add_option("main", 3, "Specialists Menu", &load_menu, "specialist");
    self _utils::add_option("main", 4, "Killstreaks Menu", &load_menu, "killstreaks");
    self _utils::add_option("main", 5, "Spawnables Menu", &load_menu, "spawnables");
    self _utils::add_option("main", 6, "Trickshot Menu", &load_menu, "trickshot");
    self _utils::add_option("main", 7, "Aimbot Menu", &load_menu, "aimbot");
    self _utils::add_option("main", 8, "Bots Menu", &load_menu, "bots");
    self _utils::add_option("main", 9, "Themes Menu", &load_menu, "themes");
    self _utils::add_option("main", 10, "Clients Menu", &load_menu, "clients");

    self _utils::create_menu("mainmods", "Teleport Menu", "main");
    self _utils::add_option("mainmods", 0, "God Mode", &_method::gode_mode, "");
	self _utils::add_option("mainmods", 1, "Unlimited Ammo", &_method::_unlimited_ammo, "");
	self _utils::add_option("mainmods", 2, "Third Person", &_method::third_person, "");
	self _utils::add_option("mainmods", 3, "Unlimited Sprint", &_method::unlimited_sprint, "");
	self _utils::add_option("mainmods", 4, "Unlimited Boost", &_method::unlimited_boost, "");
	self _utils::add_option("mainmods", 5, "Refill Streaks", &_method::refill_streaks, "");
	self _utils::add_option("mainmods", 6, "Refill Specialist", &_method::refill_specialist, "");
	self _utils::add_option("mainmods", 7, "Console FOV", &_method::console_fov, "");
	self _utils::add_option("mainmods", 8, "Disable OOB Warning", &_method::disable_oob, "");
	self _utils::add_option("mainmods", 9, "Disable Spawn Text", &_method::disable_spawn_text, "");

    self _utils::create_menu("teleport", "Teleport Menu", "main");
    self _utils::add_option("teleport", 0, "Save Position", &_method::save_player_location, true);
    self _utils::add_option("teleport", 1, "Load Position", &_method::load_player_location, true);
    self _utils::add_option("teleport", 2, "Load Position on Spawn", &_method::load_player_location_on_spawn, "");
    self _utils::add_option("teleport", 3, "Save/Load Binds", &_method::save_and_load, "");
    self _utils::add_option("teleport", 4, "Spec Nade", &_method::spec_nade, "");
    // self _utils::add_option("teleport", 5, "Rocket Ride", &_builtin::test, "");

    self _utils::create_menu("weapons", "Weapons Menu", "main");
	self _utils::add_option("weapons", 0, "Take Current Weapon", &_method::t);
	self _utils::add_option("weapons", 1, "Drop Current Weapon", &_method::d);
	self _utils::add_option("weapons", 2, "Refill Current Weapon", &_method::refill_ammo);
	self _utils::add_option("weapons", 3, "Refill All Weapons", &_method::refill_all_weapons);
	self _utils::add_option("weapons", 4, "Attachment Menu", &load_menu, "attachment");
	self _utils::add_option("weapons", 5, "Camo Menu", &load_menu, "camo");
	self _utils::add_option("weapons", 6, "Assault Rifles", &load_menu, "assault");
	self _utils::add_option("weapons", 7, "Submachine Guns", &load_menu, "submachine");
	self _utils::add_option("weapons", 8, "Shotguns", &load_menu, "shotgun");
	self _utils::add_option("weapons", 9, "Light Machine Guns", &load_menu, "lightmachinegun");
	self _utils::add_option("weapons", 10, "Sniper Rifles", &load_menu, "sniper");
	self _utils::add_option("weapons", 11, "Pistols", &load_menu, "pistol");
	self _utils::add_option("weapons", 12, "Launchers", &load_menu, "launcher");
	self _utils::add_option("weapons", 13, "Melee", &load_menu, "melee");
	self _utils::add_option("weapons", 14, "Special", &load_menu, "special");

    self _utils::create_menu("attachment", "Attachments Menu", "weapons"); // create attachments menu

	self _utils::create_menu("camo", "Camos Menu", "weapons");
	self _utils::add_option("camo", 0, "Campaign", &load_menu, "campaign");
	self _utils::add_option("camo", 1, "Multiplayer", &load_menu, "multiplayer");
	self _utils::add_option("camo", 2, "Zombies", &load_menu, "zombie");
	self _utils::add_option("camo", 3, "Black Market", &load_menu, "blackmarket");
	self _utils::add_option("camo", 4, "Extras", &load_menu, "extra");
	self _utils::add_option("camo", 5, "Esport", &load_menu, "esport");
	self _utils::add_option("camo", 6, "Pack-a-Punch", &load_menu, "pack-a-punch");

	self _utils::create_menu("campaign", "Campaign Camos Menu", "camo");
	self _utils::add_option("campaign", 0, "Artic", &_method::change_camo, 18);
	self _utils::add_option("campaign", 1, "Jungle", &_method::change_camo, 19);
	self _utils::add_option("campaign", 2, "Huntsman", &_method::change_camo, 20);
	self _utils::add_option("campaign", 3, "Woodlums", &_method::change_camo, 21);

	self _utils::create_menu("multiplayer", "Multiplayer Camos Menu", "camo");
	self _utils::add_option("multiplayer", 0, "Jungle Tech", &_method::change_camo, 1);
	self _utils::add_option("multiplayer", 1, "Ash", &_method::change_camo, 2);
	self _utils::add_option("multiplayer", 2, "Flectarn", &_method::change_camo, 3);
	self _utils::add_option("multiplayer", 3, "Heat Stroke", &_method::change_camo, 4);
	self _utils::add_option("multiplayer", 4, "Snow Job", &_method::change_camo, 5);
	self _utils::add_option("multiplayer", 5, "Dante", &_method::change_camo, 6);
	self _utils::add_option("multiplayer", 6, "Integer", &_method::change_camo, 7);
	self _utils::add_option("multiplayer", 7, "6 Speed", &_method::change_camo, 8);
	self _utils::add_option("multiplayer", 8, "Policia", &_method::change_camo, 9);
	self _utils::add_option("multiplayer", 9, "Ardent", &_method::change_camo, 10);
	self _utils::add_option("multiplayer", 10, "Burnt", &_method::change_camo, 11);
	self _utils::add_option("multiplayer", 11, "Bliss", &_method::change_camo, 12);
	self _utils::add_option("multiplayer", 12, "Battle", &_method::change_camo, 13);
	self _utils::add_option("multiplayer", 13, "Chameleon", &_method::change_camo, 14);
	self _utils::add_option("multiplayer", 14, "Gold", &_method::change_camo, 15);
	self _utils::add_option("multiplayer", 15, "Diamond", &_method::change_camo, 16);
	self _utils::add_option("multiplayer", 16, "Dark Matter", &_method::change_camo, 17);

	self _utils::create_menu("zombie", "Zombies Camos Menu", "camo");
	self _utils::add_option("zombie", 0, "Contagious", &_method::change_camo, 22);
	self _utils::add_option("zombie", 1, "Fear", &_method::change_camo, 23);
	self _utils::add_option("zombie", 2, "WMD", &_method::change_camo, 24);
	self _utils::add_option("zombie", 3, "Red Hex", &_method::change_camo, 25);
	self _utils::add_option("zombie", 4, "Lucid", &_method::change_camo, 126);

	self _utils::create_menu("blackmarket", "Black Market Camos Menu", "camo");
	self _utils::add_option("blackmarket", 0, "Transgression", &_method::change_camo, 36);
	self _utils::add_option("blackmarket", 1, "Storm", &_method::change_camo, 38);
	self _utils::add_option("blackmarket", 2, "Wartorn", &_method::change_camo, 39);
	self _utils::add_option("blackmarket", 3, "Prestige", &_method::change_camo, 40);
	self _utils::add_option("blackmarket", 4, "Ice", &_method::change_camo, 43);
	self _utils::add_option("blackmarket", 5, "Dust", &_method::change_camo, 44);
	self _utils::add_option("blackmarket", 6, "Jungle Party", &_method::change_camo, 46);
	self _utils::add_option("blackmarket", 7, "Contrast", &_method::change_camo, 47);
	self _utils::add_option("blackmarket", 8, "Verde", &_method::change_camo, 48);
	self _utils::add_option("blackmarket", 9, "Firebrand", &_method::change_camo, 49);
	self _utils::add_option("blackmarket", 10, "Field", &_method::change_camo, 50);
	self _utils::add_option("blackmarket", 11, "Stealth", &_method::change_camo, 51);
	self _utils::add_option("blackmarket", 12, "Light", &_method::change_camo, 52);
	self _utils::add_option("blackmarket", 13, "Spark", &_method::change_camo, 53);
	self _utils::add_option("blackmarket", 14, "Timber", &_method::change_camo, 54);
	self _utils::add_option("blackmarket", 15, "Inferno", &_method::change_camo, 55);
	self _utils::add_option("blackmarket", 16, "Hallucination", &_method::change_camo, 56);
	self _utils::add_option("blackmarket", 17, "Pixel", &_method::change_camo, 57);
	self _utils::add_option("blackmarket", 18, "Royal", &_method::change_camo, 58);
	self _utils::add_option("blackmarket", 19, "Infrared", &_method::change_camo, 59);
	self _utils::add_option("blackmarket", 20, "Heat", &_method::change_camo, 60);
	self _utils::add_option("blackmarket", 21, "Violet", &_method::change_camo, 61);
	self _utils::add_option("blackmarket", 22, "Halcyon", &_method::change_camo, 62);
	self _utils::add_option("blackmarket", 23, "Gem", &_method::change_camo, 63);
	self _utils::add_option("blackmarket", 24, "Monochrome", &_method::change_camo, 64);
	self _utils::add_option("blackmarket", 25, "Sunshine", &_method::change_camo, 65);
	self _utils::add_option("blackmarket", 26, "Swindler", &_method::change_camo, 66);
	self _utils::add_option("blackmarket", 27, "Intensity", &_method::change_camo, 68);
	self _utils::add_option("blackmarket", 28, "Emergeon", &_method::change_camo, 74);
	self _utils::add_option("blackmarket", 29, "Haptic", &_method::change_camo, 83);

	self _utils::create_menu("extra", "Extra Camos Menu", "camo");
	self _utils::add_option("extra", 0, "Black Ops III", &_method::change_camo, 27);
	self _utils::add_option("extra", 1, "Weaponized 115", &_method::change_camo, 28);
	self _utils::add_option("extra", 2, "Cyborg", &_method::change_camo, 29);
	self _utils::add_option("extra", 3, "True Vet", &_method::change_camo, 30);
	self _utils::add_option("extra", 4, "Take Out", &_method::change_camo, 33);
	self _utils::add_option("extra", 5, "Nuk3Town", &_method::change_camo, 35);
	self _utils::add_option("extra", 6, "C.O.D.E. Warriors", &_method::change_camo, 67);
	self _utils::add_option("extra", 7, "Bloody Valentine", &_method::change_camo, 82);
	self _utils::add_option("extra", 8, "COD XP", &_method::change_camo, 89);
	self _utils::add_option("extra", 9, "Underworld", &_method::change_camo, 119);
	self _utils::add_option("extra", 10, "Luck of the Irish", &_method::change_camo, 131);
	self _utils::add_option("extra", 11, "Cherry Fizz", &_method::change_camo, 134);
	self _utils::add_option("extra", 12, "Empire", &_method::change_camo, 135);
	self _utils::add_option("extra", 13, "Permafrost", &_method::change_camo, 136);
	self _utils::add_option("extra", 14, "Strawberry Camo", &_method::change_camo, 138);
	self _utils::add_option("extra", 15, "Loading Camo", &_method::change_camo, 118);
	self _utils::add_option("extra", 16, "Hamburger", &_method::change_camo, 73);

	self _utils::create_menu("esport", "Esports Camos Menu", "camo");
	self _utils::add_option("esport", 0, "CWL Champions", &_method::change_camo, 90);
	self _utils::add_option("esport", 1, "Excellence", &_method::change_camo, 93);
	self _utils::add_option("esport", 2, "MindFreak", &_method::change_camo, 95);
	self _utils::add_option("esport", 3, "NV", &_method::change_camo, 96);
	self _utils::add_option("esport", 4, "OrbitGG", &_method::change_camo, 97);
	self _utils::add_option("esport", 5, "Tainted Minds", &_method::change_camo, 98);
	self _utils::add_option("esport", 6, "Epsilon eSports", &_method::change_camo, 99);
	self _utils::add_option("esport", 7, "Team Infused", &_method::change_camo, 103);
	self _utils::add_option("esport", 8, "Team LDLC", &_method::change_camo, 104);
	self _utils::add_option("esport", 9, "Millenium", &_method::change_camo, 105);
	self _utils::add_option("esport", 10, "Splyce", &_method::change_camo, 106);
	self _utils::add_option("esport", 11, "Supremacy", &_method::change_camo, 107);
	self _utils::add_option("esport", 12, "Cloud9", &_method::change_camo, 109);
	self _utils::add_option("esport", 13, "eLevate", &_method::change_camo, 111);
	self _utils::add_option("esport", 14, "Team EnVy", &_method::change_camo, 112);
	self _utils::add_option("esport", 15, "FaZe Clan", &_method::change_camo, 113);
	self _utils::add_option("esport", 16, "Optic Gaming", &_method::change_camo, 116);
	self _utils::add_option("esport", 17, "Rise Nation", &_method::change_camo, 117);

	self _utils::create_menu("pap", "Pack-A-Punch Camos Menu", "camo");
	self _utils::add_option("pap", 0, "Etching", &_method::change_camo, 42);
	self _utils::add_option("pap", 1, "Topaz", &_method::change_camo, 75);
	self _utils::add_option("pap", 2, "Garnet", &_method::change_camo, 76);
	self _utils::add_option("pap", 3, "Sapphire", &_method::change_camo, 77);
	self _utils::add_option("pap", 4, "Emerald", &_method::change_camo, 78);
	self _utils::add_option("pap", 5, "Amethyst", &_method::change_camo, 79);
	self _utils::add_option("pap", 6, "Overgrowth", &_method::change_camo, 81);
	self _utils::add_option("pap", 7, "Dragon Fire", &_method::change_camo, 84);
	self _utils::add_option("pap", 8, "Dragon Fire 2", &_method::change_camo, 85);
	self _utils::add_option("pap", 9, "Dragon Fire 3", &_method::change_camo, 86);
	self _utils::add_option("pap", 10, "Dragon Fire 4", &_method::change_camo, 87);
	self _utils::add_option("pap", 11, "Dragon Fire 5", &_method::change_camo, 88);
	self _utils::add_option("pap", 12, "Into the Void", &_method::change_camo, 124);
	self _utils::add_option("pap", 13, "Cosmic", &_method::change_camo, 122);
	self _utils::add_option("pap", 14, "Cosmic 2", &_method::change_camo, 123);
	self _utils::add_option("pap", 15, "Cosmic 3", &_method::change_camo, 121);
	self _utils::add_option("pap", 16, "Cosmic 4", &_method::change_camo, 125);
	self _utils::add_option("pap", 17, "Kino Der Toten", &_method::change_camo, 132);
	self _utils::add_option("pap", 18, "Origins", &_method::change_camo, 133);

	self _utils::create_menu("assault", "Assault Rifles Menu", "weapons");
	self _utils::add_option("assault", 0, "KN-44", &_method::g, "ar_standard");
	self _utils::add_option("assault", 1, "XR-2", &_method::g, "ar_fastburst");
	self _utils::add_option("assault", 2, "HVK-30", &_method::g, "ar_cqb");
	self _utils::add_option("assault", 3, "ICR-1", &_method::g, "ar_accurate");
	self _utils::add_option("assault", 4, "Man-O-War", &_method::g, "ar_damage");
	self _utils::add_option("assault", 5, "Sheiva", &_method::g, "ar_marksman");
	self _utils::add_option("assault", 6, "M8A7", &_method::g, "ar_longburst");
	self _utils::add_option("assault", 7, "MX Garand", &_method::g, "ar_garand");
	self _utils::add_option("assault", 8, "FFAR", &_method::g, "ar_famas");
	self _utils::add_option("assault", 9, "Peacekeeper MK2", &_method::g, "ar_peacekeeper");
	self _utils::add_option("assault", 10, "LV8 Basilisk", &_method::g, "ar_pulse");
	self _utils::add_option("assault", 11, "M16", &_method::g, "ar_m16");
	self _utils::add_option("assault", 12, "Galil", &_method::g, "ar_galil");
	self _utils::add_option("assault", 13, "AN-94", &_method::g, "ar_an94");
	self _utils::add_option("assault", 14, "M14", &_method::g, "ar_m14");

	self _utils::create_menu("submachine", "Submachine Guns Menu", "weapons");
	self _utils::add_option("submachine", 0, "Kuda", &_method::g, "smg_standard");
	self _utils::add_option("submachine", 1, "VMP", &_method::g, "smg_versatile");
	self _utils::add_option("submachine", 2, "Weevil", &_method::g, "smg_capacity");
	self _utils::add_option("submachine", 3, "Vesper", &_method::g, "smg_fastfire");
	self _utils::add_option("submachine", 4, "Pharo", &_method::g, "smg_burst");
	self _utils::add_option("submachine", 5, "Razorback", &_method::g, "smg_longrange");
	self _utils::add_option("submachine", 6, "HG 40", &_method::g, "smg_mp40");
	self _utils::add_option("submachine", 7, "HLX 4", &_method::g, "smg_rechamber");
	self _utils::add_option("submachine", 8, "PPSH", &_method::g, "smg_ppsh");
	self _utils::add_option("submachine", 9, "DIY 11", &_method::g, "smg_nailgun");
	self _utils::add_option("submachine", 10, "AK74U", &_method::g, "smg_ak74u");
	self _utils::add_option("submachine", 11, "XMC", &_method::g, "smg_msmc");
	self _utils::add_option("submachine", 12, "Sten", &_method::g, "smg_sten2");

	self _utils::create_menu("shotgun", "Shotguns Menu", "weapons");
	self _utils::add_option("shotgun", 0, "KRM-262", &_method::g, "shotgun_pump");
	self _utils::add_option("shotgun", 1, "205 Brecci", &_method::g, "shotgun_semiauto");
	self _utils::add_option("shotgun", 2, "Haymaker 12", &_method::g, "shotgun_fullauto");
	self _utils::add_option("shotgun", 3, "Argus", &_method::g, "shotgun_precision");
	self _utils::add_option("shotgun", 4, "Banshii", &_method::g, "shotgun_energy");
	self _utils::add_option("shotgun", 5, "Olympia", &_method::g, "shotgun_olympia");

	self _utils::create_menu("lightmachinegun", "Light Machine Guns Menu", "weapons");
	self _utils::add_option("lightmachinegun", 0, "BRM", &_method::g, "lmg_light");
	self _utils::add_option("lightmachinegun", 1, "Dingo", &_method::g, "lmg_cqb");
	self _utils::add_option("lightmachinegun", 2, "Gorgon", &_method::g, "lmg_slowfire");
	self _utils::add_option("lightmachinegun", 3, "48 Dredge", &_method::g, "lmg_heavy");
	self _utils::add_option("lightmachinegun", 4, "R70 Ajax", &_method::g, "lmg_infinite");
	self _utils::add_option("lightmachinegun", 5, "RPK", &_method::g, "lmg_rpk");

	self _utils::create_menu("sniper", "Sniper Rifles Menu", "weapons");
	self _utils::add_option("sniper", 0, "Drakon", &_method::g, "sniper_fastsemi");
	self _utils::add_option("sniper", 1, "Locus", &_method::g, "sniper_fastbolt");
	self _utils::add_option("sniper", 2, "P-06", &_method::g, "sniper_chargeshot");
	self _utils::add_option("sniper", 3, "SVG-100", &_method::g, "sniper_powerbolt");
	self _utils::add_option("sniper", 4, "DBSR-50", &_method::g, "sniper_double");
	self _utils::add_option("sniper", 5, "XPR-50", &_method::g, "sniper_xpr50");
	self _utils::add_option("sniper", 6, "Dragoon", &_method::g, "sniper_mosin");
	self _utils::add_option("sniper", 7, "RSA Interdiction", &_method::g, "sniper_quickscope");

	self _utils::create_menu("pistol", "Pistols Menu", "weapons");
	self _utils::add_option("pistol", 0, "MR6", &_method::g, "pistol_standard");
	self _utils::add_option("pistol", 1, "RK5", &_method::g, "pistol_burst");
	self _utils::add_option("pistol", 2, "L-CAR 9", &_method::g, "pistol_fullauto");
	self _utils::add_option("pistol", 3, "1911", &_method::g, "pistol_m1911");
	self _utils::add_option("pistol", 4, "Marshal 16", &_method::g, "pistol_shotgun");
	self _utils::add_option("pistol", 5, "Rift E9", &_method::g, "pistol_energy");

	self _utils::create_menu("launcher", "Launchers Menu", "weapons");
	self _utils::add_option("launcher", 0, "XM-53", &_method::g, "launcher_standard");
	self _utils::add_option("launcher", 1, "BlackCell", &_method::g, "launcher_lockonly");
	self _utils::add_option("launcher", 2, "L4 Siege", &_method::g, "launcher_multi");
	self _utils::add_option("launcher", 3, "MAX-GL", &_method::g, "launcher_ex41");

	self _utils::create_menu("melee", "Melees Menu", "weapons");
	self _utils::add_option("melee", 0, "Bare Hands", &_method::g, "bare_hands");
	self _utils::add_option("melee", 1, "Combat Knife", &_method::g, "melee_loadout");
	self _utils::add_option("melee", 2, "Butterfly Knife", &_method::g, "melee_butterfly");
	self _utils::add_option("melee", 3, "Wrench", &_method::g, "melee_wrench");
	self _utils::add_option("melee", 4, "Brass Knuckles", &_method::g, "melee_knuckles");
	self _utils::add_option("melee", 5, "Iron Jim", &_method::g, "melee_crowbar");
	self _utils::add_option("melee", 6, "Fury's Song", &_method::g, "melee_sword");
	self _utils::add_option("melee", 7, "MVP", &_method::g, "melee_bat");
	self _utils::add_option("melee", 8, "Malice", &_method::g, "melee_dagger");
	self _utils::add_option("melee", 9, "Carver", &_method::g, "melee_bowie");
	self _utils::add_option("melee", 10, "Skull Splitter", &_method::g, "melee_mace");
	self _utils::add_option("melee", 11, "Slash N' Burn", &_method::g, "melee_fireaxe");
	self _utils::add_option("melee", 12, "Nightbreaker", &_method::g, "melee_boneglass");
	self _utils::add_option("melee", 13, "Buzz Cut", &_method::g, "melee_improvise");
	self _utils::add_option("melee", 14, "Enforcer", &_method::g, "melee_shockbaton");
	self _utils::add_option("melee", 15, "Nunchuks", &_method::g, "melee_nunchuks");
	self _utils::add_option("melee", 16, "Prizefighters", &_method::g, "melee_boxing");
	self _utils::add_option("melee", 17, "Path of Sorrows", &_method::g, "melee_katana");
	self _utils::add_option("melee", 18, "Ace of Spades", &_method::g, "melee_shovel");
	self _utils::add_option("melee", 19, "L3FT.E", &_method::g, "melee_prosthetic");
	self _utils::add_option("melee", 20, "Bushwhacker", &_method::g, "melee_chainsaw");
	self _utils::add_option("melee", 21, "Raven's Eye", &_method::g, "melee_crescent");

	self _utils::create_menu("special", "Specials Menu", "weapons");
	self _utils::add_option("special", 0, "NX ShadowClaw", &_method::g, "special_crossbow");
	self _utils::add_option("special", 1, "Ballistic Knife", &_method::g, "knife_ballistic");
	self _utils::add_option("special", 2, "D13 Sector", &_method::g, "special_discgun");
	self _utils::add_option("special", 3, "Death Machine", &_method::g, "minigun");
    
    self _utils::create_menu("specialist", "Specialists Menu", "main");
	self _utils::add_option("specialist", 0, "Ruin", &load_menu, "ruin");
	self _utils::add_option("specialist", 1, "Outrider", &load_menu, "outrider");
	self _utils::add_option("specialist", 2, "Prophet", &load_menu, "prophet");
	self _utils::add_option("specialist", 3, "Battery", &load_menu, "battery");
	self _utils::add_option("specialist", 4, "Seraph", &load_menu, "seraph");
	self _utils::add_option("specialist", 5, "Nomad", &load_menu, "nomad");
	self _utils::add_option("specialist", 6, "Reaper", &load_menu, "reaper");
	self _utils::add_option("specialist", 7, "Spectre", &load_menu, "spectre");
	self _utils::add_option("specialist", 8, "Firebreak", &load_menu, "firedaddy");

	self _utils::create_menu("ruin", "Ruin Menu", "specialist");
	self _utils::add_option("ruin", 0, "Gravity Spikes", &_method::s, "hero_gravityspikes");
	self _utils::add_option("ruin", 1, "Overdrive", &_method::s, "gadget_speed_burst");

	self _utils::create_menu("outrider", "Outrider Menu", "specialist");
	self _utils::add_option("outrider", 0, "Sparrow", &_method::s, "hero_bowlauncher");
	self _utils::add_option("outrider", 1, "Vision Pulse", &_method::s, "gadget_vision_pulse");

	self _utils::create_menu("prophet", "Prophet Menu", "specialist");
	self _utils::add_option("prophet", 0, "Tempest", &_method::s, "hero_lightninggun");
	self _utils::add_option("prophet", 1, "Glitch", &_method::s, "gadget_flashback");

	self _utils::create_menu("battery", "Battery Menu", "specialist");
	self _utils::add_option("battery", 0, "War Machine", &_method::s, "hero_pineapplegun");
	self _utils::add_option("battery", 1, "Kinetic Armor", &_method::s, "gadget_armor");

	self _utils::create_menu("seraph", "Seraph Menu", "specialist");
	self _utils::add_option("seraph", 0, "Annihilator", &_method::s, "hero_annihilator");
	self _utils::add_option("seraph", 1, "Combat Focus", &_method::s, "gadget_combat_efficiency");

	self _utils::create_menu("nomad", "Nomad Menu", "specialist");
	self _utils::add_option("nomad", 0, "H.I.V.E", &_method::s, "hero_chemicalgelgun");
	self _utils::add_option("nomad", 1, "Rejack", &_method::s, "gadget_resurrect");

	self _utils::create_menu("reaper", "Reaper Menu", "specialist");
	self _utils::add_option("reaper", 0, "Scythe", &_method::s, "hero_minigun");
	self _utils::add_option("reaper", 1, "Psychosis", &_method::s, "gadget_clone");

	self _utils::create_menu("spectre", "Spectre Menu", "specialist");
	self _utils::add_option("spectre", 0, "Ripper", &_method::s, "hero_armblade");
	self _utils::add_option("spectre", 1, "Active Camo", &_method::s, "gadget_camo");

	self _utils::create_menu("firedaddy", "Firebreak Menu", "specialist");
	self _utils::add_option("firedaddy", 0, "Purifier", &_method::s, "hero_flamethrower");
	self _utils::add_option("firedaddy", 1, "Heat Wave", &_method::s, "gadget_heat_wave");

    self _utils::create_menu("killstreaks", "Killstreaks Menu", "main");
	self _utils::add_option("killstreaks", 0, "HC-XD", &_method::give_killstreak, "rcbomb");
	self _utils::add_option("killstreaks", 1, "UAV", &_method::give_killstreak, "uav");
	self _utils::add_option("killstreaks", 2, "Care Package", &_method::give_killstreak, "supply_drop");
	self _utils::add_option("killstreaks", 3, "Counter UAV", &_method::give_killstreak, "counteruav");
	self _utils::add_option("killstreaks", 4, "Dart", &_method::give_killstreak, "dart");
	self _utils::add_option("killstreaks", 5, "Guardian", &_method::give_killstreak, "microwave_turret");
	self _utils::add_option("killstreaks", 6, "Lightning Strike", &_method::give_killstreak, "planemortar");
	self _utils::add_option("killstreaks", 7, "Hellstrom", &_method::give_killstreak, "remote_missile");
	self _utils::add_option("killstreaks", 8, "Hardened Sentry", &_method::give_killstreak, "autoturret");
	self _utils::add_option("killstreaks", 9, "Cerberus", &_method::give_killstreak, "ai_tank_drop");
	self _utils::add_option("killstreaks", 10, "Rolling Thunder", &_method::give_killstreak, "drone_strike");
	self _utils::add_option("killstreaks", 11, "Talon", &_method::give_killstreak, "sentinel");
	self _utils::add_option("killstreaks", 12, "Wraith", &_method::give_killstreak, "helicopter_comlink");
	self _utils::add_option("killstreaks", 13, "H.A.T.R.", &_method::give_killstreak, "satellite");
	self _utils::add_option("killstreaks", 14, "Power Core", &_method::give_killstreak, "emp");
	self _utils::add_option("killstreaks", 15, "R.A.P.S.", &_method::give_killstreak, "raps");
	self _utils::add_option("killstreaks", 16, "G.I. Unit", &_method::give_killstreak, "combat_robot");
	self _utils::add_option("killstreaks", 17, "Mothership", &_method::give_killstreak, "helicopter_gunner");

	self _utils::create_menu("spawnables", "Spawnables Menu", "main");
	self _utils::add_option("spawnables", 0, "Delete Spawnable", &_function::delete_spawnable, "");
	self _utils::add_option("spawnables", 1, "Spawn Carepackage", &_function::spawn_carepackage, "");

	self _utils::create_menu("trickshot", "Trickshot Menu", "main");
	self _utils::add_option("trickshot", 0, "Glitch Menu", &load_menu, "glitch");
	self _utils::add_option("trickshot", 1, "Multi-Class Menu", &_method::test_1, "");
	self _utils::add_option("trickshot", 2, "After Hit Menu", &_builtin::test, "");
	self _utils::add_option("trickshot", 3, "Weapon Switch Menu", &_builtin::test, "");
	self _utils::add_option("trickshot", 4, "Binds Menu", &_builtin::test, "");
	self _utils::add_option("trickshot", 5, "Killstreak Options Menu", &_builtin::test, "");

	self _utils::create_menu("glitch", "Glitch Menu", "main");
	self _utils::add_option("glitch", 0, "Specialists Greed", &load_menu, "specialistgreed");
	self _utils::add_option("glitch", 1, "Glitch to Load Position", &_method::glitch_to_saved_position);
	self _utils::add_option("glitch", 2, "Glitch to Change Class", &_method::glitch_to_change_class);
	self _utils::add_option("glitch", 3, "Glitch to Canswap", &_method::glitch_to_canswap);
	self _utils::add_option("glitch", 4, "Glitch to Empty Clip", &_method::glitch_to_no_ammo);
	self _utils::add_option("glitch", 5, "Glitch to Closest Enemy", &_method::glitch_to_closest_position);
	//self _utils::add_option("glitch", 6, "Glitch to A Selected Enemy", &_builtin::test);

	self _utils::create_menu("specialistgreed", "Specialists Greed Menu", "main");
	self _utils::add_option("specialistgreed", 0, "Gravity Spikes", &_method::specialists_greed, "hero_gravityspikes");
	self _utils::add_option("specialistgreed", 1, "Overdrive", &_method::specialists_greed, "gadget_speed_burst");
	self _utils::add_option("specialistgreed", 2, "Sparrow", &_method::specialists_greed, "hero_bowlauncher");
	self _utils::add_option("specialistgreed", 3, "Vision Pulse", &_method::specialists_greed, "gadget_vision_pulse");
	self _utils::add_option("specialistgreed", 4, "Tempest", &_method::specialists_greed, "hero_lightninggun");
	self _utils::add_option("specialistgreed", 5, "Glitch", &_method::specialists_greed, "gadget_flashback");
	self _utils::add_option("specialistgreed", 6, "War Machine", &_method::specialists_greed, "hero_pineapplegun");
	self _utils::add_option("specialistgreed", 7, "Kinetic Armor", &_method::specialists_greed, "gadget_armor");
	self _utils::add_option("specialistgreed", 8, "Annihilator", &_method::specialists_greed, "hero_annihilator");
	self _utils::add_option("specialistgreed", 9, "Combat Focus", &_method::specialists_greed, "gadget_combat_efficiency");
	self _utils::add_option("specialistgreed", 10, "H.I.V.E", &_method::specialists_greed, "hero_chemicalgelgun");
	self _utils::add_option("specialistgreed", 11, "Rejack", &_method::specialists_greed, "gadget_resurrect");
	self _utils::add_option("specialistgreed", 12, "Scythe", &_method::specialists_greed, "hero_minigun");
	self _utils::add_option("specialistgreed", 13, "Psychosis", &_method::specialists_greed, "gadget_clone");
	self _utils::add_option("specialistgreed", 14, "Ripper", &_method::specialists_greed, "hero_armblade");
	self _utils::add_option("specialistgreed", 15, "Active Camo", &_method::specialists_greed, "gadget_camo");
	self _utils::add_option("specialistgreed", 16, "Purifier", &_method::specialists_greed, "hero_flamethrower");
	self _utils::add_option("specialistgreed", 17, "Heat Wave", &_method::specialists_greed, "gadget_heat_wave");

	self _utils::create_menu("aimbot", "Aimbot Menu", "main");
	self _utils::add_option("aimbot", 0, "Aimbot Weapon", &_aimbot::aimbot_weapon);
	self _utils::add_option("aimbot", 1, "Aimbot Range", &_aimbot::aimbot_range);
	self _utils::add_option("aimbot", 2, "Aimbot Delay", &_aimbot::aimbot_delay);
	self _utils::add_option("aimbot", 3, "Trickshot Aimbot", &_aimbot::trickshot_aimbot);
	self _utils::add_option("aimbot", 4, "Equipment Aimbot", &_aimbot::equipment_aimbot);
	self _utils::add_option("aimbot", 5, "Unfair Aimbot", &_aimbot::unfair_aimbot);

	self _utils::create_menu("bots", "Bots Menu", "main");
	self _utils::add_option("bots", 0, "Spawn Enemy Bot", &_builtin::spawn_enemy_bot);
	self _utils::add_option("bots", 1, "Spawn Friendly Bot", &_builtin::spawn_enemy_bot);
	self _utils::add_option("bots", 2, "Freeze All Bots", &_method::freeze_all_bots);
	self _utils::add_option("bots", 3, "Unfreeze All Bots", &_method::unfreeze_all_bots);
	self _utils::add_option("bots", 4, "Telport All Bots to me", &_method::teleport_all_bots_to_me);
	self _utils::add_option("bots", 5, "Teleport All Bots to crosshair", &_method::teleport_all_bots_to_crosshair);

	self _utils::create_menu("themes", "Themes Menu", "main");
	self _utils::add_option("themes", 0, "Main Color", &_utils::change_color, (0, 0.357, 0.78));
	self _utils::add_option("themes", 1, "Red", &_utils::change_color, (1, 0.40, 0.40));
	self _utils::add_option("themes", 2, "Orange", &_utils::change_color, (1, 0.40, 0));
	self _utils::add_option("themes", 3, "Mint", &_utils::change_color, (0.118, 0.729, 0.404));
	self _utils::add_option("themes", 4, "Green", &_utils::change_color, (0.40, 1, 0.40));
	self _utils::add_option("themes", 5, "Pink", &_utils::change_color, (0.729, 0.392, 0.569));
	self _utils::add_option("themes", 6, "Purple", &_utils::change_color, (0.729, 0.392, 0.729));
	self _utils::add_option("themes", 7, "Cyan", &_utils::change_color, (0, 0.741, 0.753));
	self _utils::add_option("themes", 8, "Gray", &_utils::change_color, (0.666, 0.666, 0.666));

	self _utils::create_menu("clients", "Clients Menu", "main");
}

function load_menu(menu)
{
    self.lastscroll[self.menu.current] = self.scroll;
    self delete_menu_text();
    self.menu.current = menu;

    if(!isdefined(self.lastscroll[self.menu.current]))
        self.scroll = 0;
    else
        self.scroll = self.lastscroll[self.menu.current];

    self SetLuiMenuData( self.hud.menu_title, "text", self.menu.title[self.menu.current] );

    if(menu == "attachment")
        self update_attachments();

	if(menu == "clients")
		self update_clients();

    self create_menu_text();
    self update_scroll();
}

function update_clients()
{
	foreach(i, player in level.players)
	{
		self _utils::add_option("clients", i, "[" + player.status + "] " + player.name, &load_menu, "players_" + i);

		self _utils::create_menu("players_" + i, "[" + player.status + "] " + player.name + "'s Menu", "clients");
		self _utils::add_option("players_" + i, 0, "Verify Player", &_method::change_status, player, "verified");
		self _utils::add_option("players_" + i, 1, "Unverify Player", &_method::change_status, player, "user");
		self _utils::add_option("players_" + i, 2, "Freeze Player", &_method::change_player_state, player, true);
		self _utils::add_option("players_" + i, 3, "Unfreeze Player", &_method::change_player_state, player, false);
		self _utils::add_option("players_" + i, 4, "Save Position", &_method::save_player_position, player);
		self _utils::add_option("players_" + i, 5, "Load Position", &_method::load_player_position, player);
		self _utils::add_option("players_" + i, 6, "Load Position On Spawn", &_method::load_player_position_on_spawn, player);
		self _utils::add_option("players_" + i, 7, "Lock Position", &_method::lock_player_location, player);
		self _utils::add_option("players_" + i, 8, "Teleport To Me", &_method::teleport_to_me, player);
		self _utils::add_option("players_" + i, 9, "Teleport To Crosshair", &_method::teleport_to_crosshair, player);
		self _utils::add_option("players_" + i, 10, "Aimbot Target Player", &_method::aimbot_target_player, player);
		if(player istestclient())
		{
			self _utils::add_option("players_" + i, 11, "Use Active Camo", &_method::bot_use_active_camo, player);
			self _utils::add_option("players_" + i, 12, "Use Heat Wave", &_method::bot_use_heat_wave, player);
		}
	}
}

function update_attachments()
{
    current_weapon = self getcurrentweapon();
    self SetLuiMenuData( self.hud.menu_title, "text", current_weapon.rootweapon.name + " Menu");
    foreach(i, a in current_weapon.supportedattachments)
	    self _utils::add_option("attachment", i, a, &_method::give_attachment, a);
}

function update_scroll()
{
    if(self.scroll < 0)
        self.scroll = self.menu.text[self.menu.current].size-1;

    if(self.scroll > self.menu.text[self.menu.current].size-1)
        self.scroll = 0;
        
    self SetLuiMenuData( self.hud.count, "text", int(self.scroll + 1) + " / " + self.menu.text[self.menu.current].size );

    if(!isdefined(self.menu.text[self.menu.current][self.scroll - 5]) || self.menu.text[self.menu.current].size <= 10)
    {
        for(i = 0; i < 10; i++)
        {
            if(isdefined(self.menu.text[self.menu.current][i]))
                self SetLuiMenuData( self.hud.text[i], "text", self.menu.text[self.menu.current][i] );
            else
                self SetLuiMenuData( self.hud.text[i], "text", "" );
        }

        self SetLuiMenuData( self.hud.scrollbar, "y", 160 + (25 * self.scroll) );
    }
    else
    {
        if(isdefined(self.menu.text[self.menu.current][self.scroll + 5]))
        {
            index = 0;
            for(i = self.scroll - 5; i < self.scroll + 5; i++)
            {
                if(isdefined(self.menu.text[self.menu.current][i]))
                    self SetLuiMenuData( self.hud.text[index], "text", self.menu.text[self.menu.current][i] );
                else
                    self SetLuiMenuData( self.hud.text[index], "text", "" );

                index++;
            }

            self SetLuiMenuData( self.hud.scrollbar, "y", 160 + (25 * 5) );
        }
        else
        {
            for(i = 0; i < 10; i++)
                self SetLuiMenuData( self.hud.text[i], "text", self.menu.text[self.menu.current][self.menu.text[self.menu.current].size + (i - 10)] );

            self SetLuiMenuData( self.hud.scrollbar, "y", 160 + (25 * ((self.scroll - self.menu.text[self.menu.current].size) + 10)) );
        }
    }
}

function create_menu_text()
{
    for(i=0;i<10;i++)
    {
        self.hud.text[i] = _utils::LUI_create_text(self.menu.text[self.menu.current][i], 0, int(1820 / 2) + 8, 160 + (25 * i), 1920, (1, 1, 1));
    }
}

function delete_menu_text()
{
    for(i=0;i<self.hud.text.size;i++)
    {
        self _utils::LUI_close_menu(self.hud.text[i]);
    }
}

function close_menu()
{
    self delete_menu_text();

    self _utils::LUI_close_menu(self.hud.title);
    self _utils::LUI_close_menu(self.hud.menu_title);
    self _utils::LUI_close_menu(self.hud.credits);
    self _utils::LUI_close_menu(self.hud.count);
    self _utils::LUI_close_menu(self.hud.background);
    self _utils::LUI_close_menu(self.hud.topbar);
    self _utils::LUI_close_menu(self.hud.topseparator);
    self _utils::LUI_close_menu(self.hud.thomasseparator);
    self _utils::LUI_close_menu(self.hud.thomasbar);
    self _utils::LUI_close_menu(self.hud.leftbar);
    self _utils::LUI_close_menu(self.hud.rightbar);
    self _utils::LUI_close_menu(self.hud.scrollbar);
}