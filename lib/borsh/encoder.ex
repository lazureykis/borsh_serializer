defmodule Borsh.Encoder do
  @moduledoc """
  Encodes Elixir data structures into binary data.
  """
  def encode_struct(data) when is_struct(data) do
    encode_field({:struct, data.__struct__}, data)
  end

  # Struct

  def encode_field({:struct, module}, data) do
    struct_schema = module.borsh_schema()

    struct_schema
    |> Enum.reduce(<<>>, fn field_def, acc ->
      {field_name, type} = field_def
      field_data = Map.fetch!(data, field_name)

      acc <> encode_field(type, field_data)
    end)
  end

  # Enum
  def encode_field({:enum, values}, value) do
    index = Enum.find_index(values, &(&1 == value))
    <<index::little-integer-size(8)>>
  end

  # Unsigned integer

  def encode_field(:u8, num) do
    <<num::little-integer-size(8)>>
  end

  def encode_field(:u16, num) do
    <<num::little-integer-size(16)>>
  end

  def encode_field(:u32, num) do
    <<num::little-integer-size(32)>>
  end

  def encode_field(:u64, num) do
    <<num::little-integer-size(64)>>
  end

  def encode_field(:u128, num) do
    <<num::little-integer-size(128)>>
  end

  # Signed integer

  def encode_field(:i8, num) do
    <<num::little-integer-signed-size(8)>>
  end

  def encode_field(:i16, num) do
    <<num::little-integer-signed-size(16)>>
  end

  def encode_field(:i32, num) do
    <<num::little-integer-signed-size(32)>>
  end

  def encode_field(:i64, num) do
    <<num::little-integer-signed-size(64)>>
  end

  def encode_field(:i128, num) do
    <<num::little-integer-signed-size(128)>>
  end

  # Float

  def encode_field(:f32, num) do
    <<num::little-float-size(32)>>
  end

  def encode_field(:f64, num) do
    <<num::little-float-size(64)>>
  end

  # String

  def encode_field(:string, string) do
    # :erlang.binary_to_list(string)
    len = byte_size(string)
    <<len::little-integer-size(32), string::binary>>
  end

  # Binary

  def encode_field({:binary, len}, data) when is_binary(data) do
    <<data::binary-size(len)>>
  end

  def encode_field({:base58, len}, value) when is_binary(value) do
    data = Base58.decode(value)
    <<data::binary-size(len)>>
  end

  def encode_field({:base64, len}, value) when is_binary(value) do
    data = Base.decode64!(value)
    <<data::binary-size(len)>>
  end

  # Fixed sized array
  def encode_field({:array, field_type, schema_array_length}, data) do
    array_len = length(data)

    if schema_array_length != array_len do
      raise "Invalid array length"
    end

    Enum.reduce(data, <<>>, fn field_value, acc ->
      acc <> encode_field(field_type, field_value)
    end)
  end

  # Dynamic sized array
  def encode_field({:array, field_type}, data) do
    array_len = length(data)
    array_len_encoded = encode_field(:u32, array_len)

    Enum.reduce(data, array_len_encoded, fn field_value, acc ->
      acc <> encode_field(field_type, field_value)
    end)
  end

  # Optional field
  def encode_field({:option, field_def}, data) do
    if data do
      encode_field(:u8, 1) <> encode_field(field_def, data)
    else
      encode_field(:u8, 0)
    end
  end
end
