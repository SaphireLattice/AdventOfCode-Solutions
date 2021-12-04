((str, len)=>{
    function common(str) {
        let res = str
            .map(n => n.split(""))
            .reduce(
                (count, cur) => {
                    count[1]++;
                    cur.forEach((c, i) => count[0][i] = (count[0][i] ?? 0) + (+c))
                    return count;
                },
                [new Array(12), 0]
            )
       return res[0].map(
            n => n >= (res[1] / 2)
        )
    }
    function search(str, reverse) {
        for (let i = 0; i < len; i++) {
            const c = common(str);

            let neededVal = c[i] ? 1 : 0;
            if (reverse)
                neededVal = 1 - neededVal;

            str = str.filter(
                v => v[i] == neededVal
            )
            if (str.length == 1)
                break;
        }
        if (str.length != 1)
            throw new Error("Too many results")
        return parseInt(str[0], 2);
    }

    const gamma = parseInt(common(str).map(n => n ? 1 : 0).join(""), 2);
    const epsilon = (2 ** len) - 1 - gamma;

    const oxy = search([...str], false);
    const carb = search([...str], true);

    return {
        gamma,
        epsilon,
        power: gamma * epsilon,
        oxy,
        carb,
        life: oxy * carb,
    }
})(
    $0.innerHTML
        .split("\n")
        .filter(s => s != ""),
    12
)
