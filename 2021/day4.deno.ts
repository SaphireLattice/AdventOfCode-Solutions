// deno-lint-ignore-file ban-unused-ignore no-unused-vars no-empty
(async () => {
    const data: string = await Deno.readTextFile(Deno.args[0] || "input/day_4.txt");
    const lines = data.split("\n");

    const gridSize = 5;

    const bingoLine = lines.shift()!.split(",").map(n => +n);
    if (!bingoLine)
        throw new Error("No bingo draws are defined!");
    lines.shift();

    const grids = lines.reduce((grids: number[][], line, idx, arr) => {
        if (line == "") {
            if (idx == (arr.length - 1))
                return grids;
            const actualSize = grids[grids.length - 1].length;
            if (actualSize != gridSize**2)
                throw new Error(`Invalid bingo defined with ${actualSize} instead of ${gridSize**2} elements`);
            grids[grids.length] = [];
        }
        else
            grids[grids.length - 1].push(
                ...line
                    .split(" ")
                    .filter(c => c != "")
                    .map(c => +c)
            );
        return grids;
    }, [[]])

    function mark(grid: number[], draw: number): boolean {
        const i = grid.indexOf(draw);
        if (i == -1)
            return false;
        grid[i] = -1;
        return true;
    }

    function winCheck(grid: number[]): boolean {
        for (let i = 0; i < gridSize; i++) {
            let [xMark, yMark] = [0, 0];
            for (let j = 0; j < gridSize; j++) {
                if (grid[i * gridSize + j] == -1)
                    xMark++;
                if (grid[j * gridSize + i] == -1)
                    yMark++;
            }
            if (xMark == gridSize || yMark == gridSize)
                return true;
        }
        return false;
    }

    let won = null;
    let draw: number | undefined = undefined;
    while (!won && bingoLine.length > 0) {
        draw = bingoLine.shift()!;
        console.log("Drawn:", draw);
        const marked = grids.reduce((sum, g) => sum + (mark(g, draw!) ? 1 : 0), 0);
        console.log("Marked", marked);
        const maybeWin = grids.reduce(
            (val: number | null, grid, idx) =>
                val == null
                    ? (winCheck(grid) ? idx : null)
                    : val,
            null
        )
        won = maybeWin;
        console.log();
    }
    if (!draw)
        throw new Error(`Nothing was drawn`);
    console.log("The winner is", won);
    if (!won)
        throw new Error(`No winning board found, check code or input data`);

    const winner = grids[won];
    for (let i = 0; i < gridSize; i++) {
        console.log(
            winner.filter(
                (_, n) =>
                    n >= i * gridSize &&
                    n < (i + 1) * gridSize
            ).map(n => `${n == -1 ? "_" : n}`.padStart(3, " ")).join("")
        )
    }
    const partOne = winner.filter(n => n != -1).reduce((s, n) => s + n, 0) * draw;

    let playing = grids
        .map((g, i) => winCheck(g) ? null : i)
        .filter(n => n != null) as number[];

    let outNow = grids
        .map((g, i) => winCheck(g) ? i : null)
        .filter(n => n != null) as number[];

    while (playing.length > 0 && bingoLine.length > 0) {
        console.log("Still in play:", playing)
        draw = bingoLine.shift()!;
        console.log("Drawn:", draw);
        const marked = playing.map(i => grids[i]).reduce(
            (sum, g) =>
                sum + (mark(g, draw!) ? 1 : 0),
            0
        );
        console.log("Marked", marked);
        const res = playing
            .map((n): [number, boolean] => [n, winCheck(grids[n])]);
        playing = res
                .filter(t => t[1] == false)
                .map(t => t[0]);
        outNow = res
                .filter(t => t[1] == true)
                .map(t => t[0]);
        console.log("Out:", outNow)
        console.log();
    }

    console.log("Numbers left:", bingoLine.length)
    console.log("Still in play:", playing)
    console.log("Just won:", outNow)

    console.log("Part 1", partOne);
    if (playing.length > 1)
        throw new Error(`More than one board left in play, no solution for part 2 available`);
    if (outNow.length > 1)
        throw new Error(`More than one board just won, no solution for part 2 available`);
    if (outNow.length == 0)
        throw new Error(`No boards have won this turn, something is wrong or there's no bingo draws left`);

    const partTwo = grids[outNow[0]!].filter(n => n != -1).reduce((s, n) => s + n, 0) * draw;
    console.log("Part 2", partTwo);

    /*console.log(
        bingoLine,
        grids
    )*/
})()