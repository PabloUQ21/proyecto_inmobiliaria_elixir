defmodule ProyectoInmobiliaria.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Inmobiliaria.PropertyRegistry},
      {Inmobiliaria.PropertySupervisor, []},
      Inmobiliaria.SesionUsuario
    ]

    opts = [
      strategy: :one_for_one,
      name: ProyectoInmobiliaria.Supervisor
    ]

    case Supervisor.start_link(children, opts) do
      {:ok, pid} ->
        Inmobiliaria.PropertyManager.cargar_propiedades()
        {:ok, pid}
      error ->
        error
    end
  end
end
