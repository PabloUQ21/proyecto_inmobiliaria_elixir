defmodule ProyectoInmobiliaria.MixProject do

  use Mix.Project


  def project do

    [
      app: :proyecto_inmobiliaria,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]

  end


  def application do

    [
      extra_applications: [:logger],
      mod: {ProyectoInmobiliaria.Application, []}
    ]

  end


  defp deps do

    [
    ]

  end

end
