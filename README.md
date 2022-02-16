# Borsh binary serializer


[Borsh](https://borsh.io) is a binary serializer for security-critical projects. Supports base58 encoded binary fields (Solana public keys as strings).

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
      {:wallet, {:base58, 32}}
    ]
  end
end

person = %Person{id: 123, name: "John", wallet: "Hj1bMz4GZyRANWxBEzm6hh29Mk54f9YMh8mBiWy1PUXE"}
# Encode into binary
bindata = Borsh.encode(person)
# Decode from binary
{person, ""} = Borsh.decode(bindata, Person)
```

## Data Types

To define schema you must implement `borsch_schema/0` method which returns a list of field definitions.
Each field definition is a tuple `{:field_name, :field_type}`.

Supported data types with examples:

```elixir
# Unsigned integers
:u8, :u16, :u32, :u64, :u128
# Examples:
{:age, :u8}
{:counter, :u128}


# Signed integers
:i8, :i16, :i32, :i64, :i128
# Example:
{:amount, :i32}


# Float numbers
:f32, :f64
# Example:
{:temp, :f32}


# String type:
:string
# Example:
{:username, :string}


# Enum values are encoded as u8 and are zero-indexed
{:enum, values}
# Example:
{:color, {:enum, ["red", "green", "blue"]}}


# Fixed size array
{:array, item_type, array_size}
# Example:
{:numbers, {:array, :u32, 5}}


# Dynamic size array
{:array, :item_type}
# Example:
{:tags, {:array, :string}}


# Optional fields
{:option, field_definition}
# Examples:
{:username, {:option, :string}}
{:tags, {:option, {:array, :string}}}


# Embedded Structs
{:struct, module}
# Examples:
{:user, {:struct, MyUserStructModule}}

# Binary Data
{:binary, byte_size}, {:base64, byte_size}, {:base58, byte_size}
# Examples:
{:rawdata, {:binary, 256}}
{:pubkey, {:base58, 32}}
```
