local code = {}
local register = {}

local ops = {
    ["inc"] = 1,
    ["dec"] = 2,

    [1] = function(reg, amount) register[reg] = (register[reg] or 0) + amount end,
    [2] = function(reg, amount) register[reg] = (register[reg] or 0) - amount end,
}
local cops = {
    ["=="] = 1,
    ["!="] = 2,
    [">" ] = 3,
    ["<" ] = 4,
    [">="] = 5,
    ["<="] = 6,

    [1] = function(a,b) return a == b end,
    [2] = function(a,b) return a ~= b end,
    [3] = function(a,b) return a >  b end,
    [4] = function(a,b) return a <  b end,
    [5] = function(a,b) return a >= b end,
    [6] = function(a,b) return a <= b end,
}

function newOp(register, op, amount, cond_register, cond_op, cond_amount)
    return {
        ["register"] = register,
        ["op"] = ops[op],
        ["amount"] = tonumber(amount),
        ["cond_register"] = cond_register,
        ["cond_op"] = cops[cond_op],
        ["cond_amount"] = tonumber(cond_amount)
    }
end

function doOp(op)
    if cops[op.cond_op](register[op.cond_register] or 0, op.cond_amount) then
        ops[op.op](op.register, op.amount)
    end
end

function process(line)
    local s, e, reg, op, am, creg, cop, cam = string.find(line, "([a-z]+) ([incde]+) ([-0-9]+) if ([a-z]+) ([<>!=]+) ([-0-9]+)")
    code[#code + 1] = newOp(reg, op, am, creg, cop, cam)
end

for line in io.lines("day8.input") do
    process(line)
end

local m = -99999
local n = ""
for i=1, #code do
    doOp(code[i])
    for k,v in pairs(register) do
        if v > m then m = v n = k end
    end
end
print(m, n)
