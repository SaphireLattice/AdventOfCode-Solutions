$0.innerText
    .split("\n")
    .filter(n => n != "")
    .map(n => {
        const split = n.split(" ")
        return {
            dir: split[0],
            count: +split[1]
        };
    })
    .reduce((state, cmd) => {
        switch (cmd.dir) {
            case "down":
                state[2] += cmd.count;
                break;
            case "up":
                state[2] -= cmd.count;
                break;
            case "forward":
                state[0] += cmd.count;
                state[1] += state[2] * cmd.count;
                break;
            default:
                throw new Error(`Nope? '${cmd?.dir ?? "!NULL!"}'`);
        }
        return state;
    }, [0, 0, 0])
