local args = {...}

--the asm code of task, with newline at the end
code_15 = [[jio a, +16
inc a
inc a
tpl a
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
tpl a
tpl a
inc a
jmp +23
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
tpl a
inc a
inc a
tpl a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
inc a
tpl a
tpl a
inc a
jio a, +8
inc b
jie a, +4
tpl a
inc a
jmp +2
hlf a
jmp -7
]]

code = [[cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 13 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5
]]

code_test = [[cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
]]

--[[--
    VM registers:
     0xFF - current address pointer
     0x00 - wut :|
     0x01 - a
     0x02 - b
     0x03 - c
     0x04 - d
    VM opcodes:
     0x01 - INC - X - increases register X
     0x02 - JMP - X - JMP to X
     0x03 - JIE - X, Y - JMP to X but only if register Y is even (e.g. Y%2==0)
     0x04 - JIO - X, Y - JMB to X but only if register Y equals one
     0x05 - HLF - X - halves the register in two (integer rules?)
     0x06 - TPL - X - triples the register value
     0x07 - DEC - X -
     0x08 - CPY - X, Y - Copy interger or register to target register
     0x09 - JNZ - X, Y - JMP to Y but only if register X equals zero
--]]--

function H(IN)
    if type(IN)~="number" then return 00 end
    IN = math.abs(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),(IN%B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return string.rep("0",2-#OUT)..OUT
end

local debug = true
local d_level = tonumber(args[1] or "0")
function dprint(lvl, ...)
    if not debug then return end
    if d_level < lvl then return end
    print(...)
end

mem = {}

register = {0, 0, 1, 0}

asm_opcodes = {["inc"]=1, ["jmp"]=2, ["jie"]=3, ["jio"]=4, ["hlf"]=5, ["tpl"]=6, ["dec"]=7, ["cpy"]=8, ["jnz"]=9}

asm_registers = {["a"]=-1, ["b"]=-2, ["c"]=-3, ["d"]=-4}

opcodes = {
    function(pnt) --INC
        local reg = math.abs(mem[pnt+1])
        register[reg] = register[reg] + 1
        dprint(2, "INC "..mem[pnt+1])
        return pnt+3
    end,
    function(pnt) --JMP
        local new = pnt + ((mem[pnt+1] % 0x80) * ( (mem[pnt+1]>0x80 and -3) or 3))
        dprint(2, "JMP "..new)
        return new
    end,
    function(pnt) --JIE
        dprint(2, "JIE")
        if register[math.abs(mem[pnt+1])]%2==0 then
            return  pnt + ((mem[pnt+2] % 0x80) * ( (mem[pnt+2]>0x80 and -3) or 3))
        end
        return pnt+3
    end,
    function(pnt) --JIO
        dprint(2, "JIO")
        if register[math.abs(mem[pnt+1])]==1 then
            return  pnt + ((mem[pnt+2] % 0x80) * ( (mem[pnt+2]>0x80 and -3) or 3))
        end
        return pnt+3
    end,
    function(pnt) --HLF
        local n = (register[math.abs(mem[pnt+1])]/2) - (register[math.abs(mem[pnt+1])]%2)
        register[math.abs(mem[pnt+1])] = math.ceil(n)
        dprint(2, "HLF "..mem[pnt+1])
        return pnt+3
    end,
    function(pnt) --TPL
        register[math.abs(mem[pnt+1])] = register[math.abs(mem[pnt+1])] * 3
        dprint(2, "TPL "..mem[pnt+1])
        return pnt+3
    end,
    function(pnt) --DEC
        local reg = math.abs(mem[pnt+1])
        register[reg] = register[reg] - 1
        return pnt+3
    end,
    function(pnt) --CPY
        local val
        dprint(2, "CPY "..mem[pnt+1].." "..mem[pnt+2])
        if mem[pnt+1] < 0 then
            val = register[math.abs(mem[pnt+1])]
        else
            val = mem[pnt+1]
        end
        register[math.abs(mem[pnt+2])] = val
        return pnt+3
    end,
    function(pnt) --JNZ
        dprint(2, "JNZ")
        if mem[pnt+1] > 0 then
            return pnt + ((mem[pnt+2] % 0x80) * ( (mem[pnt+2]>0x80 and -3) or 3))
        end
        if register[math.abs(mem[pnt+1])]~=0 then
            return pnt + ((mem[pnt+2] % 0x80) * ( (mem[pnt+2]>0x80 and -3) or 3))
        end
        return pnt+3
    end
}

---- Assembler
lines = {}
register[0xFE] = 0
for line in string.gmatch(code, "[- a-z0-9+,]+\n") do
    line = line:sub(1, -2).." "
    pnt = register[0xFE] * 3
    local i = 0
    for m in string.gmatch( line, "[^, \n]+" ) do
        if 0 == i then mem[pnt] = asm_opcodes[m] print("'"..m.."'")
        elseif 1 == i then
            if not tonumber(m) or mem[pnt] == 9 then
                mem[pnt+1] = asm_registers[m] or -m
                print("'"..m.."'")
            else
                n = tonumber(m)
                print(n)
                mem[pnt+1] = math.abs(n)
                if n < 0 then
                    mem[pnt+1] = mem[pnt+1] + 128
                end
                print("'"..m.."'")
            end
        elseif 2 == i then
            if not tonumber(m) then
                mem[pnt+2] = asm_registers[m]
                print("'"..m.."'")
            else
                n = tonumber(m)
                print(n)
                mem[pnt+2] = math.abs(n)
                if n < 0 then
                    mem[pnt+2] = mem[pnt+2] + 128
                end
                print("'"..m.."'")
            end
        end
        i = i + 1
    end
    mem[pnt+0]=mem[pnt+0] or 0
    mem[pnt+1]=mem[pnt+1] or 0
    mem[pnt+2]=mem[pnt+2] or 0
    print(pnt..": "..mem[pnt].." "..mem[pnt+1].." "..mem[pnt+2])
    register[0xFE] = register[0xFE] + 1
    lines[register[0xFE]] = line
    print(register[0xFE])
end

---- Emulator
register[0xFF] = 0
visited = {}
h = {} -- reasons for halt
steps = 0
while opcodes[mem[register[0xFF]]]~=nil do
    local pnt = register[0xFF]
    local str = " [ "
    if d_level > 0 then
        for k,v in pairs(asm_registers) do
            str = str..k..":"..H(register[math.abs(v)]).." "
        end
        dprint(1, H(pnt)..":  "..H(mem[pnt])..H(mem[pnt+1])..H(mem[pnt+2])..str.."] "..lines[math.floor(pnt/3 + 1)])
    end
    pnt = (opcodes[mem[register[0xFF]]])(pnt)
    if pnt == register[0xFF] then h[1]=true break end
    if pnt == nil then h[2]=true break end
    visited[pnt] = (visited[pnt] or 0) + 1
    register[0xFF] = pnt
    steps = steps + 1
    if (steps % 200000 == 0) then
        for k,v in pairs(asm_registers) do
            str = str..k..":"..H(register[math.abs(v)]).." "
        end
        print(steps/20000, H(pnt)..":  "..H(mem[pnt])..H(mem[pnt+1])..H(mem[pnt+2])..str.."] "..lines[math.floor(pnt/3 + 1)])
    end
end
print("--------------")
if h[1] then print("JMP TO SAME POSITION HAS BEEN DETECTED") end
if h[2] then print("OPCODE FUNCTION RETURNED NIL") end
print("PROGRAM HALTED")
print("--------------")
print("REGISTERS DUMP: ")
for k,v in pairs(register) do print(k,v) end
