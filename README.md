# Dragon
Snake game using verilog on Spartan

We have designed and implemented a snake game also known as Dragon ."Dragon" is a simple game where the “food” is being spawn at random parts of the map. The user controls the Dragon by using the directional pads on the FPGA. The dragon gets longer and harder to control the more food it consumes. The aim is to not let dragon touch any part of the body. You will lose if the head of the dragon collides with its own body, or if the dragon hits one of the borders.
In our game, the dragon eats food to grow larger and longer. We have a pseudo-random coordinate generating module to place food at a random part of the screen when the game starts and whenever the dragon eats the food from the head. In order to generate a random position for the food to be placed on the screen, we use the "randomGrid" module to randomly select a location for the food to appear. 
If the coordinates are the same, a collision is detected. This is done by checking if the dragon and another object are being drawn on the VGA at the same time.  Lethal collisions consist of the dragon colliding with its own body and non lethal collisions occur when the dragon collides with food,which results in the size of the dragon being increased. If a lethal collision is detected, the VGA screen will display a red screen,which signals game over.

Innovative part:
The innovative part is that we have added multiple level design for the game itself. Hence it is more challenging. We have 3 stages of level, namely “Easy”, “Medium” and “ Hard”. The game is still the same, expect that with added wall, the user might face increased difficulty in navigating the game. One more feature that we can add in to the game is invisible barriers. The walls are actually there but are “invisible”. Hence, the player must remember the coordinates of those “invisible” barriers in order not to lose the game.

Bryan : Game implementation,VGA output
Poni : Level Design and VGA output
Shi Wei : Level Design and Button mapping 
