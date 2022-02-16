defmodule Creator do
  @moduledoc false
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
  @moduledoc false
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
  @moduledoc false
  defstruct key: 0,
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
