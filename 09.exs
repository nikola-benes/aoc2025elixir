import Aoc

for line <- IO.stream(:line) do
  line |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
end
|> assign_to(red)

for {[bx, by], b} <- red |> Stream.with_index |> Stream.drop(1),
     [ax, ay]     <- red |>                      Stream.take(b) do
  (abs(ax - bx) + 1) * (abs(ay - by) + 1)
end
|> Enum.max
|> IO.puts
