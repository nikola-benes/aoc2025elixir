alias DisjointSets, as: DS

vertices =
  for line <- IO.stream(:line) do
    line |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

size = length(vertices)
to_take = if size <= 20, do: 10, else: 1000

edges =
  for {[bx, by, bz], b} <- vertices |> Stream.with_index |> Stream.drop(1),
      {[ax, ay, az], a} <- vertices |> Stream.with_index |> Stream.take(b) do
    {a, b, (ax - bx) ** 2 + (ay - by) ** 2 + (az - bz) ** 2}
  end
  |> Enum.sort_by(fn {_, _, d2} -> d2 end)

ds = DS.new(0..(size - 1))

edges
|> Stream.take(to_take)
|> Enum.reduce(ds, fn {a, b, _}, ds -> DS.union(ds, a, b) end)
|> DS.all_sizes
|> Enum.sort(:desc)
|> Stream.take(3)
|> Enum.product
|> IO.puts

edges
|> Enum.reduce_while(ds, fn {a, b, _}, ds ->
  if DS.only_one?(ds = DS.union(ds, a, b)) do
    {:halt, [a, b]}
  else
    {:cont, ds}
  end
end)
|> Stream.map(& Enum.at(vertices, &1) |> hd)
|> Enum.product
|> IO.puts
