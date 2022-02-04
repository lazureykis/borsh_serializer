defmodule Borsh.Encoder do
  def encode(struct) when is_struct(struct) do
    struct.__struct__ |> IO.inspect(label: "struct.__struct__")

    struct_schema = apply(struct.__struct__, :borsh_schema, [])
    # struct_schema = full_schema |> Map.fetch!(struct.__struct__)

    struct_schema
    |> Enum.reduce(<<>>, fn field_def, acc ->
      {field_name, type} = field_def |> IO.inspect(label: "field schema")
      field_name |> IO.inspect(label: "field_name")
      field_data = Map.fetch!(struct, field_name) |> IO.inspect(label: "field_data")

      acc <> encode_field(type, field_data)
    end)
  end

  # Unsigned

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

  # Integer

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

  def encode_field({:binary, len}, data) do
    <<data::binary-size(len)>>
  end

  # Dynamic sized array
  def encode_field({:array, field_type}, data) do
    array_len = length(data)
    array_len_encoded = encode_field(:u32, array_len)

    Enum.reduce(data, array_len_encoded, fn field_value, acc ->
      if is_struct(field_value) do
        acc <> encode(field_value)
      else
        encoded_el = encode_field(field_type, field_value)
        acc <> encoded_el
      end
    end)
  end
end
