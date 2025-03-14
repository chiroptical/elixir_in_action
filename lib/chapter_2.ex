defmodule Chapter2 do
  # module attribute, inlined at compile time
  @pi 3.14159

  @spec area(number) :: number
  def area(r), do: r * r * @pi

  def atoms do
    _a = :an_atom
    _b = :"an atom with spaces"
    # AnAtom is a valid atom and converted to Elixir.AnAtom at compile time
    _c = AnAtom == Elixir.AnAtom
    # booleans are just atoms :true or :false
    _d = true == true
    # another special atom
    _e = nil == nil
    x = {1, :ok, "derp"}
    {_f, _g, _h} = x
    y = Map.new([{1, "hello"}, {2, "world"}])
    _i = y[1]
    _j = y[0] == nil
    # Map.get/3 can provide a default value other than nil
    _k = Map.get(y, 0) == nil

    _l = %{:name => "Bob", :age => 25}
    # is equivalent if keys are atoms
    m = %{name: "Bob", age: 25}
    # can update existing fields of a map, but can't add new ones
    _n = %{m | age: 26}

    # binary syntax is the same as in Erlang, if the total bytes in the binary is not a multiple of 8
    # it is stored as a bitstring
    _binary = <<12::8>>
    _bitstring = <<1::1, 0::1>>
    # concatenate binaries with <>/2

    _interpolation = "Look at Bob #{m}"

    # ~ [65, 66, 67]
    _charlist = ~c"ABC"

    square = fn x -> x * x end
    # apparently explained in Chapter 3, but square(1) doesn't work
    IO.puts(square.(1))

    p = fn x -> IO.puts(x) end

    Enum.each(
      [1, 2, 3],
      # or inline the function, or `&IO.puts/1`
      p
    )

    _lam = fn x, y, z -> x * y * z end
    # or `&(&1 * &2 * &3)`

    # 1 in range == true, see Range module
    _range = 1..2

    # Keyword module contains utilities for handling [{x: y}] aka proplists
    # MapSet for sets
    # Date, Time, DateTime, and NaiveDateTime for times
    _date = ~D[2025-03-13]

    _iolist = [[[~c"He"], "llo,"], " worl", ["d!"]]
    # IO.puts(iolist) would print "Hello, world!"

    # Supports strict and weak equality, aka === versus ==
  end
end
