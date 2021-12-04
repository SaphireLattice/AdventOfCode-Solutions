local num = 0

local function check(t)
    if  t[1] + t[2] <= t[3] or
        t[2] + t[3] <= t[1] or
        t[1] + t[3] <= t[2] then
        return false
    else
        return true
    end
end
file = io.open("16.3.txt")

for line in file:lines() do
    local t = {}
    local i = 1
    for n in string.gmatch(line, "[0-9]+") do
        t[i] = tonumber(n)
        i = i + 1
    end
    if check(t) then
        num = num + 1
    end
end
print(num)

num = 0
local lc = 0
local set = ""

file:close()

for line in io.lines("16.3.txt") do
    set = set .." ".. line
    lc = lc + 1
    if lc == 3 then
        print(set)
        v = {}
        local i = 1
        for n in string.gmatch(set, "[0-9]+") do
            v[i] = tonumber(n)
            i = i + 1
            print(i)
        end

        local t1, t2, t3 = {v[1], v[4], v[7]},
            {v[2], v[5], v[8]},
            {v[3], v[6], v[9]}
        local i = 1
        if check(t1) then
            num = num + 1
        end
        if check(t2) then
            num = num + 1
        end
        if check(t3) then
            num = num + 1
        end
        set = ""
        lc = 0
    end
end
print(num)
