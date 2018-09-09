defmodule NearbyBook.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nearby_book,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {NearbyBook.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # phoenix 相关
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      # absinthe 相关
      {:absinthe, "~> 1.4.5"},
      {:absinthe_plug, "~> 1.4.2"},
      {:absinthe_ecto, "~> 0.1.3"},
      {:absinthe_phoenix, "~> 1.4.2"},
      # ecto_enum Ecto extension to support enums in models
      {:ecto_enum, "~> 1.1.0"},
      {:poison, "~> 3.1.0"},
      # comeonin Password hashing library for the Elixir programming language
      {:comeonin, "~> 4.0"},
      # bcrypt_elixir Bcrypt password hashing for Elixir
      {:bcrypt_elixir, "~> 1.0"},
      # kronkyKronky bridges the gap between Ecto and Absinthe GraphQL by listing validation messages in a mutation payload.
      {:kronky, "~> 0.4.0"},
      # secure_random Convenience library for random base64 strings modeled after my love for Ruby's SecureRandom
      {:secure_random, "~> 0.5"},
      # ecto paginate
      {:scrivener_ecto, "~> 1.3.0"},
      {:cors_plug, "~> 1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
