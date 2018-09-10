defmodule NSGconfParser do
  def parse(str) do
    with {:ok, tokens, _} <- :nsgconf_lexer.string(to_charlist(str)),
         {:ok, _result} <- :nsgconf_parser.parse(tokens) do
      nil
    else
      {:error, {line, :nsgconf_lexer, {reason, rest}}, _} ->
        "#{line}: #{to_string(reason)}: #{
          Regex.run(~r/([^\n]*)\n*/, to_string(rest)) |> Enum.at(1)
        }"

      # inspect({line, :nsgconf_lexer, {reason, rest}})

      {:error, {line, :nsgconf_parser, reason}} ->
        "#{line}: #{to_string(reason)}"

      # inspect(reason)

      other ->
        inspect(other)
    end
  end
end
