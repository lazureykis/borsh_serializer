defmodule Borsh do
  @moduledoc """
  Documentation for `Borsh`.
  """

  @doc """
  Encodes Elixir struct into binary data.
  """
  @spec encode(struct()) :: binary()
  def encode(struct) do
    Borsh.Encoder.encode_struct(struct)
  end

  @doc """
  Decodes binary data into Elixir struct. Returns tuple with a struct and the rest of bytes.
  """
  @spec decode(binary(), atom()) :: {struct(), binary()}
  def decode(data, module) when is_atom(module) and is_binary(data) do
    Borsh.Decoder.decode_struct(data, module)
  end
end
