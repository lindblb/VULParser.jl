# VULParser.jl
Parses the DNA trial balance report into tabular csv format

## Installation
```julia
using Pkg
Pkg.add("https://github.com/AgCountryFCS/VULParser.jl")
```

Run tests:
```julia
]
test
```

## Usage
The module exports a single function which takes a CM_TRIAL.VUL file as input, and returns a dataframe.

```julia
using CSV
using VULParser

df = VULParser.VUL({path to CM_TRIAL.VUL})

# Save output to CSV
CSV.write({filename.csv}, df)
```

## Contributors
* [Brad Lindblad](https://github.com/lindblb)

## Contact
* [Brad Lindblad](https://github.com/lindblb)
