defmodule Borsh.MetaplexTest do
  use ExUnit.Case
  @moduledoc false

  test "encode creator" do
    creator = %Creator{
      address: "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf",
      share: 100,
      verified: 0
    }

    encoded = Borsh.encode(creator)

    expected =
      <<178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53,
        107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 0, 100>>

    assert encoded == expected
  end

  test "decode creator" do
    data =
      <<178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53,
        107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 0, 100>>

    assert {decoded, ""} = Borsh.decode(data, Creator)

    creator = %Creator{
      address: "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf",
      share: 100,
      verified: 0
    }

    assert decoded == creator
  end

  test "encode data" do
    creator = %Creator{
      address: "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf",
      share: 100,
      verified: 0
    }

    data = %Data{
      name: "Token #1",
      symbol: "",
      uri: "https://somewhere.com",
      seller_fee_basis_points: 500,
      creators: [creator]
    }

    encoded = Borsh.encode(data)

    expected =
      <<8, 0, 0, 0, 84, 111, 107, 101, 110, 32, 35, 49, 0, 0, 0, 0, 21, 0, 0, 0, 104, 116, 116,
        112, 115, 58, 47, 47, 115, 111, 109, 101, 119, 104, 101, 114, 101, 46, 99, 111, 109, 244,
        1, 1, 1, 0, 0, 0, 178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126,
        57, 187, 19, 53, 107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 0, 100>>

    assert encoded == expected
  end

  test "encode metadata" do
    address = "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf"

    creator = %Creator{address: address, share: 100, verified: 0}

    data = %Data{
      name: "Token #1",
      symbol: "",
      uri: "https://somewhere.com",
      seller_fee_basis_points: 500,
      creators: [creator]
    }

    metadata = %Metadata{
      key: "Uninitialized",
      update_authority: address,
      mint: address,
      data: data,
      primary_sale_happened: 1,
      is_mutable: 0,
      edition_nonce: nil
    }

    encoded = Borsh.encode(metadata)

    expected =
      <<0, 178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53,
        107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 178, 140, 22, 31, 109, 202,
        113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178,
        150, 110, 195, 11, 81, 142, 188, 8, 0, 0, 0, 84, 111, 107, 101, 110, 32, 35, 49, 0, 0, 0,
        0, 21, 0, 0, 0, 104, 116, 116, 112, 115, 58, 47, 47, 115, 111, 109, 101, 119, 104, 101,
        114, 101, 46, 99, 111, 109, 244, 1, 1, 1, 0, 0, 0, 178, 140, 22, 31, 109, 202, 113, 117,
        157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178, 150, 110,
        195, 11, 81, 142, 188, 0, 100, 1, 0, 0>>

    assert encoded == expected
  end

  test "decode metadata" do
    data =
      <<0, 178, 140, 22, 31, 109, 202, 113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53,
        107, 14, 33, 104, 242, 178, 150, 110, 195, 11, 81, 142, 188, 178, 140, 22, 31, 109, 202,
        113, 117, 157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178,
        150, 110, 195, 11, 81, 142, 188, 8, 0, 0, 0, 84, 111, 107, 101, 110, 32, 35, 49, 0, 0, 0,
        0, 21, 0, 0, 0, 104, 116, 116, 112, 115, 58, 47, 47, 115, 111, 109, 101, 119, 104, 101,
        114, 101, 46, 99, 111, 109, 244, 1, 1, 1, 0, 0, 0, 178, 140, 22, 31, 109, 202, 113, 117,
        157, 158, 95, 157, 57, 209, 126, 57, 187, 19, 53, 107, 14, 33, 104, 242, 178, 150, 110,
        195, 11, 81, 142, 188, 0, 100, 1, 0, 0>>

    assert {decoded, ""} = Borsh.decode(data, Metadata)

    address = "D1yTsfytXgUFaiHh9gFJXPwxFFSvV63XVFN4ti2C56nf"

    creator = %Creator{address: address, share: 100, verified: 0}

    data = %Data{
      name: "Token #1",
      symbol: "",
      uri: "https://somewhere.com",
      seller_fee_basis_points: 500,
      creators: [creator]
    }

    metadata = %Metadata{
      key: "Uninitialized",
      update_authority: address,
      mint: address,
      data: data,
      primary_sale_happened: 1,
      is_mutable: 0,
      edition_nonce: nil
    }

    assert metadata == decoded
  end
end
