defmodule Borsh.Decoder do
  def decode_struct(data, module) when is_binary(data) and is_atom(module) do
    struct_schema = module.borsh_schema()
    # struct_schema = full_schema |> Map.fetch!(struct.__struct__)

    # encode_field(struct_schema, data)
    ret = struct(module)

    struct_schema
    |> Enum.reduce({ret, data}, fn field_def, {ret, data} ->
      {field_name, type} = field_def |> IO.inspect(label: "field schema")
      field_name |> IO.inspect(label: "field_name")
      # field_data = Map.fetch!(data, field_name) |> IO.inspect(label: "field_data")

      {value, data_rest} = read_value(data, type)
      ret = Map.put(ret, field_name, value)
      {ret, data_rest}
    end)
  end

  # Struct

  # def decode_field({:struct, struct_name}, data) do
  #   struct_schema = apply(struct_name, :borsh_schema, [])

  #   struct_schema
  #   |> Enum.reduce(<<>>, fn field_def, acc ->
  #     {field_name, type} = field_def |> IO.inspect(label: "field schema")
  #     field_name |> IO.inspect(label: "field_name")
  #     field_data = Map.fetch!(data, field_name) |> IO.inspect(label: "field_data")

  #     acc <> encode_field(type, field_data)
  #   end)
  # end

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

  # # String

  def read_value(<<string_length::little-integer-size(32), data::binary>>, :string) do
    <<string::binary-size(string_length), rest::binary>> = <<data::binary>>
    {string, rest}
  end

  # # Binary

  # def encode_field({:binary, len}, data) do
  #   <<data::binary-size(len)>>
  # end

  # # Fixed sized array
  # def encode_field({:array, field_type, schema_array_length}, data) do
  #   array_len = length(data)

  #   if schema_array_length != array_len do
  #     raise "Invalid array length"
  #   end

  #   array_len_encoded = encode_field(:u32, array_len)

  #   Enum.reduce(data, array_len_encoded, fn field_value, acc ->
  #     if is_struct(field_value) do
  #       acc <> encode_struct(field_value)
  #     else
  #       encoded_el = encode_field(field_type, field_value)
  #       acc <> encoded_el
  #     end
  #   end)
  # end

  # # Dynamic sized array
  # def encode_field({:array, field_type}, data) do
  #   array_len = length(data)
  #   array_len_encoded = encode_field(:u32, array_len)

  #   Enum.reduce(data, array_len_encoded, fn field_value, acc ->
  #     if is_struct(field_value) do
  #       acc <> encode_struct(field_value)
  #     else
  #       encoded_el = encode_field(field_type, field_value)
  #       acc <> encoded_el
  #     end
  #   end)
  # end

  # # optional field
  # def encode_field({:option, field_def}, data) do
  #   if data do
  #     encode_field(:u8, 1) <> encode_field(field_def, data)
  #   else
  #     encode_field(:u8, 0)
  #   end
  # end
end
