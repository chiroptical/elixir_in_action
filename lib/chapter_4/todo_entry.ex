defmodule Chapter4.TodoEntry do
  alias Chapter4.TodoEntry

  @type t :: %TodoEntry{
          date: Date.t(),
          title: String.t()
        }
  defstruct date: nil, title: nil
end
