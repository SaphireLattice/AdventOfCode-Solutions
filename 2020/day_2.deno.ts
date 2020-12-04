(()=>{
    const data: string = await Deno.readTextFile("day_2.input.txt");
    let valid: number = 0;
    data.split("\n")
        .forEach(line => {
            const parse = line.match(/(\d+)-(\d+) (.): (.*)/);
            if (!parse) throw new Error("Invalid definition: " + line);

            const count = parse[4].split("").filter(char => char == parse[3]).length ?? 0;
            if ((parse[4][+parse[1] - 1] == parse[3]) !== (parse[4][+parse[2] - 1] == parse[3])) {
                valid++;
                console.log(line, count, parse[4][+parse[1] - 1], parse[4][+parse[2] - 1]);
            }
        });
    console.log(valid);
})();