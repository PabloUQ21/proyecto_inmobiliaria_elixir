defmodule Inmobiliaria.SesionUsuario do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{usuario: nil, rol: nil} end, name: __MODULE__)
  end
end
