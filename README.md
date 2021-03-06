# Borsh binary serializer

![Tests](https://github.com/lazureykis/borsh_serializer/actions/workflows/elixir.yml/badge.svg?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/borsh_serializer.svg)](https://hex.pm/packages/borsh_serializer)

[Borsh](https://borsh.io) is a binary serializer for security-critical projects.

`borsh_serializer` supports base58-encoded binary fields (Solana public keys as strings).

## Installation

This library requires Elixir 1.11 or above.

Add `borsh_serializer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:borsh_serializer, "~> 1.0"},

    # Add :b58 if you need :base58 data type support
    {:b58, "~> 1.0.2"},
  ]
end
```

## Usage

```elixir
# Define struct and its borsh schema:

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

For a complex example, take a look at [Metaplex Metadata schema](https://github.com/lazureykis/borsh_serializer/blob/master/test/support/metaplex_schema.ex) I used for tests.

## Data Types

To define a schema, you must implement `borsh_schema/0` method, which returns a list of field definitions.
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
