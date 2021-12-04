local jumps = {}
local pos = 1

local args = {...}

for line in io.lines("day5.input") do
    jumps[1+#jumps] = tonumber(line)
end

function step()
    local val = jumps[pos]
    if args[1] == "2" and val >= 3 then
        jumps[pos] = jumps[pos] - 1
    else
        jumps[pos] = jumps[pos] + 1
    end
    pos = pos + val
end

local cycles = 0
while jumps[pos] do
    step()
    cycles = cycles + 1
end
print(pos, jumps[pos], cycles)
