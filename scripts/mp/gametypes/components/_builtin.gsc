
#using scripts\shared\bots\_bot;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\components\_function;

#namespace _builtin;

function test()
{
    weapon = self getcurrentweapon();
    self iprintln("^5" + weapon.name);
}

function waitserverframe()
{
    wait 0.05;
}

function vector_scale(vector, scale)
{
    vec = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
    return vec;
}

function spawn_enemy_bot()
{
    bot = undefined;
	if(bot::get_host_team() == "axis")
	{
		bot = bot::add_bot("allies");
		iprintln("Bot spawned to: ^1Allies");
	}
	else if(bot::get_host_team() == "allies")
	{
		bot = bot::add_bot("axis");
		iprintln("Bot spawned to: ^1Axis");
	}
	return isdefined(bot);
}

function spawn_friendly_bot()
{
	bot = undefined;
	if(bot::get_host_team() == "axis")
	{
		bot = bot::add_bot("axis");
		iprintln("Bot spawned to: ^1Axis");
	}
	else if(bot::get_host_team() == "allies")
	{
		bot = bot::add_bot("allies");
		iprintln("Bot spawned to: ^1Allies");
	}
	return isdefined(bot);
}