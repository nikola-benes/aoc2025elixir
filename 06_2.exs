import Aoc

{nums, [ops]} = IO.stream(:line) |> Enum.split(-1)

ops =
  String.split(ops)
  |> Enum.map(fn "+" -> &Enum.sum/1; "*" -> &Enum.product/1 end)

nums
~> (String.replace_trailing("\n", "") |> to_charlist)
|> Stream.zip_with(& &1)
~> (to_string |> String.trim)
|> Stream.chunk_by(& &1 == "")
|> Stream.reject(& &1 == [""])
~> Stream.map(&String.to_integer/1)
|> Stream.zip_with(ops, fn nums, op -> op.(nums) end)
|> Enum.sum
|> IO.puts

# Note: fn nums, op -> op.(nums) end is exactly &then/2, but that would be
# too cryptic. :-)
