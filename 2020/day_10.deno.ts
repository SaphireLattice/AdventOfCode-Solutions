(async () => {
    // Starting from 4th
    const tribonnaci = [ 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, 927, 1705, 3136, 5768, 10609, 19513, 35890, 66012 ];
    const rawInput: string = await Deno.readTextFile(Deno.args[0] || "day_10.input.txt");
    const data = rawInput
        .split("\n");

    function parseLine(line: string) {
        const num = Number(line);
        return num;
    }

    let items = data.map(l => parseLine(l)).sort((a, b) => a - b);


    let diffs: number[] = [0, 0, 0];
    let previous = 0;
    let runCounter = 0;
    let runMult = 1;

    items.push(items[items.length - 1] + 3);

    items.forEach((item) => {
        diffs[item - previous - 1]++;
        console.log(item, item - previous - 1);
        if (item - previous == 3) {
            console.log(`Group of: ${runCounter} ( * ${tribonnaci[runCounter]})`);
            runMult *= tribonnaci[runCounter];
            runCounter = 0;
        } else {
            runCounter++;
        }
        previous = item;
    })

    console.log(`Part 1: ${diffs[0] * diffs[2]}`)
    console.log(`Part 2: ${runMult}`);
})();