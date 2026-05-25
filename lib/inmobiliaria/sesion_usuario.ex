defmodule Inmobiliaria.SesionUsuario do
  use Agent

  def start_link(_opts) do
    # Esto inicia el Agente con el estado inicial y le da nombre al proceso
    Agent.start_link(fn -> %{usuario: nil, rol: nil} end, name: __MODULE__)
  end
end
