(async () => {
    const rawInput: string = await Deno.readTextFile(Deno.args[0] || "day_6.input.txt");
    const data = rawInput
        .split(/[\n]{2,}/);

    let totalUniqueAnswers = 0;

    function countUniqueAnswers(line: string) {
        const answers: boolean[] = [];
        for (let i = 0; i < line.length; i++) {
            const char = line.charCodeAt(i);
            if (char == 10) continue;
            answers[char - 97] = true;
        }
        answers.forEach(value => totalUniqueAnswers += (value ? 1 : 0));
        console.log(line);
    }

    function countUnanimousAnswers(line: string) {
        const answers: number[] = Array<number>(26).fill(0);
        let subitems = 1;
        for (let i = 0; i < line.length; i++) {
            const char = line[i].charCodeAt(0);
            if (char == 10)
                subitems += 1
            else
                answers[char - 97] += 1;
        }
        answers.forEach(value =>
            totalUniqueAnswers += (value == subitems ? 1 : 0)
        );
        console.log(line);
    }

    data.forEach(item => countUnanimousAnswers(item));

    console.log(totalUniqueAnswers);
})();