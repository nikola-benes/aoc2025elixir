import Aoc

# This was weird…

IO.stream(:line)
|> stream_chunk_only(& &1 != "\n")
|> Enum.at(-1)
|> Enum.count(fn line ->
  [_, w, h, spec] = Regex.run(~r/(.*)x(.*): (.*)/, line)
  [w, h | spec] = [w, h | String.split(spec)] |> Enum.map(&String.to_integer/1)
  div(w, 3) * div(h, 3) >= Enum.sum(spec)
end)
|> IO.puts
