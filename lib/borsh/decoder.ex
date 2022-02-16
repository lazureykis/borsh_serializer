defmodule Borsh.Decoder do
  @moduledoc """
  Decodes binary data into Elixir struct.
  """

  def decode_struct(data, module) when is_binary(data) and is_atom(module) do
    read_value(data, {:struct, module})
  end

  # Unsigned

  def read_value(<<num::little-integer-size(8), rest::binary>>, :u8), do: {num, rest}
  def read_value(<<num::little-integer-size(16), rest::binary>>, :u16), do: {num, rest}
  def read_value(<<num::little-integer-size(32), rest::binary>>, :u32), do: {num, rest}
  def read_value(<<num::little-integer-size(64), rest::binary>>, :u64), do: {num, rest}
  def read_value(<<num::little-integer-size(128), rest::binary>>, :u128), do: {num, rest}

  # Integer

  def read_value(<<num::little-integer-signed-size(8), rest::binary>>, :i8), do: {num, rest}
  def read_value(<<num::little-integer-signed-size(16), rest::binary>>, :i16), do: {num, rest}
  def read_value(<<num::little-integer-signed-size(32), rest::binary>>, :i32), do: {num, rest}
  def read_value(<<num::little-integer-signed-size(64), rest::binary>>, :i64), do: {num, rest}
  def read_value(<<num::little-integer-signed-size(128), rest::binary>>, :i128), do: {num, rest}

  # Float

  def read_value(<<num::little-float-size(32), rest::binary>>, :f32), do: {num, rest}
  def read_value(<<num::little-float-size(64), rest::binary>>, :f64), do: {num, rest}

  # String

  def read_value(<<string_length::little-integer-size(32), data::binary>>, :string) do
    <<string::binary-size(string_length), rest::binary>> = <<data::binary>>
    {string, rest}
  end

  # Binary

  def read_value(<<data::binary>>, {:binary, byte_size}) do
    <<value::binary-size(byte_size), rest::binary>> = <<data::binary>>
    {value, rest}
  end

  def read_value(<<data::binary>>, {:base58, byte_size}) do
    <<value_encoded::binary-size(byte_size), rest::binary>> = <<data::binary>>
    value = Base58.encode(value_encoded)
    {value, rest}
  end

  def read_value(<<data::binary>>, {:base64, byte_size}) do
    <<value_encoded::binary-size(byte_size), rest::binary>> = <<data::binary>>
    value = Base.encode64(value_encoded)
    {value, rest}
  end

  # Struct

  # def read_value(<<data::binary>>, {:struct, module}) do
  #   {value, rest} = decode_struct(data, module)
  #   {value, rest}
  # end

  def read_value(<<data::binary>>, {:struct, module}) do
    struct_schema = module.borsh_schema()
    result = struct(module)

    struct_schema
    |> Enum.reduce({result, data}, fn {field_name, type}, {result, data} ->
      {value, data_rest} = read_value(data, type)

      result = Map.put(result, field_name, value)
      {result, data_rest}
    end)
  end

  # Fixed sized array
  def read_value(<<data::binary>>, {:array, field_type, array_length}) do
    Enum.reduce(1..array_length, {[], data}, fn _, {values, data} ->
      {value, rest} = read_value(data, field_type)
      {values ++ [value], rest}
    end)
  end

  # Dynamic sized array
  def read_value(<<data::binary>>, {:array, field_type}) do
    <<array_length::little-integer-size(32), rest::binary>> = data

    read_value(rest, {:array, field_type, array_length})
  end

  # Optional field
  def read_value(<<has_value::little-integer-size(8)>>, {:option, _field_type})
      when has_value == 0 do
    {nil, <<>>}
  end

  def read_value(<<has_value::little-integer-size(8), rest::binary>>, {:option, _field_type})
      when has_value == 0 do
    {nil, rest}
  end

  def read_value(<<has_value::little-integer-size(8), rest::binary>>, {:option, field_type})
      when has_value == 1 do
    read_value(rest, field_type)
  end
end
