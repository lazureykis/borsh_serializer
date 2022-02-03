defmodule Borsh do
  @moduledoc """
  Documentation for `Borsh`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Borsh.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule MyStruct do
  defstruct id: 0, name: "John", email: "Doe"
end

@schema = %{
  MyStruct => [
    {:id, :u16},
    {:name, :string},
    {:email, :string}
  ]
}
