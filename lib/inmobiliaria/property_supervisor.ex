defmodule Inmobiliaria.PropertySupervisor do

  use DynamicSupervisor


  def start_link(_) do

    DynamicSupervisor.start_link(
      __MODULE__,
      :ok,
      name: __MODULE__
    )

  end


  def init(:ok) do

    DynamicSupervisor.init(strategy: :one_for_one)

  end


  def iniciar_propiedad(propiedad) do

    child_spec =

      %{
        id: Inmobiliaria.Property,
        start:
          {
            Inmobiliaria.Property,
            :start_link,
            [propiedad]
          }
      }

    DynamicSupervisor.start_child(__MODULE__, child_spec)

  end

end
