(async () => {
    const rawInput: string = await Deno.readTextFile(Deno.args[0] || "day_6.input.txt");
    const data = rawInput
        .split(/[\n]{2,}/);

    function countUniqueAnswers(line: string) {
        let count = 0;
        const answers: boolean[] = [];
        for (let i = 0; i < line.length; i++) {
            const char = line.charCodeAt(i);
            if (char == 10) continue;
            answers[char - 97] = true;
        }
        answers.forEach(value => count += (value ? 1 : 0));
        return count;
    }

    function countUnanimousAnswers(line: string) {
        let count = 0;
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
            count += (value == subitems ? 1 : 0)
        );
        return count;
    }

    console.log(`Total unique: ${data.reduce((total, item) => total + countUniqueAnswers(item), 0)}`);
    console.log(`Total unanimous: ${data.reduce((total, item) => total + countUnanimousAnswers(item), 0)}`);
})();