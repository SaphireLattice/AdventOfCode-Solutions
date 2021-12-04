l = ""

for line in io.lines() do
    l = l..line
end
function decompress(str)
--    print(str)
--    local nstr = {}
    local nlength = 0
    local ptr = 1
    local char = string.sub(str, ptr, ptr)
    repeat
        if char == "(" then
            local token, tptr = nil, ptr
            repeat
                tptr = tptr + 1
                token = string.sub(str, tptr, tptr)
            until token == ")"
            local exp = string.sub(str, ptr + 1, tptr - 1)
            local s, e, length, times = string.find(exp, "([0-9]+)x([0-9]+)")
            length = tonumber(length)
            times = tonumber(times)
            ptr = tptr + length
--            local instr
            nlength = nlength + decompress(string.sub(str, tptr + 1, ptr))*times
--            print(instr, length, times)
            --table.insert(nstr, string.rep(instr, times))
        else
--            print(char)
--            table.insert(nstr, char)
            nlength = nlength + 1
        end

        ptr = ptr + 1
        char = string.sub(str, ptr, ptr)
    until char == ""
--    return table.concat(nstr, "")
    return nlength
end

local out = decompress(l)
print(out)
print(#out)
