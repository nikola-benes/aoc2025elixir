import Aoc

defmodule Day10 do
  def solve(line) do
    line
    |> String.split
    |> tl
    ~> (String.split(~r/\D/, trim: true) |> Enum.map(&String.to_integer/1))
    |> Enum.split(-1)
    |> assign_to({buttons, [goal]})

    b_vars =
      buttons
      |> Stream.with_index
      |> Enum.map(fn {_, i} -> " b#{i}" end)

    declaration =
      for b <- b_vars, into: <<>> do
        "(declare-fun #{b} () Int)\n(assert (>= #{b} 0))\n"
      end

    goal_asserts =
      for {g, pos} <- goal |> Stream.with_index, into: <<>> do
        "(assert (= (+" <>
          for {b, i} <- buttons |> Stream.with_index, pos in b, into: <<>> do
            " b#{i}"
          end <>
          ") #{g}))\n"
      end

    cmd =
      declaration <>
        goal_asserts <>
        "(minimize (+" <>
        Enum.join(b_vars) <>
        "))\n(check-sat)\n(get-objectives)\n"

    z3 = Port.open({:spawn, "z3 -in"}, [:binary])
    send(z3, {self(), {:command, cmd}})
    result = get_response(z3)
    send(z3, {self(), :close})
    receive do: ({^z3, :closed} -> :ok)
    result
  end

  defp get_response(z3, acc \\ "") do
    acc =
      receive do
        {^z3, {:data, data}} -> acc <> data
      end

    # expecting: "sat\n(objectives\n ((+ ...) RESULT)\n)\n"

    case Regex.run(~r/.* (\d+)\)\n\)\n/, acc) do
      nil -> get_response(z3, acc)
      [_, r] -> String.to_integer(r)
    end
  end
end

IO.stream(:line)
|> Task.async_stream(&Day10.solve/1, ordered: false)
|> Enum.sum_by(fn {:ok, r} -> r end)
|> IO.puts
