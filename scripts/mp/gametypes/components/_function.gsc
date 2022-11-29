#using scripts\shared\util_shared;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\gametypes\components\_utils;
#using scripts\mp\gametypes\components\_builtin;

#namespace _function;

function spawn_ent(origin, model)
{
	ent = spawn("script_model", origin);
	ent SetModel(model);
	return ent;
}

function delete_spawnable()
{
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    trace_t = bullettrace(start, end, true, self);
    trace_t["entity"] delete();
}

function spawn_carepackage()
{
    size = level.spawned_carepackage;
    self.carepackage[size] = spawn_ent(self.origin - (0, 0, 30), "wpn_t7_care_package_world");
    level.spawned_carepackage++;
}

function func_teleportWithSelector(player)
{
    self beginLocationComlinkSelection( "compass_objpoint_helicopter", 1500 );
    self.selectingLocation = true;

    self thread airsupport::endSelectionThink();

    location = self func_waittill_confirm_location();

    if ( !isdefined( location ) )
    {
        return false;
    }

    chopper = spawnhelicopter(self, location, self getplayerangles(), "vtol_supplydrop_mp", "");
    self endLocationSelection();
    self.selectingLocation = undefined;
}
function func_waittill_confirm_location()
{
    self endon( "emp_jammed" );
    self endon( "emp_grenaded" );

    self waittill( "confirm_location", location );
    
    return location;
}