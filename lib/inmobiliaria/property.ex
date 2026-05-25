defmodule Inmobiliaria.Property do

  use GenServer


  # Arrancamos y registramos el proceso con el ID de la propiedad
  def start_link(propiedad) do
    name = {:via, Registry, {Inmobiliaria.PropertyRegistry, propiedad.id}}
    GenServer.start_link(__MODULE__, propiedad, name: name)
  end


  def init(propiedad) do
    {:ok, propiedad}
  end


  def ver_estado(id_propiedad) do
    GenServer.call(via_tuple(id_propiedad), :ver_estado)
  end


  def comprar(id_propiedad, comprador) do
    GenServer.call(via_tuple(id_propiedad), {:comprar, comprador})
  end


  def arrendar(id_propiedad, arrendatario) do
    GenServer.call(via_tuple(id_propiedad), {:arrendar, arrendatario})
  end


  # Función auxiliar para buscar el proceso en el Registry
  defp via_tuple(id_propiedad) do
    {:via, Registry, {Inmobiliaria.PropertyRegistry, id_propiedad}}
  end


  # --- Callbacks del GenServer ---

  def handle_call(:ver_estado, _from, propiedad) do
    {:reply, propiedad, propiedad}
  end


  def handle_call({:comprar, comprador}, _from, propiedad) do
    if propiedad.estado == "disponible" and propiedad.modalidad == "venta" do
      nueva = %{propiedad | estado: "vendida"}
      IO.puts("Propiedad #{propiedad.id} comprada por #{comprador}")
      {:reply, :ok, nueva}
    else
      IO.puts("La propiedad no está disponible para venta")
      {:reply, :error, propiedad}
    end
  end


  def handle_call({:arrendar, arrendatario}, _from, propiedad) do
    if propiedad.estado == "disponible" and propiedad.modalidad == "arriendo" do
      nueva = %{propiedad | estado: "arrendada"}
      IO.puts("Propiedad #{propiedad.id} arrendada por #{arrendatario}")
      {:reply, :ok, nueva}
    else
      IO.puts("La propiedad no está disponible para arriendo")
      {:reply, :error, propiedad}
    end
  end

end
