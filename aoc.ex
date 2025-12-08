defmodule Aoc do
  defmacro e ~> f do
    quote do
      unquote(e) |> Stream.map(fn x -> x |> unquote(f) end)
    end
  end

  defmacro assign_to(value, var) do
    quote do: unquote(var) = unquote(value)
  end

  def stream_chunk_only(e, f) when is_function(f, 1) do
    e |> Stream.chunk_by(f) |> Stream.filter(fn [x | _] -> f.(x) end)
  end
end

defmodule DisjointSets do
  @moduledoc """
  This implements the disjoint set data structure with union by size and path
  compression.

  In addition to the usual union and find operations, the module can produce
  the sizes of all sets in the structure (all_sizes) and detect whether there
  is only one set containing all the elements (only_one?).
  """

  @enforce_keys [:parent, :size, :last_root]
  defstruct @enforce_keys

  def new(keys) do
    %__MODULE__{
      parent: keys |> Map.new(&{&1, &1}),
      size: keys |> Map.new(&{&1, 1}),
      last_root: keys |> Enum.at(0),
    }
  end

  def find(%__MODULE__{parent: parent} = ds, key) do
    case parent[key] do
      ^key -> {key, ds}
      p -> {root, ds} = find(ds, p); {root, put_in(ds.parent[key], root)}
    end
  end

  def union(ds, key1, key2) do
    {root1, ds} = find(ds, key1)
    {root2, ds} = find(ds, key2)
    if root1 == root2, do: ds, else: link(ds, root1, root2)
  end

  defp link(%__MODULE__{parent: parent, size: size}, root1, root2) do
    {s1, s2} = {size[root1], size[root2]}
    {small, large} = if s1 < s2, do: {root1, root2}, else: {root2, root1}
    %DisjointSets{
      parent: put_in(parent[small], large),
      size: put_in(size[large], s1 + s2),
      last_root: large
    }
  end

  def all_sizes(%__MODULE__{parent: parent, size: size}) do
    for {k, k} <- parent, do: size[k]
  end

  def only_one?(%__MODULE__{size: size, last_root: root}) do
    size[root] == map_size(size)
  end
end
