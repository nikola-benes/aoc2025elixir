bool_to_int = fn true -> 1; false -> 0 end

{_, part1, part2} =
  for line <- IO.stream(:line), reduce: {50, 0, 0} do {state, part1, part2} ->
    <<dir::utf8>> <> val = line
    {val, _} = Integer.parse(val)
    val = dir == ?L && -val || val

    new_state = Integer.mod(state + val, 100)
    to_zero = bool_to_int.(new_state == 0)

    clicks = if val < 0 do
      z = abs(Integer.floor_div(state + val, 100))
      z + to_zero - bool_to_int.(z > 0 and state == 0)
    else
      div(state + val, 100)
    end

    {new_state, part1 + to_zero, part2 + clicks}
  end

IO.puts("#{part1}")
IO.puts("#{part2}")
