# Exploration of CLIPS

[CLIPS](https://www.clipsrules.net/) is a rule‑based programming language useful for creating expert systems and other programs where a heuristic solution is easier to implement and maintain than an algorithmic solution.

This is a personal repository for Tyson Lemire to learn more about CLIPS and explore its application in various environments.

## Learning
[Project](./adventures_in_rules_based_programming) from the [Adventures in Rule‑Based Programming book](https://clipsrules.net/airbp.html).

### Setup
Download and compile the clips runtime and move it to `./adventures_in_rules_based_programming/bin`

Run CLIPS REPL:
```sh
`./bin/clips`
```

Load the application:
```clips
CLIPS> (batch load.bat)
```

Run the application:
```clips
CLIPS> (run)
```

Exit REPL:
```clips
(exit)
```

### Isolated rules tests

```clips
(batch test.bat)
```
