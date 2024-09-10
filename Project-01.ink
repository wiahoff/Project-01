/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/

VAR time = 0
VAR day = 1
VAR strength = 0
VAR intelligence = 0
VAR hunger = 4
VAR food = 0
VAR water = 0
VAR axe = false
VAR key = false
VAR traveling = false
VAR height = 0
VAR jord_alive = true

You find yourself in a cold forest with no recollection of what happened before. You have no food, water or shelter. You must find civilization.
WARNING: it is extremely dangerous to travel at midnight. Make sure you find a place to sleep before then. 
TIP: Focus on either strength or intelligence but not both. 
-> forest1

== function loop_tower==
{height < 4:
You climb higher.
{height == 3: You feel tired...}
~height += 1
~loop_tower()
}
~return

== function get_time ==
        {    
        - time == 0:
            ~ return "dawn"
        
        - time == 1:
            ~ return "morning"
        
        - time == 2:
            ~ return "noon"

        - time == 3:
            ~ return "dusk"
            
        - time == 4:
            ~ return "night"
            
         - time == 5:
            ~ return "midnight"
        
    }

==function travel_off==
~ traveling = false

== function intelligence_up(X) ==
You feel smarter. (intelligence + {X})
~ intelligence += X
~ return

== function strength_up(X) ==
You feel stronger. (strength + {X})
~ strength += X
~ return

