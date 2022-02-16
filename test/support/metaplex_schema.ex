defmodule Creator do
  @moduledoc false
  defstruct address: nil,
            share: 0,
            verified: 0

  def borsh_schema do
    [
      {:address, {:base58, 32}},
      {:verified, :u8},
      {:share, :u8}
    ]
  end
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
end

defmodule Metadata do
  @keys [
    "Uninitialized",
    "EditionV1",
    "MasterEditionV1",
    "ReservationListV1",
    "MetadataV1",
    "ReservationListV2",
    "MasterEditionV2",
    "EditionMarker"
  ]

  @moduledoc false
  defstruct key: "Uninitialized",
            update_authority: [],
            mint: [],
            data: %Data{},
            primary_sale_happened: 0,
            is_mutable: 0,
            edition_nonce: nil

  def borsh_schema do
    [
      {:key, {:enum, @keys}},
      {:update_authority, {:base58, 32}},
      {:mint, {:base58, 32}},
      {:data, {:struct, Data}},
      {:primary_sale_happened, :u8},
      {:is_mutable, :u8},
      {:edition_nonce, {:option, :u8}}
    ]
  end
end
