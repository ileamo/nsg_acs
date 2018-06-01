[
  # functions to let allow the no parens like def print value
  locals_without_parens: [field: :*, belongs_to: :*, has_many: :*],

  # files to format
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
