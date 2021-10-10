defmodule SpaceTravel do
  @directions ["N", "E", "S", "W"]
  @valid_commands ["L", "R", "M"]
  @first_index_direction 0
  @last_index_direction 3

  def start(_, []), do: nil

  def start(board, [head | tail]) do
    {x, y, direction, commands} = head

    probe = %{x: x, y: y, direction: nil}

    probe
    |> validate_direction(direction)
    |> change_position(commands)
    |> validate_position(board)
    |> show_position

    start(board, tail)
  end

  def show_position(probe),
    do: IO.puts("#{probe.x} #{probe.y} #{Enum.at(@directions, probe.direction)}")

  def change_position(probe, []), do: probe

  def change_position(probe, [head | tail]) do
    head in @valid_commands or raise "\"#{head}\" não é um comando válido."

    change_position(action(probe, head), tail)
  end

  def validate_direction(probe, direction) do
    direction in @directions or raise "A direção \"#{direction}\" é inválida."

    %{probe | direction: Enum.find_index(@directions, fn x -> x == direction end)}
  end

  def validate_position(probe, board) do
    (probe.x <= elem(board, 0) and probe.x >= 0 and probe.y <= elem(board, 1) and probe.y > 0) or
      raise "Ops! parece que perdemos contato com a sonda :-(. Verifique se os parâmetros enviados são válidos ou se não ultrapassam o limite da malha."

    probe
  end

  def action(probe = %{direction: 0}, "L"), do: %{probe | direction: @last_index_direction}
  def action(probe = %{direction: 3}, "R"), do: %{probe | direction: @first_index_direction}
  def action(probe, "L"), do: %{probe | direction: probe.direction - 1}
  def action(probe, "R"), do: %{probe | direction: probe.direction + 1}
  def action(probe = %{direction: 0}, "M"), do: %{probe | y: probe.y + 1}
  def action(probe = %{direction: 2}, "M"), do: %{probe | y: probe.y - 1}
  def action(probe = %{direction: 1}, "M"), do: %{probe | x: probe.x + 1}
  def action(probe = %{direction: 3}, "M"), do: %{probe | x: probe.x - 1}
  def action(probe, _), do: probe
end

SpaceTravel.start(
  {5, 5},
  [
    {1, 2, "N", ["L", "M", "L", "M", "L", "M", "L", "M", "M"]},
    {3, 3, "E", ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]},
    {2, 2, "W", ["M", "R", "M", "M", "R"]},
    {5, 5, "N", ["L", "M", "M", "M"]},
    {0, 0, "W", ["M", "M"]}
  ]
)
