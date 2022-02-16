defmodule Person do
  defstruct id: 123, name: "John", email: "john@gmail.com"

  def borsh_schema do
    [
      {:id, :u16},
      {:name, :string},
      {:email, :string}
    ]
  end
end

defmodule Creator do
  defstruct address: nil,
            share: 0,
            verified: 0

  def borsh_schema do
    [
      # {:address, {:binary, _bytes = 32}},
      {:address, {:base58, 32}},
      {:verified, :u8},
      {:share, :u8}
    ]
  end

  # [
  #   Creator,
  #   {
  #     kind: 'struct',
  #     fields: [
  #       ['address', 'pubkeyAsString'],
  #       ['verified', 'u8'],
  #       ['share', 'u8'],
  #     ],
  #   },
  # ],
end

defmodule Data do
  defstruct name: "",
            symbol: "",
            uri: "",
            seller_fee_basis_points: 0,
            creators: []

  def borsh_schema do
    [
      {:name, :string},
      {:symbol, :string},
      {:uri, :string},
      {:seller_fee_basis_points, :u16},
      {:creators, {:option, {:array, {:struct, Creator}}}}
    ]
  end

  # [
  #   Data,
  #   {
  #     kind: 'struct',
  #     fields: [
  #       ['name', 'string'],
  #       ['symbol', 'string'],
  #       ['uri', 'string'],
  #       ['sellerFeeBasisPoints', 'u16'],
  #       ['creators', { kind: 'option', type: [Creator] }],
  #     ],
  #   },
  # ],
end

defmodule Metadata do
  defstruct key: 0,
            authority: [],
            update_authority: [],
            mint: [],
            data: %Data{},
            primary_sale_happened: 0,
            is_mutable: 0,
            edition_nonce: nil

  def borsh_schema do
    [
      {:key, :u8},
      # {:update_authority, {:binary, 32}},
      {:update_authority, {:base58, 32}},
      # {:mint, {:binary, 32}},
      {:mint, {:base58, 32}},
      {:data, {:struct, Data}},
      {:primary_sale_happened, :u8},
      {:is_mutable, :u8},
      {:edition_nonce, {:option, :u8}}
    ]
  end

  #
  # Metadata,
  #   {
  #     kind: 'struct',
  #     fields: [
  #       ['key', 'u8'],
  #       ['updateAuthority', 'pubkeyAsString'],
  #       ['mint', 'pubkeyAsString'],
  #       ['data', Data],
  #       ['primarySaleHappened', 'u8'], // bool
  #       ['isMutable', 'u8'], // bool
  #       ['editionNonce', { kind: 'option', type: 'u8' }],
  #     ],
  #   },
end

