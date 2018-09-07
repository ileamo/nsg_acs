defmodule NSGconfParser do
  def parse(str) do
    with {:ok, tokens, _} <- :nsgconf_lexer.string(to_charlist(str)),
         {:ok, result} <- :nsgconf_parser.parse(tokens) do
      nil
    else
      {:error, reason, _} ->
        reason

      {:error, {line, :nsgconf_parser, reason}} ->
        {line, to_string(reason)}
    end
  end
end
