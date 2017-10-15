using ImageView, Images   # TestImages  just a reminder poop stinks!
using Gtk.ShortNames

grid, frames, canvases = canvasgrid((1,1))  # 1 row, 2 columns




#
#img = load("/home/travis/Documents/Mael Engine/sprites/cloud.png")
cloud = load("/home/travis/Documents/Mael Engine/sprites/cloud.png")
cloud2 = load("/home/travis/Documents/Mael Engine/sprites/cloud2.png")
LeftPlayer = load("/home/travis/Documents/Mael Engine/sprites/leftplayer.png")
MiddlePlayer = load("/home/travis/Documents/Mael Engine/sprites/middleplayer.png")
img = fill(RGBA(0.65625,0.796875,1,1), 500, 800)

imshow(canvases[1,1], img )
#win = @Window(canvas, "Grinding Gears", 500, 800)

win = Window(grid, "Grinding Gears", 800, 500)
showall(win)
# ==============================================================================
# This draws a line to a picture!
# ==============================================================================
function line(image, x1, y1, x2, y2, color)
        dx, dy = x2-x1,  y2-y1

        for x in x1:x2
              y = y1 + dy * (x - x1) / dx
              image[ round(Int32, y), round(Int32, x) ] = color
        end
end
# ==============================================================================
# This draws a rectrangle to a picture!
# ==============================================================================
function rect(image, left, top, width, height, color)
    for y in 1:height, x in 1:width
        pixel(image, top+y, left+x, color )
    end
end
# ==============================================================================
function clearScreen(image, color)
    height, width = size(image)
    for y in 1:height, x in 1:width
        image[ y, x ] = color
    end
end
# ==============================================================================
# This draws a rectrangle to a picture! 1="centered" 2= topCenter
# ==============================================================================
function drawSprite(image, sprite, x, y, position=1)
    # width, height = size(image)
    SpHeight, SpWidth = size(sprite)
    if position==1
        cx,cy = round(Int32, SpWidth/2), round(Int32, SpHeight/2)
    elseif  position==2
        cx,cy = round(Int32, SpWidth/2), SpHeight
    elseif position==3
        cx,cy = round(Int32, SpWidth/2), 0
    end
    left, top = x-cy, y-cx

    for y in 1:SpWidth,  x in 1:SpHeight
        pixel(image, left+x, top+y, sprite[ x, y ] )
    end
end
# ==============================================================================
function drawSprite(image, sprite) # sprite.image, sprite.x, sprite.y, sprite.position=1
    SpHeight, SpWidth = size(sprite.image)
    if sprite.position==1
        cx,cy = round(Int32, SpWidth/2), round(Int32, SpHeight/2)
    elseif  sprite.position==2
        cx,cy = round(Int32, SpWidth/2), SpHeight
    elseif sprite.position==3
        cx,cy = round(Int32, SpWidth/2), 0
    end
    left, top =  sprite.y-cy, sprite.x-cx

    for y in 1:SpWidth,  x in 1:SpHeight
        pixel(image, left+x, top+y, sprite.image[ x, y ] )
    end
end
# ==============================================================================
# This draws a pixel with Alpha chanel
# ==============================================================================
function pixel(image, X, Y, color )
    a = alpha(color)
    width, height = size(image)
    if X>0 && X < width && Y>0 && Y < height
        image[ X,Y ] = image[ X,Y ]*(1-a) + (color*a)
    end
end
# ==============================================================================
# This calculates the positions of all sprites draws them.
# ==============================================================================
function Paint(list)
     height, width  = size(img)
    clearScreen(img, RGBA(0.65625,0.796875,1,1))
    for item in list
        drawSprite(img, item)
        if item.x < width
            item.x += 4
        end
    end
    imshow(canvases[1,1], img)
end
# ==============================================================================
# Data structure to hold sprites
# ==============================================================================
mutable struct Sprite
    image           # Image or image class. for example it could be mario but mario could change depending on what he is doing
    x::Int          # Coordinates
    y::Int          # Coordinates
    direction::Int  # direction of movement.
    movement::Int   # Type of movement: walk, jump, float, fall...
    position::Int   # the positioning: centered, above, below...
end
# ==============================================================================


spritelist = []
# line(img, 100, 200, 250, 275, RGB(0,0.3,0.5))
# rect(img, 200, 400, 150, 25, RGBA(0.65,0,0.5, 0.5) )
# rect(img, 0, 0, 50, 50, RGBA(0.65,0,0.5, 0.5) )
# rect(img, 300, 410, 150, 25, RGBA(0.72,0.65,0.5, 0.8) )

# drawSprite(img, cloud, 100, 100)
# drawSprite(img, cloud, 100, 600)
# drawSprite(img, cloud2, 100, 400)
# drawSprite(img, cloud, 150, 200)

push!(spritelist, Sprite(cloud, 100, 100, 1, 3, 2) )
push!(spritelist, Sprite(cloud, 100, 600, 1, 3, 2) )
push!(spritelist, Sprite(cloud2, 100, 400, 1, 3, 2) )
push!(spritelist, Sprite(cloud, 150, 200, 1, 3, 2) )

push!(spritelist, Sprite(LeftPlayer, 100, 150, 1, 3, 2) )
# mario = Sprite(LeftPlayer, 100, 150, 1, 3, 2)
# push!(spritelist, mario)




u1 = Timer(u1 -> Paint(spritelist), 0.001, 0.001)
