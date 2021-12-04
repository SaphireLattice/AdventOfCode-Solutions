local inp = ""
for line in io.lines() do
    inp = inp .. line
end

function split_iter(context)
    context.index = (context.index or 0) + 1
    return context[context.index]
end

function split(self, sep)
    local sep, fields = sep or ",", {}
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(self, pattern, function(c) fields[#fields+1] = c end)

    return split_iter, fields, 1
end

local null = {0, 0, 0}

local pos = {0, 0, 0}

function vec3_abs(vec)
    return {math.abs(vec[1]), math.abs(vec[2]), math.abs(vec[3])}
end

function vec3_max(vec)
    return math.max(vec[1], vec[2], vec[3])
end

function vec3_sub(v1, ...)
    local vecs = {...}
    local ret = {v1[1], v1[2], v1[3]}
    for i=1,#vecs do
        ret[1] = ret[1] - vecs[i][1]
        ret[2] = ret[2] - vecs[i][2]
        ret[3] = ret[3] - vecs[i][3]
    end
    return ret
end

function vec3_sum(...)
    local vecs = {...}
    local ret = {0, 0, 0}
    for i=1,#vecs do
        ret[1] = ret[1] + vecs[i][1]
        ret[2] = ret[2] + vecs[i][2]
        ret[3] = ret[3] + vecs[i][3]
    end
    return ret
end

local dirs = {
    n  = { -1,  1,  0},
    ne = {  0,  1, -1},
    se = {  1,  0, -1},
    s  = {  1, -1,  0},
    sw = {  0, -1,  1},
    nw = { -1,  0,  1},
}

function move(vec)
    local p_pos = vec3_sum(pos)

    pos = vec3_sum(pos, vec)
    

    return vec3_max(vec3_abs(vec3_sub(pos, p_pos)))
end

local m = 0
local s = 1
for cmd in split(inp) do
    --print(pos[1], pos[2], pos[3])
    --print(move(dirs[cmd]))
    move(dirs[cmd])
    local c_pos = pos
    local d = move(vec3_sub(null, pos))
    pos = c_pos
    if (d > m) then m = d end
    io.write(s..","..cmd..","..d.."; ")
    s = s + 1
end
print()
print("============")
print(pos[1], pos[2], pos[3])
print(move(vec3_sub(null, pos)), m)

