import re, sys, json

PATTERN = r"\[(.*?)\]"

def cast_format_snarkjs_generatecall(generatecall_output:str) -> str:
    """
    Converts the output of snarkjs generatecall to a format that can be used by cast. In addition, it writes the output to a file called formatted_calldata.json.

    :param generatecall_output: The output of snarkjs generatecall.
    :return: The formatted calldata.
    """

    # Convert the output of snarkjs generatecall to JSON
    json_formatted_calldata = json.dumps([
        list(map(
            lambda x: str(int(x.strip().strip('"'), 16)),
            match.split(",")
        ))
        for match in re.findall(PATTERN, generatecall_output)
    ])

    # Write the JSON to a file
    with open("formatted_calldata.json", "w") as file:
        json.dump(
            dict(zip(
                ("proof", "pubSignals"),
                json.loads(json_formatted_calldata)
            )),
            file,
            indent=4
        )

    # Return the formatted calldata as a string that can be used by cast
    return (
        json_formatted_calldata
        [1:-1]
        .replace("], [", "]  [")
        .replace(", ", ",")
    )

# If this file is run directly, then read the input from stdin and print the output to stdout
if __name__ == "__main__":
    print(
        cast_format_snarkjs_generatecall(
            sys.stdin.read()
        )
    )