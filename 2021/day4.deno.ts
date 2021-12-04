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

    const state = bingoLine.reduce(
        (state, draw) => {
            if (state.playing.length == 0)
                return state;
            console.log("Still in play:", state.playing)
            console.log("Drawn:", draw);
            const marked = state.playing.map(i => grids[i]).reduce(
                (sum, g) =>
                    sum + (mark(g, draw!) ? 1 : 0),
                0
            );
            console.log("Marked", marked);
            const res = state.playing
                .map((n): [number, boolean] => [n, winCheck(grids[n])]);
            state.playing = res
                    .filter(t => t[1] == false)
                    .map(t => t[0]);
            state.outNow = res
                    .filter(t => t[1] == true)
                    .map(t => t[0]);
            console.log("Out:", state.outNow)
            state.winners.push(
                ...state.outNow.map(
                    o => ({
                        grid: o,
                        score: grids[o].filter(n => n != -1).reduce((s, n) => s + n, 0) * draw
                    })
                )
            );
            console.log();
            return state;
        },
        {
            playing: grids
                .map((g, i) => winCheck(g) ? null : i)
                .filter(n => n != null) as number[],
            outNow: grids
                .map((g, i) => winCheck(g) ? i : null)
                .filter(n => n != null) as number[],
            winners: [] as { grid: number, score: number }[]
        }
    )

    console.log("Part 1:", state.winners[0].score)
    console.log("Part 2:", state.winners[state.winners.length - 1].score)
})()