import Aoc

IO.stream(:line)
~> String.split
|> Stream.zip_with(fn col ->
  [op | nums] = Enum.reverse(col)
  op = case op, do: ("+" -> &Enum.sum/1; "*" -> &Enum.product/1)
  nums ~> String.to_integer |> then(op)
end)
|> Enum.sum
|> IO.puts
