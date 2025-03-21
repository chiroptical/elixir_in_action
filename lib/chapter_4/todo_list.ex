defmodule Chapter4.TodoList do
  alias Chapter4.TodoEntry
  alias Chapter4.TodoList

  @type t :: %TodoList{
          next_id: integer(),
          entries: %{integer() => %TodoEntry{}}
        }
  defstruct next_id: 1, entries: %{}

  @spec new([TodoEntry.t()]) :: TodoList.t()
  def new(entries \\ []) do
    todolist = %TodoList{}

    Enum.reduce(
      entries,
      todolist,
      fn entry, acc ->
        new_entries = Map.put(acc.entries, acc.next_id, entry)
        %TodoList{next_id: acc.next_id + 1, entries: new_entries}
      end
    )
  end

  @spec add_entry(TodoList.t(), TodoEntry.t()) :: TodoList.t()
  def add_entry(todolist, %TodoEntry{} = entry) do
    %TodoList{
      next_id: todolist.next_id + 1,
      entries:
        Map.put(
          todolist.entries,
          todolist.next_id,
          entry
        )
    }
  end

  @spec entries(TodoList.t(), Date.t()) :: TodoList.t()
  def entries(todolist, date) do
    todolist.entries
    |> Map.to_list()
    |> Enum.filter(fn {_, entry} -> entry.date === date end)
  end

  @spec entries(TodoList.t(), integer()) :: TodoList.t()
  def delete_entry(todolist, id) do
    new_entries = Map.delete(todolist.entries, id)
    %TodoList{todolist | entries: new_entries}
  end

  @spec update_entry(TodoList.t(), integer(), (TodoEntry.t() -> TodoEntry.t())) :: TodoList.t()
  def update_entry(todolist, id, update_fn) do
    case Map.fetch(todolist.entries, id) do
      :error ->
        todolist

      {:ok, entry} ->
        new_entry = update_fn.(entry)
        new_entries = Map.put(todolist.entries, id, new_entry)
        # We can use this syntax because `entries` exists in the map
        %TodoList{todolist | entries: new_entries}
    end
  end
end

defimpl String.Chars, for: TodoList do
  def to_string(_) do
    "#TodoList"
  end
end

defimpl Collectable, for: TodoList do
  alias Chapter4.TodoList

  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
end

defmodule Chapter4.TodoList.CsvImporter do
  alias Chapter4.TodoList
  alias Chapter4.TodoEntry
  @spec import(Path.t()) :: TodoList.t()
  def import(filename) do
    File.stream!(filename)
    |> Stream.map(fn line ->
      [date_string, title] =
        String.trim_trailing(line)
        |> String.split(",")

      date = Date.from_iso8601!(date_string)
      %TodoEntry{date: date, title: title}
    end)
    |> TodoList.new()
  end
end
