defmodule Docker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :docker,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Docker.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.14.0"},
      {:tesla, "~> 1.2.1"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Bearice Ren"],
      links: %{"Github" => "https://github.com/bearice/elixir-docker"}
    ]
  end

end
