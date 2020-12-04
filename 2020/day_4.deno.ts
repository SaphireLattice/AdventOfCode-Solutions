(async () => {
    // https://stackoverflow.com/questions/43118692/typescript-filter-out-nulls-from-an-array
    function notEmpty<TValue>(value: TValue | null | undefined): value is TValue {
        return value !== null && value !== undefined;
    }

    const validators = {
        number: (min: number | null, max: number | null, length: number) => {
            return (input: string) => {
                if (
                    input.length != length
                    || !/^(\d+)$/.test(input)
                    || !Number.isInteger(+input)
                )
                    return false;
                const num = +input;
                return (min != null ? min <= num : true)
                    && (max != null ? max >= num : true);
            }
        },
        unitNumber: (
                units: { min: number, max: number, string: string }[],
                prefix: boolean = false
            ) => {
            return (input: string) => {
                let value = 0;
                let unit: { min: number, max: number, string: string } | null = null;
                if (prefix) {
                    const matched = input.match(/(\D+)(\d+)/);
                    value = matched ? +matched[2] : 0;
                    unit = units.find(u => matched && u.string == matched[1]) || null;
                } else {
                    const matched = input.match(/(\d+)(\D+)/);
                    value = matched ? +matched[1] : 0;
                    unit = units.find(u => matched && u.string == matched[2]) || null;
                }
                return unit != null
                    && Number.isInteger(value)
                    && unit.min <= value && unit.max >= value;
            }
        },
        hexColor: (input: string) => {
            return input.match(/^#[0-9a-f]{6,6}$/) != null;
        },
        setMatch: (validSet: string[]) => {
            return (input: string) => {
                return validSet.some(v => v == input);
            }
        },
    }

    const fields = [
        {
            key: "byr",
            validate: validators.number(1920, 2002, 4)
        },
        {
            key: "iyr",
            validate: validators.number(2010, 2020, 4)
        },
        {
            key: "eyr",
            validate: validators.number(2020, 2030, 4)
        },
        {
            key: "hgt",
            validate: validators.unitNumber([
                { string: "cm", min: 150, max: 193 },
                { string: "in", min: 59, max: 76 }
            ])
        },
        {
            key: "hcl",
            validate: validators.hexColor
        },
        {
            key: "ecl",
            validate: validators.setMatch([
                "amb", "blu", "brn", "gry", "grn", "hzl", "oth"
            ])
        },
        {
            key: "pid",
            validate: validators.number(null, null, 9)
        },
        {
            key: "cid",
            required: false,
            validate: () => true
        },
    ]

    function parsePassport(rawInput: string) {
        const passportFields = rawInput
            .split(" ")
            .map(textField => {
                const regexpResult = textField.match(/([^:]+):([^:]+)/);
                return regexpResult ? {
                    key: regexpResult[1],
                    value: regexpResult[2]
                } : null
            })
            .filter(notEmpty);
        let pass = true;
        console.log("Input: " + rawInput);
        fields.forEach(field => {
            const found = passportFields.find(p => p.key == field.key);
            const validated = found != undefined && field.validate(found.value);
            if (
                (field.required ?? true)
                && !validated
            ) {
                if (found && !validated)
                    console.log(`Invalid value for field ${field.key}: ${found!.value}`)
                pass = false;
            }
        });
        console.log(`${pass ? "Valid" : "Invalid"}`)
        console.log()
        return pass;
    }

    const data: string = await Deno.readTextFile("day_4.input.txt");
    const passportsRaw = data
        .replace(/([^\n])\n([^\n])/g, "$1 $2")
        .split(/[\n]+/)
        .filter(s => s.trim() != "");

    //let valid: number = 0;

    const validated = passportsRaw.filter(p => parsePassport(p));

    console.log(validated.length);
})();