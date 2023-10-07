defmodule Demo do
  def run([]), do: IO.puts("end!")

  def run([head | tail]) do
    head |> IO.inspect

    tail |> run
  end
end

[1,2,3,4,5] |> Demo.run
