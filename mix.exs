defmodule Rbac.MixProject do
  use Mix.Project

  def project do
    [
      app: :rbac,
      version: "1.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description: "Helper functions for Role Based Access Control (RBAC)",
      package: package(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def cli do
    [
      preferred_envs: [
        c: :test,
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Httpoison for HTTP Requests: hex.pm/packages/httpoison
      {:httpoison, "~> 3.0.0", override: true},

      # Decoding JSON data: https://hex.pm/packages/jason
      {:jason, "~> 1.0"},

      # auth_plug for client_id/1: hex.pm/packages/auth_plug
      {:auth_plug, "~> 1.6"},

      # Useful functions: github.com/dwyl/useful
      {:useful, "~> 1.15.0"},

      # Check test coverage
      {:excoveralls, "~> 0.18.5", only: :test},
      # Create Documentation for publishing Hex.docs:
      {:ex_doc, "~> 0.28.2", only: :dev},
      # Keeping code consistent: github.com/rrrene/credo
      {:credo, "~> 1.7.19", only: [:dev], runtime: false}
    ]
  end

  defp package() do
    [
      files: ~w(lib LICENSE mix.exs README.md),
      name: "rbac",
      licenses: ["GPL-2.0-or-later"],
      maintainers: ["dwyl & friends"],
      links: %{"GitHub" => "https://github.com/dwyl/rbac"}
    ]
  end

  defp aliases do
    [
      c: ["coveralls.html"],
      ci: ["coveralls.json"]
    ]
  end
end
