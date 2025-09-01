# How to use this addon

## ADDON SETUP

1. Add the chain3 folder to your addons folder in Godot.

2. Enable the plugin by going to Project Settings > Globals and clicking the checkbox
next to chain3.

3. Restart the Godot editor so the plugin's autoload script will execute.

4. Create a folder named StreamingAssets in your exported project. That means your
folder stucture will probably look something like this:

- game.exe
- game.pck
- StreamingAssets/

5. Set the sceneselector.tscn scene as the default scene for your Godot project:
Project > Project Settings > Run > Main Scene > Choose sceneselector.tscn with the file picker

## DOORS

See CHAIN_SceneSelector.gd for how to set up the Door files that will determine
which scene loads based on which entrance on the CHAIN map that the player entered
your game through.

## FLAGS

See chain3.gd for how to share data as text strings ("flags") between games in the
CHAIN anthology.

## SETTING PLAYER SPAWN POINT

Depending on the game the player left before entering your game, you may wish to
change the player's starting point.

See CHAIN_SpawnPoint.gd for information on how to set up different spawn points
for your game.
