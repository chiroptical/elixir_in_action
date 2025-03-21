defmodule Chapter5.Calculator do
  def start do
    spawn(fn ->
      loop(0)
    end)
  end

  defp loop(state) do
    next =
      receive do
        {:add, val} ->
          state + val

        {:sub, val} ->
          state - val

        {:mul, val} ->
          state * val

        {:div, val} ->
          state / val

        {:val, pid} ->
          send(pid, {:response, state})
          state

        msg ->
          IO.puts("invalid request #{inspect(msg)}")
      end

    loop(next)
  end

  def value(server) do
    send(server, {:val, self()})

    receive do
      {:response, value} ->
        value
    after
      1000 ->
        IO.puts("Unable to get value from calculator")
        0
    end
  end

  def add(server, value) do
    send(server, {:add, value})
  end

  def sub(server, value) do
    send(server, {:sub, value})
  end

  def mul(server, value) do
    send(server, {:mul, value})
  end

  def div(server, value) do
    send(server, {:div, value})
  end
end
