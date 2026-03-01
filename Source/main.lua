-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

player = {}
player.x = 100
player.y = 280
player.vx = 0
player.vy = 0
player.react = false
player.image = love.graphics.newImage("Stormy2.png")
player.h = player.image:getHeight()
player.l = player.image:getWidth()
print("longueur image = "..player.l)
print("hauteur image = "..player.h)
player.vl = player.l*0.05
player.vh = player.h*0.05
print("longueur image réelle = "..player.l*0.05)
print("hauteur image réelle = "..player.h*0.05)
-- 1506*900 pixels
--print(player.image.getWidth())
invgravity = false
ImgFire = love.graphics.newImage("flamme.png") -- https://www.pngegg.com/fr/png-dhgfj
DecalX = 0
DecalY = 0
BouleX = 0
liste_boulettes = {}
niveau = {}
for c = 1, 11 do
  niveau[c] = {}
  for l = 1,7 do
    niveau[c][l] = 0
  end
end

niveau = 
{
  {0,0,0,0,0,0,0}, 
  {0,0,0,1,0,0,0}, 
  {0,0,0,0,0,0,0}, 
  {0,0,0,0,0,0,0}, 
  {0,0,0,0,0,0,0}, 
  {0,0,1,0,0,0,0}, 
  {0,0,0,0,0,0,0}, 
  {0,0,0,0,0,0,1}, 
  {0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0}, 
  {1,0,0,0,0,0,0} 
}

function CreeBoulette(colX,ligY)
  boulette = {}
  boulette.x = colX * 75
  boulette.y = ligY * 45 - 22
  print(boulette.x.." "..boulette.y)
  boulette.supprime = false
  boulette.vx = 1
  
  table.insert(liste_boulettes, boulette)
  return boulette
  
end


function love.load()
  
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()
  print(largeur_ecran)
  print(hauteur_ecran)
  for c = 1, 11 do
    for l = 1,7 do
      if niveau[c][l] == 1 then
        CreeBoulette(c, l)
      end
    end
  end
  
  print(#liste_boulettes)
end

function love.update(dt)
  player.x = player.x + player.vx
  player.y = player.y + player.vy
  if invgravity == false then 
    if player.y > 315 then
      player.y = 315
      player.vy = 0 
    end
    if player.y < 0 then
      player.y = 0
    end    
    if love.keyboard.isDown("up") then
      player.react = true
      if player.vy > -0.7 then
        player.vy = player.vy - 0.15
      end
    else player.react = false
    end
    if player.vy < 5 then
      player.vy = player.vy + 0.05
    end
  end
  if invgravity == true then
    if player.y < 0 then
      player.y = 0
      player.vy = 0
    end
    if player.y > 315 then
      player.y = 315

    end    
    if love.keyboard.isDown("down") then
      player.react = true
      if player.vy < 0.7 then
        player.vy = player.vy + 0.15
      end
    else player.react = false
    end
    if player.vy > - 5 then
      player.vy = player.vy  -0.05
    end
  end
  BouleX = BouleX - 1
  BouleY = love.math.random(5)
  DecalX = love.math.random(10)
  DecalY = love.math.random(10)
  if player.x < 0 then
    player.x = 0
    player.vx = 0
  end
  if player.x > largeur_ecran - player.vl then
    player.x = largeur_ecran - player.vl
    player.vx = 0
  end
end

function love.draw()
  -- ciel
  love.graphics.setColor(0.1,0.5,1)
  love.graphics.rectangle("fill",0, 0, largeur_ecran, 360)
  -- héros
  love.graphics.setColor(1,1,1)
  if invgravity == false then 
    love.graphics.draw(player.image,player.x + DecalX*0.2,player.y + DecalY*0.2,0,0.05,0.05)
    -- love.graphics.rectangle("fill",player.x, player.y,20, 30)
  end
  if invgravity == true then
    love.graphics.draw(player.image, player.x, player.y + player.vh,3.14,-0.05,0.05) 
  end
  -- boulettes
  love.graphics.circle("fill",700 + BouleX,200 + BouleY,5)
  -- sol
  love.graphics.setColor(0.5,1,0.5)
  love.graphics.rectangle("fill",0,360,largeur_ecran, hauteur_ecran - 345)
  -- vitesse
  love.graphics.print("vy = "..player.vy,10,10)
  -- réacteur
  if player.react == true then
    love.graphics.setColor(1,1,1)
    if invgravity == false then
      love.graphics.draw(ImgFire, player.x + DecalX, player.y + player.vh + DecalY,0,0.2,0.2)
    elseif invgravity == true then
      love.graphics.draw(ImgFire, player.x + DecalX*2, player.y - 5 + DecalY ,3.14,-0.2,0.2)
    end
  end
  local n
  for n = 1, #liste_boulettes do
    local b = liste_boulettes[n]
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", b.x, b.y, 5)
 --   print("prout")
  end
  
end

function love.keypressed(key)
  
  print(key)
  if key == "right" then
    player.vx = player.vx + 1
  end
  if key == "left" then
    player.vx = player.vx - 1
  end

  if key == "space" then
    
    if invgravity == false then
 --     player.x = player.x - player.vl
 --     player.y = player.y - player.vh
      invgravity = true 

  elseif invgravity == true then
--    player.x = player.x - player.vl
--    player.y = player.y + player.vh
      invgravity = false
    end
  end
  
  
end
