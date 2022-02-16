defmodule Person do
  @moduledoc false
  defstruct id: 123, name: "John", email: "john@gmail.com"

  def borsh_schema do
    [
      {:id, :u16},
      {:name, :string},
      {:email, :string}
    ]
  end
end

defmodule Borsh.SimpleTest do
  use ExUnit.Case
  @moduledoc false

  test "encode person" do
    person = %Person{}

    actual = Borsh.encode(person)

    expected =
      <<123, 0, 4, 0, 0, 0, 74, 111, 104, 110, 14, 0, 0, 0, 106, 111, 104, 110, 64, 103, 109, 97,
        105, 108, 46, 99, 111, 109>>

    assert expected == actual
  end

  test "decode person" do
    data =
      <<123, 0, 4, 0, 0, 0, 74, 111, 104, 110, 14, 0, 0, 0, 106, 111, 104, 110, 64, 103, 109, 97,
        105, 108, 46, 99, 111, 109>>

    {person, rest} = Borsh.decode(data, Person)

    assert person == %Person{}
    assert rest == ""
  end
end
