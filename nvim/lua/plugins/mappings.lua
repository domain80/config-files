return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Make H go to first non-blank character (originally ^)
          ["H"] = { "^", desc = "Go to first non-blank character" },
          -- Make ^ go to top of screen (originally H)
          ["^"] = { "H", desc = "Go to top of screen" },
          -- Make L go to end of line (originally $)
          ["L"] = { "$", desc = "Go to end of line" },
          -- Make $ go to bottom of screen (originally L)
          ["$"] = { "L", desc = "Go to bottom of screen" },
        },
        v = {
          -- Apply the same swaps in visual mode
          ["H"] = { "^", desc = "Go to first non-blank character" },
          ["^"] = { "H", desc = "Go to top of screen" },
          ["L"] = { "$", desc = "Go to end of line" },
          ["$"] = { "L", desc = "Go to bottom of screen" },
        },
        o = {
          -- Apply in operator-pending mode for motions like dH, d^, dL, d$
          ["H"] = { "^", desc = "Go to first non-blank character" },
          ["^"] = { "H", desc = "Go to top of screen" },
          ["L"] = { "$", desc = "Go to end of line" },
          ["$"] = { "L", desc = "Go to bottom of screen" },
        },
      },
    },
  },
}
