(async () => {
    const data: string = await Deno.readTextFile("day_3.input.txt");
    const lines = data.split("\n");

    const slopes = [
        { x: 1, y: 1 },
        { x: 3, y: 1 },
        { x: 5, y: 1 },
        { x: 7, y: 1 },
        { x: 1, y: 2 },
    ]

    let total = 1;
    slopes.forEach((slope) => {
        let x = 0;
        let y = 0;
        let trees: number = 0;
        lines.forEach((line, index) => {
            if (index != y) return;
            if (line[x % line.length] == "#") {
                trees++;
            }
            x += slope.x;
            y += slope.y;
        });
        total *= trees;
        console.log(`Slope ${slope.x}:${slope.y} -> ${trees} trees (total ${total})`)
    })
})()