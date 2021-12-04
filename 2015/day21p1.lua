
--TYPE, COST, DAMAGE, ARMOR
weapons = {
{1,  8, 4, 0},
{1,  10, 5, 0},
{1,  25, 6, 0},
{1,  40, 7, 0},
{1,  74, 8, 0},
}
armor = {
[0]={2,   0, 0, 0},
{2,  13, 0, 1},
{2,  31, 0, 2},
{2,  53, 0, 3},
{2,  74, 0, 4},
{2, 102, 0, 5},
}
rings_r = {
[0]={3,   0, 0, 0},

{3,  25, 1, 0}, --1
{3,  50, 2, 0}, --2
{3, 100, 3, 0}, --3

{3,  20, 0, 1}, --4
{3,  40, 0, 1}, --5
{3,  80, 0, 3}, --6
}
rings_c = {}
for i=0,#rings_r do
    for l=0,#rings_r do
        if (i==0 and l==0) or i~=l then
            table.insert(rings_c, {{i,l},rings_r[i][2]+rings_r[l][2],rings_r[i][3]+rings_r[l][3],rings_r[i][4]+rings_r[l][4]})
        end
    end
end

tries = {}
--A try is: { gold spent, outcome (1 or 2), your hp, boss hp }

function try(your_stats,boss_stats,cost)
    local stats = {}
    y_hp = your_stats[1]
    b_hp = boss_stats[1]
    --if cost<100 then print() print("COST: "..cost) end
    while ((y_hp>0) and (b_hp>0)) do
        --if cost<100 then print(y_hp,b_hp) end
        y_hp = y_hp - (boss_stats[2]-your_stats[3])
        b_hp = b_hp - (your_stats[2]-boss_stats[3])
    end
    
    outcome = 1 -- boss wins
    if y_hp > 0 and not (b_hp > 0) then
        outcome = 2 -- you win
    end
    
    if tries[cost] and tries[cost][1]~=outcome then print("WARNING: overwriting try "..cost.."$ from outcome ."..tries[cost][1]..". to !"..outcome.."!" ) end
    tries[cost] = {outcome, y_hp, b_hp}
    return tries[cost]
end

for kw,vw in pairs(weapons) do
    local ys = {100,0,0}
    ys[2]=vw[3]
    for ka,va in pairs(armor) do
        ys[3]=vw[4]
        for kr,vr in pairs(rings_c) do
            ys[2]=ys[2]+vr[3]
            ys[3]=ys[3]+vr[4]
            local t = try(ys,{100, 8, 2},vw[2]+va[2]+vr[2])
            if t[1]==2 and vw[2]+va[2]+vr[2]<100 then
                print("What the fuck: ",kw,ka,vr[1][1],vr[1][2])
            end
        end
    end
end

for k,v in pairs(tries) do
    if v[1]==2 and k<min then min = k end
end
print(min)