== function hungry ==
~ hunger -= 1
{hunger == 3: You feel hungry.}
{hunger == 2: You feel very hungry.}
{hunger == 1: You feel extremely hungry.}
{hunger == 0: You can't take it anymore...}
~ return

== function pass_time==
Time passes...
~ time += 1
{time == 6: 
    ~day += 1
    ~time = 0
}
{time == 4: You should sleep soon}
It is now {get_time()} on day {day}.
~ hungry()
~ return

== function eat==
You eat one piece of food.
~food -= 1
You have {food} left.
~hunger += 1
{hunger == 5: You are full.}

==lake_to_tower==
You begin to treck through snow.
{not play_cube and not smash_cube: You see a small cube on the ground covered in 3 by 3 colored tiles.}
{not traveling: 
~ pass_time()
}
~traveling = true
{hunger == 0: You starve to death. ->END}
{time == 5: You are eaten by wolves. -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> lake_to_tower
+[Go to tower] {travel_off()} -> tower
+[Go to frozen lake] {travel_off()}-> frozen_lake
*{not smash_cube}[Play with the cube] -> play_cube
*{not play_cube}[Smash the cube] -> smash_cube

==play_cube==
You fiddle with the cube until each side only has one color of tile. The cube suddenly vanishes after the colors are aligned.
~ intelligence_up(1)
-> lake_to_tower

==smash_cube==
You smash the cube.
~strength_up(1)
-> lake_to_tower

==shed_to_cave==
You travel through rocky terrain.
{not traveling: 
~ pass_time()
}
~traveling = true
{hunger == 0: You starve to death. ->END}
{time == 5: You are eaten by wolves. -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> shed_to_cave
+[Go to cave] {travel_off()} -> cave
+[Go to shed] {travel_off()} -> abandoned_shed

==grove_to_shed==
You begin to treck to through a feild of white grass.
{not traveling: 
~ pass_time()
}
~traveling = true
{hunger == 0: You starve to death. ->END}
{time == 5: You are eaten by wolves. -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> grove_to_shed
+[Go to shed] {travel_off()} -> abandoned_shed
+[Go to grove] {travel_off()} -> forest1

==grove_to_lake==
You begin to treck to through pine trees.
{not traveling: 
~ pass_time()
}
~traveling = true
{hunger == 0: You starve to death. ->END}
{time == 5: You are eaten by wolves. -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> grove_to_lake
+[go to frozen lake] {travel_off()} -> frozen_lake
+[go to grove] {travel_off()} -> forest1

==sleep_shed==
You sleep until dawn.
~ time = 0
~ day += 1
~ hungry()
{hunger == 0: You starve to death -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> shed_inside
+[Continue] -> shed_inside

==sleep_tent==
You sleep until dawn.
~ time = 0
~ day += 1
~ hungry()
{hunger == 0: You starve to death. -> END}
+{food > 0}{hunger < 6}[Eat] {eat()} -> frozen_lake
+[Continue] -> frozen_lake

==forest1==
You stand in a grove.
*[Check your surroundings] -> detail_forest1
*[Stop and think] -> thinking_forest1
*{detail_forest1}[Collect the moss] -> moss_pickup
+[Go north] -> grove_to_lake
+[Go south] -> grove_to_shed

==moss_pickup==
You collect the moss. You can probably eat this. You gain 3 food.
~ food += 3
-> forest1

==detail_forest1==
You climb up a rock and look around. To the north you see a frozen lake. To the south you see an abandoned shed. You also notice some moss on a tree.
-> forest1

==thinking_forest1==
You stop for a moment to collect your thoughts. You woke up in the middle of nowhere with nothing but some winter clothes. Something must have happened but you can't remember what.
~ intelligence_up(1)
-> forest1

==frozen_lake==
{not fishing: You arrive at the frozen lake. You see fish under the thin ice.} You see a tower in the distance. You see a small tent by the lake.
*[Try to catch fish] -> fishing
+[Sleep in the tent] -> sleep_tent
+[Move towards the tower] -> lake_to_tower
+[Go to grove] -> grove_to_lake

==fishing==
You attempt to get some fish.
*[Break the ice] -> broken_ice
*[Find a hole in the ice] -> hole_ice

==broken_ice==
You smash the ice. You find two fish.
~ strength_up(1)
~ food += 2
-> frozen_lake

==hole_ice==
you find a small hole in the ice. You find two fish.
~ intelligence_up(1)
~ food += 2
-> frozen_lake

==abandoned_shed==
{not jord: You reach the abandond shed. You feel uneasy.}
{jord: You stand next to the shed. You can sleep inside the shed if it gets late.}
{jord_fight: You see a body in the snow. The snow is painted in blood.}
+[Go inside] -> shed_inside
+[Continue south] -> shed_to_cave
+[Go to grove] -> grove_to_shed

==shed_inside==
You stand inside the wood shed. {not rations: You see some rations.}{not axe: You see an Axe.}
*[Take the rations] -> rations
*[Take the axe] -> axe_equip
+{jord}[Sleep] -> sleep_shed
+{not jord} [Leave] -> jord
+{jord} [Leave] -> abandoned_shed

==jord==
You heard a voice coming from outside. You open the door and see a man standing outside.
"What the hell are you doing in my shed!"
+["Who are you"] -> jord_converse1
+[Prepare for a fight] -> jord_fight

==jord_converse1==
"My name is jord." - jord says
"Are you trying to steal from me??" - jord scauffs
+{not rations}{not axe}[Show him you didn't steal] -> jord_converse2
+[Prepare for a fight] -> jord_fight

==jord_fight==
{axe: You raise your axe and smash jord's face with it -> jord_loot}
{not axe: You attempt to punch jord but it barely harms him. He whips out a pistol and shoots you. -> END}

==jord_loot==
~ jord_alive = false
You check jord's clothes and find food.
~ food += 1
-> abandoned_shed

==jord_converse2==
"Oh so you were just looking around." - jord says
"Yeah I'm lost and don't know how I got here." - You reply
"There is a magic tower up north that can allow you to travel anywhere in the world." - jord says
"I could get find civilization using that tower." - You say
"The tower is locked but there is a key for it in the cave down south." - jord says
"Im gonna go now. If you don't steal anything from my shed I may be able to help you later."
jord proceeds to leave.
~ intelligence_up(1)
+[Continue] -> abandoned_shed

==tower==
You reach the tower. The door is locked.
+[Go back to the lake] -> lake_to_tower
+{key}[Unlock the door] -> tower_inside

==rations==
You gain 2 food.
~ food += 2
{not jord: -> jord}
-> shed_inside

==axe_equip==
You pick up the axe.
~ strength_up(2)
~ axe = true
{not jord: -> jord}
-> shed_inside

==tower_inside==
You are in the tower. It is very quiet. You feel scared.
{jord_alive and not rations and not axe and jord: Jord appears behind you. "Hey I knew I would find you here. Thanks for not stealing my stuff. If you come with me I can lead you to my town I think you would like it there." - jord says} 
~ height = 0
+{jord_alive and not rations and not axe and jord}[Follow jord.] -> jord_ending
+[Climb the tower] -> tower_up
+[Leave the tower] -> tower

==jord_ending==
You follow Jord and he leads you to a large town called Jord Village. You make many friends and even get married.
-> END

==tower_up==
{jord_alive and not rations and not axe: You tell jord you arn't interested}
You climb higher.
~ loop_tower()
You finally reach a door.
+[Go down] -> tower_inside
+{strength >= 4}[Destroy the door] -> final_room
+{intelligence >= 4}[Lock pick the door] -> final_room

==final_room==
You enter a large room with a map. Standing in front of the map is a stone golem. He rushes towards.
+[Run] -> run
+{food >= 3}[Offer the golem food] -> golem_eat
+{axe}{strength >= 3}[Hit the golem with your axe] -> golem_defeat
+{strength >= 5}[Tackle the golem] -> golem_defeat
+{intelligence >= 5}[Hit the golem's weakspot] -> golem_defeat

==run==
You try to run but the golem is too fast. It crushes you.
-> END

==golem_eat==
You throw food at the golem. It seems confused. This gives you time to push it over. It collides with the ground.
-> golem_defeat

==golem_defeat==
The golem falls to rubble. You walk over to the map. A small inscription is below it.
"Simply put your finger where you want to go on the map."
+[Place your finger on Chicago] -> ending
+[Place your finger on LA] -> ending
+[Place your finger on Tokyo] -> ending

==ending==
As you place your finger on the city everything goes black for an instant before you are finally reunited with civilization.
Congrats you have won.
-> END

==cave==
You stand infront of a cave. {not cave_inside: Boulders block the path forward. Maybe if you are smart or strong you can remove them.} {not wood_workout and not wood_carve: You see a wood pile next to the cave. }
+[Go back to the shed] -> shed_to_cave
*{not wood_carve}[Do a workout with the wood] -> wood_workout
*{not wood_workout}[Carve the wood] -> wood_carve
*{intelligence >= 3}[Use a long rock as a lever to move the rocks] -> cave_inside
*{strength >= 3}[Destroy the rocks] -> cave_inside

==wood_workout==
You lift the wood abunch. You break all the wood.
~ strength_up(1)
->cave

==wood_carve==
You make a little carving in the wood. You carve all the wood.
~ intelligence_up(1)
->cave

==cave_inside==
You enter the cave and it is very dark. You faintly see a key. You pick it up and leave the cave.
~ key = true
-> cave

