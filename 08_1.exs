defmodule Day08 do
  def build_graph(edges, size) when is_integer(size) do
    edges
    |> Enum.reduce(Map.new(0..(size - 1), &{&1, []}), fn {a, b, _}, g ->
      g |> update_in([a], &[b | &1]) |> update_in([b], &[a | &1])
    end)
  end

  def dfs(graph, v, visited, acc \\ 0) do
    if v in visited do
      {acc, visited}
    else
      graph[v]
      |> Enum.reduce(
        {acc + 1, MapSet.put(visited, v)},
        fn w, {acc, visited} -> dfs(graph, w, visited, acc) end
      )
    end
  end
end

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

graph =
  edges
  |> Enum.sort_by(fn {_, _, d2} -> d2 end)
  |> Enum.take(to_take)
  |> Day08.build_graph(size)

0..(size - 1)
|> Enum.reduce({[], MapSet.new}, fn v, {components, visited} ->
  {c, visited} = Day08.dfs(graph, v, visited)
  {[c | components], visited}
end)
|> elem(0)
|> Enum.sort(:desc)
|> Stream.take(3)
|> Enum.product
|> IO.puts
