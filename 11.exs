import Aoc

defmodule Day11 do
  def toposort(graph) do
    dfs(graph, Map.keys(graph), MapSet.new, []) |> elem(1)
  end

  def dfs(graph, todo, seen, post) do
    for v <- todo, reduce: {seen, post} do
      {s, p} ->
        if v in s do
          {s, p}
        else
          {s, p} = dfs(graph, graph[v], MapSet.put(s, v), p)
          {s, [v | p]}
        end
    end
  end

  def count_paths(graph, topo, from, to) do
    topo
    |> Stream.drop_while(& &1 != from)
    |> Enum.reduce_while(%{from => 1}, fn v, paths ->
      case {v, paths[v]} do
        {^to, goal} -> {:halt, goal}
        {_, nil} -> {:cont, paths}
        {v, c} -> {:cont, Map.merge(
          paths,
          Map.new(graph[v], &{&1, c}),
          fn _, c1, c2 -> c1 + c2 end
        )}
      end
    end)
  end
end

IO.stream(:line)
~> (String.replace(":", "") |> String.split)
|> Map.new(fn [src | dst] -> {src, dst} end)
|> Map.put("out", [])
|> assign_to(graph)
|> Day11.toposort
|> assign_to(topo)

Day11.count_paths(graph, topo, "you", "out") |> IO.puts

if Enum.find(topo, & &1 in ["dac", "fft"]) == "fft" do
  ["svr", "fft", "dac", "out"]
else
  ["svr", "dac", "fft", "out"]
end
|> Stream.chunk_every(2, 1, :discard)
|> Enum.product_by(fn [from, to] ->
  Day11.count_paths(graph, topo, from, to)
end)
|> IO.puts
