defmodule ProyectoInmobiliaria.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Inmobiliaria.PropertyRegistry},
      {Inmobiliaria.PropertySupervisor, []},

      %{
        id: :cargador_propiedades,
        start: {Task, :start_link, [fn -> Inmobiliaria.PropertyManager.cargar_propiedades() end]}
      }
    ]

    opts = [
      strategy: :one_for_one,
      name: ProyectoInmobiliaria.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
