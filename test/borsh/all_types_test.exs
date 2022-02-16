defmodule StructWithAllTypes do
  use ExUnit.Case
  @moduledoc false
  @enum_values [
    "one",
    "two",
    "three"
  ]

  defstruct u8: 0,
            u16: 0,
            u32: 0,
            u64: 0,
            u128: 0,
            i8: 0,
            i16: 0,
            i32: 0,
            i64: 0,
            i128: 0,
            f32: 0.0,
            f64: 0.0,
            enum: "one",
            str: "",
            optional_u8: nil,
            optional_string: "",
            binary_8bytes: <<1, 2, 3, 4, 5, 6, 7, 8>>,
            base58_8bytes: "",
            base64_8bytes: "",
            strings_array_fixed_size: [],
            strings_array_dynamic_size: []

  def borsh_schema do
    [
      {:u8, :u8},
      {:u16, :u16},
      {:u32, :u32},
      {:u64, :u64},
      {:u128, :u128},
      {:i8, :i8},
      {:i16, :i16},
      {:i32, :i32},
      {:i64, :i64},
      {:i128, :i128},
      {:f32, :f32},
      {:f64, :f64},
      {:enum, {:enum, @enum_values}},
      {:str, :string},
      {:optional_u8, {:option, :u8}},
      {:optional_string, {:option, :string}},
      {:binary_8bytes, {:binary, 8}},
      {:base58_8bytes, {:base58, 8}},
      {:base64_8bytes, {:base64, 8}},
      {:strings_array_fixed_size, {:array, :string, 3}},
      {:strings_array_dynamic_size, {:array, :string}}
    ]
  end

  test "all basic data types" do
    obj = %StructWithAllTypes{
      u8: 17,
      u16: 1050,
      u32: 126_358,
      u64: 23_804_729,
      u128: 20_745_023_987_523_094_857_234,
      i8: -5,
      i16: -203,
      i32: 123_712_097,
      i64: -12_368_126_712,
      i128: 283_974_012_437,
      f32: 2.5,
      f64: -874.23,
      enum: "two",
      str: "string value",
      optional_u8: nil,
      optional_string: "optional value",
      binary_8bytes: <<11, 2, 53, 24, 56, 67, 87, 78>>,
      base58_8bytes: "2qoFZ7fMSM3",
      base64_8bytes: "CwI1GDhDV04=",
      strings_array_fixed_size: ["some", "values", "here"],
      strings_array_dynamic_size: ["and", "here"]
    }

    encoded = Borsh.encode(obj)
    {decoded, ""} = Borsh.decode(encoded, StructWithAllTypes)
    assert decoded == obj
  end
end
