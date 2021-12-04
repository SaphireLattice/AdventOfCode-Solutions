local function calculate_hash(text)
    local hash = ""
    local chars = {}
    local pos, char = 1, text:sub(1,1)
    while not char:find("[0-9]") do
        char = text:sub(pos, pos)
        --------
        if char ~= "-" then
            local n = char:byte() - 96
            chars[n] = (chars[n] or 0) + 1
        end
        --------
        pos = pos + 1
    end
    local max, mpos = 0, 0
    local pos = 1
    while #hash < 5 do
        local n = (chars[pos] or 0)
        -----
        if n > max then
            max = n
            mpos = pos
        end
        --
        if pos == 26 then
            hash = hash .. string.char(mpos + 96)
            chars[mpos] = nil
            max, mpos = 0, 0
        end
        -----
        pos = pos + 1
        if pos >= 27 then pos = 1 end
    end
    return hash
end


local function get_hash(text)
    local s, e = string.find(text, "%[[a-z]+%]")
    return string.sub(text, s + 1, e - 1)
end

local function get_sid(text)
    return tonumber(string.sub(text, string.find(text, "[0-9]+")))
end

local function decrypt(text)
    local payload = string.sub(text, string.find(text, "[a-z-]+[0-9]")):sub(1, -3)
    local sid = get_sid(text)
    local decrypted = ""

    local pos = 1
    while pos <= #payload do
        char = payload:sub(pos, pos)
        -------
        local byte = string.byte(char)
        if char ~= "-" then
            byte = ((byte - 97 + sid) % 26) + 97
            if byte > 122 or byte < 96 then
                print(byte)
            end
        end
        decrypted = decrypted .. string.char(byte)
        -------
        pos = pos + 1
    end
    return decrypted
end

local num = 0
for line in io.lines("16.4.txt") do
    if calculate_hash(line) == get_hash(line) then
        num = num + get_sid(line)
        print(decrypt(line).." - "..get_sid(line))
    end
end
print(num)
