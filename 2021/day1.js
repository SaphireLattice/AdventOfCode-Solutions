$0.innerText.split("\n")
    .filter(n => n != "")
    .map(n => +(n.trim()))
    .reduce(
        (a, n) => {
            const [count, ...rest] = a;

            const prevSum = rest.reduce((s, n) => (n ?? 0) + s, 0);

            const last = rest.pop()
            rest.unshift(n)

            const newSum = rest.reduce((s, n) => (n ?? 0) + s, 0);

            const condition =
                last != null
                && newSum > prevSum;

            return [
                (count ?? 0) + (condition ? 1 : 0),
                ...rest
            ];
        },
        new Array(1 + 3)
    )
