md5 = require("md5.md5")

local pass = {}

local input = "wtnhxymk"

local cinematic = true

local function number(num)
    local names = { "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT"}
    return names[num] or "___"
end

local function gen_pass(tbl)
    local pass = ""
    for i=1, 8 do
        pass = pass .. (tbl[i] or "~")
    end
    return pass
end

local incr = 0
while #pass < 8 do
    local tohash = input .. incr
    local hash = md5.sumhexa(tohash)
    ------
    if incr % 100000 == 0 then print(incr, hash) end
    if hash:sub(1,5) == "00000" then
        if not cinematic then
            print(hash:sub(6,6))
            pass[#pass + 1] = hash:sub(6,6)
        else
            status = "!"
            local sixth = hash:sub(6,6)
            local pos = tonumber(sixth)
            local seventh = hash:sub(7,7)
            if pos and pos + 1 <= 8 and pass[pos + 1] then status = "!ERR_REPL!"
            elseif pos and pos + 1 <= 8 then pass[tonumber(sixth) + 1] = seventh status = "!"..number(pos + 1).."!"
            else status = status .. sixth .. seventh
            end
            print(gen_pass(pass), hash, status:rep(16):sub(1,32))
        end
    end
    ------
    incr = incr + 1
end
print(table.concat(pass, ""))
