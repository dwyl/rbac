defmodule Rbac.MixProject do
  use Mix.Project

  def project do
    [
      app: :rbac,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Helper functions for Role Based Access Control (RBAC)",
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
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
      # Check test coverage
      {:excoveralls, "~> 0.13.1", only: :test},

      # Create Documentation for publishing Hex.docs:
      {:ex_doc, "~> 0.22.2", only: :dev},
      {:credo, "~> 1.4", only: [:dev], runtime: false}
    ]
  end

  defp package() do
    [
      files: ~w(lib LICENSE mix.exs README.md),
      name: "rbac",
      licenses: ["GNU GPL v2.0"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/rbac"}
    ]
  end
end
