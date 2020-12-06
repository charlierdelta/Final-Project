# Final-Project

## Major Challenge

At first I struggled with getting the thrust, bullet vector, and heading to work properly, but a review of trigonometry allowed me to raise
and lower the value of a variable and take the sin and cos of it to get the x and y components. I had help with the angle and 
collision detection from the tutorial site https://simplegametutorials.github.io/love/asteroids/ , though the movement and 
'sprite' generation came from the Harvard cs50 game tracks.

## Minor difficulties

Since I wanted to add to the end of the game, having the player go to a new area was a must. I used the variable gameState to work around that,
and in love.update and love.draw test the gameState variable to change what is drawn and what is called. I played around with the idea of 
making a screen class, or having each other area be its own class, as having functions called in main only to draw screens feels clunky or 
inelegent. Ultimately it was also easier and more straightforward to have function calls in main.lua.

I wasn't sure how I would handle the bullets at first as the player is in control of how many are in play at one time. The solution also feels
inelegent, putting a test for gameState in love.keyPressed. If I left it in with the other controls it would produce a stream of bullets, so it 
was frustrating that I couldn't find a better workaround.


## Other note

I have taken three Java classes so going to python and lua afterwards makes those languages feel very lightweight and intuitive. Java is nice,
but a project in another class at the same time as this project made me realize how simplified the python and lua are, though there are advantages
and disadvantages to each language. But I really enjoyed this project and it's amazing what can be done with these languages even at an
introductory level.
