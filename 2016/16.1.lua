local input = "L5, R1, R3, L4, R3, R1, L3, L2, R3, L5, L1, L2, R5, L1, R5, R1, L4, R1, R3, L4, L1, R2, R5, R3, R1, R1, L1, R1, L1, L2, L1, R2, L5, L188, L4, R1, R4, L3, R47, R1, L1, R77, R5, L2, R1, L2, R4, L5, L1, R3, R187, L4, L3, L3, R2, L3, L5, L4, L4, R1, R5, L4, L3, L3, L3, L2, L5, R1, L2, R5, L3, L4, R4, L5, R3, R4, L2, L1, L4, R1, L3, R1, R3, L2, R1, R4, R5, L3, R5, R3, L3, R4, L2, L5, L1, L1, R3, R1, L4, R3, R3, L2, R5, R4, R1, R3, L4, R3, R3, L2, L4, L5, R1, L4, L5, R4, L2, L1, L3, L3, L5, R3, L4, L3, R5, R4, R2, L4, R2, R3, L3, R4, L1, L3, R2, R1, R5, L4, L5, L5, R4, L5, L2, L4, R4, R4, R1, L3, L2, L4, R3,"

------------------ Direction
local dir = 0   -- N E S W
                -- 0 1 2 3
------------------
local dir_t = {"North",
               "East",
               "South",
               "West"
              }
------------------

local x, y = 0, 0
local locs = {}
locs[0] = {}
locs[0][0] = 1

local function turn_left()
    dir = dir - 1
    if dir < 0 then dir = 3 end
end

local function turn_right()
    dir = dir + 1
    if dir > 3 then dir = 0 end
end

local function forward(count)
    local xs, ys = 0, 0
    if dir == 0 or dir == 2 then
        ys = (1 - dir)
    end
    if dir == 1 or dir == 3 then
        xs = (2 - dir)
    end
    for i=1,count do
        x = x + xs
        y = y + ys
        locs[x] = locs[x] or {}
        if locs[x][y] == 1 then
            print("Visited twice: "..x.." "..y)
        end
        locs[x][y] = (locs[x][y] or 0) + 1
    end
end

local pos = 1
local count = ""

while pos <= #input do
    local char = string.sub(input, pos, pos)
    ------
    if char == "L" then
        turn_left()
    elseif char == "R" then
        turn_right()
    elseif tonumber(char) then
        count = count .. char
    elseif char == "," then
        forward(tonumber(count))
        count = ""
    end
    ------
    pos = pos + 1
end

print("Destination: "..x.." "..y)

