(async () => {
    const data: string = await Deno.readTextFile("day_5.input.txt");
    const mapping: Record<string, number> = {
        F: 0, B: 1,
        L: 0, R: 1
    }
    const seats = data
        .split("\n")
        .map(r => parseInt(r.replace(/[FBLR]/g, c => ""+mapping[c]), 2))
        .sort((a, b) => a - b);

    console.log(seats.length, seats.reduce((max, curr) => curr > max ? curr : max, 0));

    console.log(seats.filter((seat, index, array) => index == 0 ? false : array[index - 1] != seat - 1));
})();
