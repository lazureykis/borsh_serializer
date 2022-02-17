defmodule Borsh.MixProject do
  use Mix.Project

  @source_url "https://github.com/lazureykis/borsh_serializer"

  def project do
    [
      app: :borsh_serializer,
      name: "Borsh",
      description: "Borsh is a binary serializer for security-critical projects.",
      source_url: @source_url,
      package: package(),
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      docs: [
        main: "readme",
        # logo: "logo.png",
        extras: [
          "README.md"
          # "CHANGELOG.md"
        ]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Pavel Lazureykis"],
      licenses: ["MIT"],
      links: %{
        # Changelog: @source_url <> "/blob/master/CHANGELOG.md",
        GitHub: @source_url
      }
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    []
  end

  defp deps do
    [
      # {:b58, "~> 1.0.2"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
