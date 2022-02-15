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

  def read_value(<<data::binary>>, {:struct, module}) do
    {value, rest} = decode_struct(data, module)
    {value, rest}
  end

  # Fixed sized array
  def read_value(<<data::binary>>, {:array, field_type, array_length}) do
    Enum.reduce(1..array_length, {_values = [], data}, fn _, {values, data} ->
      {value, rest} = read_value(data, field_type)
      value |> IO.inspect(label: "VALUE READ")
      {values ++ [value], rest}
      # if is_struct(field_value) do
      #   decode_struct(field_value, field_type)
      # else
      #   read_value(field_type)
      # end
    end)
    |> IO.inspect(label: "ARRAY VALUES")
  end

  # Dynamic sized array
  def read_value(<<data::binary>>, {:array, field_type}) do
    <<array_length::little-integer-size(32), rest::binary>> = data

    read_value(rest, {:array, field_type, array_length})
  end

  # Optional field
  # def read_value(data, {:option, _field_type}) do
  #   IO.inspect(data, label: "OPTION FIELD")
  #   nil
  # end

  # when has_value == 0 do
  def read_value(<<has_value::little-integer-size(8), _data::binary>>, {:option, _field_type})
      when has_value == 0 do
    {<<>>, nil}
  end

  def read_value(<<has_value::little-integer-size(8)>>, {:option, _field_type})
      when has_value == 0 do
    {<<>>, nil}
  end

  def read_value(<<has_value::little-integer-size(8), data::binary>>, {:option, field_type})
      when has_value == 1 do
    read_value(data, field_type)
  end
end
