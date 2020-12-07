(async () => {
    const rawInput: string = await Deno.readTextFile(Deno.args[0] || "day_7.input.txt");
    const data = rawInput
        .split("\n");

    interface Bag {
        checked: boolean;
        total: number | null;
        name: string;
        contains: any[];
    }

    function parseLine(line: string): Bag {
        const bags = line.match(/(\d{0,}\s?\S+ \S+) bags?/g)!;
        return {
            checked: false,
            total: null,
            name: bags[0].slice(0, -5),
            contains: bags[1] == " no other bags" ? [] :
                bags.slice(1).map(bag => {
                    return {
                        name: bag.match(/^\d+\s(\S+ \S+) bag/)![1],
                        amount: parseInt(bag.match(/^\d+/)![0])
                    }}
                )
        }
    }

    let bagGraph = data.map(l => parseLine(l));

    console.log(bagGraph);

    function containedByTypes(typeName: string) {
        let toCheck = [typeName];
        let total = 0;
        while (toCheck.length > 0) {
            const checking = toCheck.splice(0);
            toCheck = bagGraph.filter(
                    bag => !bag.checked
                        && bag.contains.some(
                            innerBag => checking.indexOf(innerBag.name) != -1
                        )
                    )
                .map(bag => (bag.checked = true, bag.name));
            total += toCheck.length;
            console.log(toCheck);
        }
        return total;
    }
    console.log(containedByTypes("shiny gold"));

    function contains(typeName: string): number {
        const bag = bagGraph.find(bag => bag.name == typeName)!;
        return bag.total ?? (bag.total = bag.contains.reduce(
            (total, bag) => total + bag.amount + bag.amount * contains(bag.name), 0
        ));
    }
    console.log(contains("shiny gold"));
})();