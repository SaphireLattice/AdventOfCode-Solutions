function intmachine(initState, input)
    local function get(state, position)
        return state[position + 1] or 0
    end

    local function set(state, position, value)
        state[position + 1] = math.floor(tonumber(value or 0))
    end

    local halt = false
    local inputPos = 1
    local output = {}

    local opcodes = {
        [01] = {
            args = 3,
            outputs = { 3 },
            fun = function(state, code, left, right, out)
                set(state, out, left + right)
            end
        },
        [02] = {
            args = 3,
            outputs = { 3 },
            fun = function(state, code, left, right, out)
                set(state, out, left * right)
            end
        },
        [03] = {
            args = 1,
            outputs = { 1 },
            fun = function(state, code, target)
                io.write(": ")
                local num = nil
                if input and input[inputPos] then
                    num = input[inputPos]
                    inputPos = inputPos + 1
                    io.write("" .. num .. "\n")
                else
                    num = io.read("*number")
                end
                if tonumber(num) ~= num or num == nil then return "Not a numeric input" end
                set(state, target, num)
            end
        },
        [04] = {
            args = 1,
            fun = function(state, code, value)
                io.write("> " .. tostring(value) .. "\n")
                output[#output + 1] = value
            end
        },
        [05] = {
            args = 2,
            fun = function(state, code, value, jump)
                if value ~= 0 then
                    state.ip = jump
                    state.jumped = true
                end
            end
        },
        [06] = {
            args = 2,
            fun = function(state, code, value, jump)
                if value == 0 then
                    state.ip = jump
                    state.jumped = true
                end
            end
        },
        [07] = {
            args = 3,
            outputs = { 3 },
            fun = function(state, code, value, compare, out)
                set(state, out, value < compare and 1 or 0)
            end
        },
        [08] = {
            args = 3,
            outputs = { 3 },
            fun = function(state, code, value, compare, out)
                set(state, out, value == compare and 1 or 0)
            end
        },
        [99] = {
            args = 0,
            fun = function(state, code, code)
                halt = true
            end
        },
    }

    local function runOp(state, position)
        local rawop = get(state, position)
        local op = opcodes[rawop % 100]
        if (not op) then return "invalid opcode" end
        local args = {}
        args[1] = {
            code = rawop % 100,
            raw = rawop,
            mode = {}
        }
        local modes = math.floor(rawop / 100)
        for i = 1, op.args do
            local mode = modes % 10
            modes = math.floor(modes / 10)
            args[1].mode[i] = mode

            for k,v in pairs(op.outputs or {}) do
                if v == i then
                    if mode ~= 0 then
                        return "output " .. i .. "is not in position mode but in mode " .. mode
                    end
                    mode = -1 -- hack to not set the out addr to gibberish
                end
            end

            args[i + 1] = get(state, position + i)
            if mode == 0 then
                args[i + 1] = get(state, args[i + 1])
            end
        end
        local returned = op.fun(state, table.unpack(args)), op.args + 1
        if returned or state.jumped then
            state.jumped = false
            return returned, 0
        end
        return returned, op.args + 1
    end

    local state = {}
    for i=1,#initState do
        state[i] = initState[i]
    end

    state.jumped = false
    state.ip = 0

    while not halt do
        --print(state.ip, get(state, state.ip))
        local res, skip = runOp(state, state.ip)
        if res then
            print("Error " .. tostring(res) .. " in " .. get(state, state.ip) .. " at " .. state.ip)
            return false
        end
        state.ip = state.ip + skip
    end
    local result = get(state, 0)
    return result, output
end

local day7state = {
    3,8,
    1001,8,10,8,
    105,1,0,

    0,21,46,59,72,93,110,191,272,353,434,99999,

    3,9,
    1001,9,4,9,
    1002,9,3,9,
    1001,9,5,9,
    1002,9,2,9,
    1001,9,5,9,
    4,9,
    99,

    3,9,
    1002,9,5,9,
    1001,9,5,9,
    4,9,
    99,

    3,9,
    1001,9,4,9,
    1002,9,4,9,
    4,9,
    99,

    3,9,
    1002,9,3,9,
    1001,9,3,9,
    1002,9,2,9,
    1001,9,5,9,
    4,9,
    99,

    3,9,
    1001,9,2,9,
    1002,9,4,9,
    1001,9,2,9,
    4,9,
    99
}

local max = 0

function day7(state)
    local prevValue = 0
    for k,v in pairs(state) do
        local null, outputs = intmachine(day7state, {v, prevValue})
        prevValue = outputs[1]
    end
    if (prevValue > max) then
        print(prevValue)
        max = prevValue
    end
end

function permutate(state, depth)
    depth = depth or 1
    for i=0,4 do
        local ok = true
        for k,v in pairs(state) do
            if v == i then
                ok = false
            end
        end
        if ok then
            state[depth] = i
            permutate(state, depth + 1)
            state[depth] = nil
        end
    end
    if (depth == 6) then
        day7(state)
    end
end


permutate({})
print(max)

--[[asd
(function()
    for i=0,100 do
        for j=0,100 do
            local result = intmachine(i, j)
            if tonumber(result) ~= result then
                return
            elseif result == 19690720 then
                print(i, j)
                return
            end
        end
    end
end)()]]