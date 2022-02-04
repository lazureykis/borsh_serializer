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
  defstruct address: [],
            share: 0,
            verified: 0

  def borsh_schema do
    [
      {:address, {:binary, _bytes = 32}},
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
      {:update_authority, {:binary, 32}},
      {:mint, {:binary, 32}},
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

    Borsh.Encoder.encode_struct(person)
    |> IO.inspect(label: "DATA")
  end

  def test_encoder_with_creator do
    address =
      Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
      |> IO.inspect(label: "Metadata address")

    IO.puts("byte_size(address) #{byte_size(address)}")

    creator =
      %Creator{address: address, share: 100_000, verified: 0} |> IO.inspect(label: "creator")

    Borsh.Encoder.encode_struct(creator)
    |> IO.inspect(label: "DATA")
  end

  def test_encoder_with_data do
    address =
      Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
      |> IO.inspect(label: "Metadata address")

    IO.puts("byte_size(address) #{byte_size(address)}")

    creator =
      %Creator{address: address, share: 100_000, verified: 0} |> IO.inspect(label: "creator")

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
    address =
      Base58.decode("D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf")
      |> IO.inspect(label: "Metadata address")

    IO.puts("byte_size(address) #{byte_size(address)}")

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
    |> IO.inspect(label: "DATA")
  end
end
