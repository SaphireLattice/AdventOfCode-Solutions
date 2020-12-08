(async () => {
    const rawInput: string = await Deno.readTextFile(Deno.args[0] || "day_8.input.txt");
    const data = rawInput
        .split("\n");

    interface Opcode {
        name: string;
        argument: number;
        visited: boolean;
        position: number;
        ignoreSwap: boolean;
    }

    function parseLine(line: string, index: number): Opcode {
        const match = line.match(/^([a-z]+) ([+-]?[0-9]+)$/)!;
        return {
            name: match[1],
            argument: parseInt(match[2]),
            visited: false,
            position: index,
            ignoreSwap: false
        }
    }

    let instructions = data.map((l, i) => parseLine(l, i));

    console.log(instructions);

    function runOnce(startPtr: number, startAcc: number, swapAt: number | null) {
        let current = instructions[startPtr];
        let ptr = startPtr;
        let accumulator = startAcc;
        let visited = [];
        //let accOnSwap: number | null = null;
        let swapOn: number | null = null

        while (current && current.visited == false) {
            if (
                (swapAt != ptr)
                && swapOn == null
                && (current.name == "nop" || current.name == "jmp")
                && !current.visited
                && !current.ignoreSwap
            ) {
                swapOn = ptr;
                //accOnSwap = accumulator;
            }

            const runName = (swapAt == ptr && !current.ignoreSwap)
                ? ({ "jmp": "nop", "nop": "jmp"} as Record<string,string>)[current.name] ?? current.name
                : current.name;

            if (runName != current.name)
                current.ignoreSwap = true;

            switch (runName) {
                case "jmp":
                    ptr += current.argument;
                    break;
                case "acc":
                    accumulator += current.argument;
                    ptr++;
                    break;
                case "nop":
                    ptr++;
                    break;
            }
            current.visited = true;
            //if (swapOn != null)
            visited.push(current);
            current = instructions[ptr] || null;
        }

        visited.forEach(i => i.visited = false);

        if (swapOn == null && current) {
            current.ignoreSwap = true
        }

        return {
            halts: current == null,
            position: ptr,
            accumulator: accumulator,
            swapOn: swapOn,
            //accOnSwap: accOnSwap
        }
    }

    let run = runOnce(0, 0, null);
    console.log(run);
    while (!run.halts) {
        run = runOnce(0, 0, run.swapOn);
        console.log(run);
    }
})();