defmodule Borsh do
  @moduledoc """
  Documentation for `Borsh`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Borsh.hello()
      :world

  """
  def hello do
    :world
  end

  def test_encoder_with_person do
    person = %Person{} |> IO.inspect(label: "person")

    actual =
      Borsh.Encoder.encode_struct(person)
      |> IO.inspect(label: "DATA")

    expected =
      <<123, 0, 4, 0, 0, 0, 74, 111, 104, 110, 14, 0, 0, 0, 106, 111, 104, 110, 64, 103, 109, 97,
        105, 108, 46, 99, 111, 109>>

    expected == actual
  end

  def test_decoder_with_person do
    data =
      <<123, 0, 4, 0, 0, 0, 74, 111, 104, 110, 14, 0, 0, 0, 106, 111, 104, 110, 64, 103, 109, 97,
        105, 108, 46, 99, 111, 109>>

    {person, rest_data} =
      Borsh.Decoder.decode_struct(data, Person) |> IO.inspect(label: "DECODE RESULT")

    # expected = %Person{}
    IO.puts("CORRECT: #{person == %Person{}}")
    {person, rest_data}
  end

  def test_encoder_with_creator do
    # address =
    #   Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
    #   |> IO.inspect(label: "Metadata address")

    # IO.puts("byte_size(address) #{byte_size(address)}")

    creator =
      %Creator{
        address: "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf",
        share: 100_000,
        verified: 0
      }
      |> IO.inspect(label: "creator")

    Borsh.Encoder.encode_struct(creator)
    |> IO.inspect(label: "DATA")
  end

  def test_encoder_with_data do
    # address =
    #   Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
    #   |> IO.inspect(label: "Metadata address")

    # IO.puts("byte_size(address) #{byte_size(address)}")

    creator =
      %Creator{
        address: "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf",
        share: 100_000,
        verified: 0
      }
      |> IO.inspect(label: "creator")

    data = %Data{
      name: "Token #1",
      symbol: "",
      uri: "https://somethere.com",
      seller_fee_basis_points: 500,
      creators: [creator]
    }

    Borsh.Encoder.encode_struct(data)
    |> IO.inspect(label: "DATA")
  end

  def test_encoder_with_metadata do
    address = "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf"
    # Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
    # |> IO.inspect(label: "Metadata address")

    # IO.puts("byte_size(address) #{byte_size(address)}")

    creator =
      %Creator{address: address, share: 100_000, verified: 0} |> IO.inspect(label: "creator")

    data = %Data{
      name: "Token #1",
      symbol: "",
      uri: "https://somethere.com",
      seller_fee_basis_points: 500,
      creators: [creator]
    }

    metadata = %Metadata{
      key: 0,
      authority: address,
      update_authority: address,
      mint: address,
      data: data,
      primary_sale_happened: 1,
      is_mutable: 0,
      edition_nonce: nil
    }

    Borsh.Encoder.encode_struct(metadata)
    |> IO.inspect(label: "DATA", limit: 1000)
  end

  def test_decoder_with_metadata do
    data =
      <<0, 178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53,
        107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 178, 140, 22, 31, 109, 202,
        113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178,
        150, 110, 195, 11, 81, 142, 188, 8, 0, 0, 0, 84, 111, 107, 101, 110, 32, 35, 49, 0, 0, 0,
        0, 21, 0, 0, 0, 104, 116, 116, 112, 115, 58, 47, 47, 115, 111, 109, 101, 116, 104, 101,
        114, 101, 46, 99, 111, 109, 244, 1, 1, 1, 0, 0, 0, 178, 140, 22, 31, 109, 202, 113, 117,
        157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178, 150, 110,
        195, 11, 81, 142, 188, 0, 160, 1, 0, 0>>

    # data =
    #   <<0, 68, 49, 121, 84, 115, 102, 121, 116, 88, 103, 85, 70, 97, 105, 72, 104, 57, 103, 70,
    #     74, 88, 80, 119, 120, 70, 70, 83, 118, 86, 54, 51, 88, 68, 49, 121, 84, 115, 102, 121,
    #     116, 88, 103, 85, 70, 97, 105, 72, 104, 57, 103, 70, 74, 88, 80, 119, 120, 70, 70, 83,
    #     118, 86, 54, 51, 88, 8, 0, 0, 0, 84, 111, 107, 101, 110, 32, 35, 49, 0, 0, 0, 0, 21, 0, 0,
    #     0, 104, 116, 116, 112, 115, 58, 47, 47, 115, 111, 109, 101, 116, 104, 101, 114, 101, 46,
    #     99, 111, 109, 244, 1, 1, 1, 0, 0, 0, 80, 65, 122, 67, 103, 104, 89, 84, 52, 78, 102, 53,
    #     82, 51, 99, 67, 117, 102, 119, 103, 117, 51, 99, 100, 76, 82, 116, 55, 113, 82, 121, 81,
    #     0, 160, 1, 0, 0>>

    {_metadata, ""} =
      Borsh.Decoder.decode_struct(data, Metadata) |> IO.inspect(label: "DECODE RESULT")
  end

  def test_real_metadata do
  end
end
