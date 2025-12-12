import Aoc

# This produces an interval instead of an incorrect answer. :-)

IO.stream(:line)
|> stream_chunk_only(& &1 != "\n")
|> Enum.split(-1)
|> assign_to({presents, [trees]})

for [_ | p] <- presents do
  p
  |> Stream.flat_map(&to_charlist/1)
  |> Enum.count(& &1 == ?#)
end
|> assign_to(p_sizes)

for line <- trees do
  [_, w, h, spec] = Regex.run(~r/(.*)x(.*): (.*)/, line)
  [w, h | spec] = [w, h | String.split(spec)] |> Enum.map(&String.to_integer/1)
  {w, h, spec}
end
|> assign_to(trees)

dot_product = fn x, y -> Enum.zip_with(x, y, fn a, b -> a * b end) end
sure = fn {w, h, spec} -> div(w, 3) * div(h, 3) >= Enum.sum(spec) end
maybe = fn {w, h, spec} -> w * h >= Enum.sum(dot_product.(spec, p_sizes)) end

[lb, ub] = [sure, maybe] |> Enum.map(&Enum.count(trees, &1))

IO.puts(if lb == ub, do: lb, else: "The answer lies between #{lb} and #{ub}.")
