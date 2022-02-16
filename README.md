# Borsh binary serializer


[Borsh](https://borsh.io) is a binary serializer for security-critical projects.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `borsh_serializer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:borsh_serializer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/borsh_serializer>.

## Usage

```elixir
# Define struct:

defmodule Person do
  @moduledoc false
  defstruct id: 0, name: nil, email: nil

  def borsh_schema do
    [
      {:id, :u16},
      {:name, :string},
      {:email, :string}
    ]
  end
end

person = %Person{id: 123, name: "John", email: "john@gmail.com"}
# Encode into binary
bindata = Borsh.encode(person)
# Decode from binary
{person, ""} = Borsh.decode(bindata, Person)
```

## Data Types

To define schema you must implement `borsch_schema/0` method which returns a list of field definitions.
Each field definition is a tuple `{:field_name, :field_type}`.

Supported data types:

### Unsigned integers

Supported unsigned integers from 8 to 128 bytes size: `:u8`, `:u16`, `:u32`, `:u64`, `:u128`.

Example: `{:age, :u8}`, `{:counter, :u128}`


### Signed integers

Supported signed integers from 8 to 128 bytes size: `:i8`, `:i16`, `:i32`, `:i64`, `:i128`.

Example: `{:amount, :i32}`


### Float numbers
32 and 64 bytes size supported: `:f32`, `:f64`.

Example: `{:temp, :f32}`
