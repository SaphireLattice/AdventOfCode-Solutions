local programs = {}
-- format: [name] = {name, weight, total_weight, holds[],  stands}

function split(self, sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function parse(line)
    local s, e, name, weight, holds = string.find(line, "([a-z]+) %(([0-9]+)%) ?(-?>?)")
    programs[name] = programs[name] or {}
    if holds then
        holds = split(string.gsub(string.sub(line, e + 1), " ", ""), ",")
        programs[name].holds = {}
        for i=1, #holds do
            programs[holds[i]] = programs[holds[i]] or {}
            programs[holds[i]].stands = programs[name]
            programs[name].holds[i] = programs[holds[i]]
        end
    end
    
    programs[name].weight = weight
    programs[name].name = name

    return name
end

for line in io.lines("day6.input") do
    local name = parse(line)
end

local root
local leafs = {}

for k,v in pairs(programs) do
    if v.stands == nil then
        root = v
        print("Root: "..k)
    elseif v.holds == nil or #(v.holds) == 0 then
        leafs[#leafs + 1] = v
    end
end

local p = leafs[1]
io.write(p.name)
local layers = 1
while p.stands do
    p = p.stands
    layers = layers + 1
    io.write(" > "..p.name)
end
io.write(" - "..layers.." layers \n")

query = {root}

local layer = 1
layers = {}
while #query ~= 0 do
    nquery = {}
    layers[layer] = {}
    for i=1, #query do
        local h = query[i].holds
        query[i].layer = layer
        table.insert(layers[layer], query[i])
        for i=1, #h do
            nquery[#nquery + 1] = h[i]
        end
    end
    query = nquery
    layer = layer + 1
end

for i=1,(#layers - 1) do
    local ri = #layers - i
    print(i, ri)
    for j=1,#layers[ri] do
        local n = layers[ri][j]
        n.total_weight = n.weight
        for h=1,#n.holds do
            n.total_weight = math.floor(n.total_weight + (n.holds[h].total_weight or n.holds[h].weight))
        end
        for h=1,#n.holds do
            if (math.floor((n.total_weight - n.weight)/#n.holds) < math.floor(n.holds[h].total_weight or n.holds[h].weight)) then
                print("UNBALANCED ====>",n.name, n.weight, n.total_weight, math.floor((n.total_weight - n.weight) / #n.holds), " | ", n.holds[h].name, (n.holds[h].total_weight or n.holds[h].weight),"<====")
            end
        end
        print(n.stands and n.stands.name or "ROOT", n.name, n.total_weight, n.weight)
    end
end

