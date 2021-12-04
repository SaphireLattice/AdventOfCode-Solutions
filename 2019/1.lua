local mass = {
    137139,
    104321,
    137149,
    82531,
    97698,
    56831,
    115133,
    64329,
    111730,
    145953,
    73388,
    57230,
    61935,
    58542,
    147631,
    79366,
    115484,
    86997,
    80362,
    129109,
    58568,
    121969,
    63696,
    68116,
    86668,
    62059,
    59485,
    132507,
    107823,
    94467,
    53032,
    140962,
    129499,
    80599,
    147570,
    96463,
    126169,
    108575,
    133312,
    146929,
    79826,
    114449,
    110908,
    66107,
    62171,
    91677,
    128188,
    90483,
    81045,
    96006,
    110366,
    140765,
    148360,
    54565,
    56664,
    121547,
    78839,
    123739,
    115408,
    123245,
    92419,
    132564,
    80022,
    103370,
    145366,
    145211,
    110360,
    145897,
    140817,
    77978,
    138064,
    148134,
    86208,
    89472,
    67117,
    63423,
    148536,
    105835,
    107783,
    98601,
    66702,
    50459,
    55127,
    79808,
    79628,
    76264,
    134392,
    125547,
    118186,
    80947,
    121669,
    107315,
    145093,
    56296,
    117226,
    105409,
    149238,
    142651,
    103286,
    139215
}

sum = 0
for i=1,#mass do
    local needed = math.max(0, math.floor(mass[i] / 3) - 2)
    local fuel = needed
    while fuel ~= 0 do
        fuel = math.max(0, math.floor(fuel / 3) - 2)
        needed = fuel + needed
    end
    sum = sum + needed
end
print(sum)
