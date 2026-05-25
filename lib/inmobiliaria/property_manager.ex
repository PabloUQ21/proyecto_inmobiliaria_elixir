defmodule Inmobiliaria.PropertyManager do

  def existe_propiedad(id) do
    if File.exists?("data/properties.dat") do
      File.stream!("data/properties.dat")
      |> Enum.any?(fn linea ->
        datos = String.split(linea, ";", trim: true)
        Enum.at(datos, 0) == id
      end)
    else
      false
    end
  end

  def publicar_propiedad(id, tipo, modalidad, ubicacion, precio, habitaciones, area, propietario) do
    if existe_propiedad(id) do
      IO.puts("Error: La propiedad con ID #{id} ya existe.")
    else
      propiedad = "#{id};#{tipo};#{modalidad};#{ubicacion};#{precio};#{habitaciones};#{area};disponible;#{propietario}\n"
      File.mkdir_p!("data")
      File.write!("data/properties.dat", propiedad, [:append])

      Inmobiliaria.PropertySupervisor.iniciar_propiedad(%{
        id: id, tipo: tipo, modalidad: modalidad, ubicacion: ubicacion,
        precio: precio, habitaciones: habitaciones, area: area,
        estado: "disponible", propietario: propietario
      })
      IO.puts("Propiedad publicada exitosamente.")
    end
  end

  def listar_propiedades do
    if File.exists?("data/properties.dat") do
      IO.puts(File.read!("data/properties.dat"))
    else
      IO.puts("No hay propiedades registradas.")
    end
  end


  def obtener_tipos_disponibles, do: obtener_columna_unica(1)
  def obtener_modalidades_disponibles, do: obtener_columna_unica(2)
  def obtener_ubicaciones_disponibles, do: obtener_columna_unica(3)

  defp obtener_columna_unica(indice) do
    if File.exists?("data/properties.dat") do
      File.stream!("data/properties.dat")
      |> Enum.map(fn linea -> String.split(linea, ";", trim: true) |> Enum.at(indice) end)
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&String.trim/1)
      |> Enum.uniq()
    else
      []
    end
  end

  def buscar_por_tipo(tipo), do: filtrar_propiedades(1, tipo)
  def buscar_por_ubicacion(ubi), do: filtrar_propiedades(3, ubi)
  def buscar_por_modalidad(mod), do: filtrar_propiedades(2, mod)

  def buscar_por_precio(precio_maximo_str) do
    case Integer.parse(precio_maximo_str) do
      {precio_max, _} ->
        procesar_busqueda(fn datos ->
          case Integer.parse(Enum.at(datos, 4, "0")) do
            {precio_actual, _} -> precio_actual <= precio_max
            :error -> false
          end
        end)
      :error ->
        IO.puts("Error: Ingrese un número válido para el precio.")
    end
  end

  defp filtrar_propiedades(indice, valor_buscar) do
    valor_norm = String.downcase(String.trim(valor_buscar))
    procesar_busqueda(fn datos ->
      valor_archivo = String.downcase(String.trim(Enum.at(datos, indice, "")))
      valor_archivo == valor_norm
    end)
  end

  defp procesar_busqueda(filtro_fn) do
    if File.exists?("data/properties.dat") do
      resultados = File.stream!("data/properties.dat")
      |> Enum.filter(fn linea ->
        datos = String.split(linea, ";", trim: true)
        length(datos) >= 8 and Enum.at(datos, 7) == "disponible" and filtro_fn.(datos)
      end)

      if Enum.empty?(resultados) do
        IO.puts("No se encontraron propiedades disponibles con esos criterios.")
      else
        Enum.each(resultados, &IO.puts/1)
      end
    else
      IO.puts("No hay datos de propiedades disponibles.")
    end
  end

  def comprar_propiedad(id_propiedad, comprador) do
    ejecutar_operacion(id_propiedad, :comprar, comprador, "vendida", "compra")
  end

  def arrendar_propiedad(id_propiedad, arrendatario) do
    ejecutar_operacion(id_propiedad, :arrendar, arrendatario, "arrendada", "arriendo")
  end

  defp ejecutar_operacion(id, operacion, cliente, nuevo_estado, log_op) do
    case Registry.lookup(Inmobiliaria.PropertyRegistry, id) do
      [{pid, _}] ->
        case GenServer.call(pid, {operacion, cliente}) do
          :ok ->
            actualizar_estado_archivo(id, nuevo_estado, cliente, log_op)
            IO.puts("Operación de #{log_op} realizada con éxito.")
          _ ->
            IO.puts("Error: La propiedad no está disponible para #{log_op}.")
        end
      [] ->
        IO.puts("Error: La propiedad #{id} no está en memoria. Intente cargar el sistema nuevamente.")
    end
  end

  defp actualizar_estado_archivo(id_propiedad, nuevo_estado, cliente, operacion) do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      lineas = String.split(contenido, "\n", trim: true)

      nuevas_lineas = Enum.map(lineas, fn linea ->
        datos = String.split(linea, ";", trim: true)
        if length(datos) >= 9 and Enum.at(datos, 0) == id_propiedad do
          lista = List.replace_at(datos, 7, nuevo_estado)
          propietario = Enum.at(datos, 8)

          fecha = Date.to_string(Date.utc_today())
          resultado = "#{fecha};cliente=#{cliente};responsable=#{propietario};propiedad=#{id_propiedad};operacion=#{operacion};status=Completada\n"
          File.write!("data/results.log", resultado, [:append])

         
          Inmobiliaria.UserManager.sumar_puntos(cliente, 10)
          Inmobiliaria.UserManager.sumar_puntos(propietario, 15)

          Enum.join(lista, ";")
        else
          linea
        end
      end)

      File.write!("data/properties.dat", Enum.join(nuevas_lineas, "\n") <> "\n")
    end
  end

  def ver_resultados do
    if File.exists?("data/results.log"), do: IO.puts(File.read!("data/results.log")), else: IO.puts("No hay logs.")
  end

  def estadisticas do
    if File.exists?("data/properties.dat") do
      lineas = File.read!("data/properties.dat") |> String.split("\n", trim: true)
      vendidas = Enum.count(lineas, fn l -> String.split(l, ";") |> Enum.at(7) == "vendida" end)
      arrendadas = Enum.count(lineas, fn l -> String.split(l, ";") |> Enum.at(7) == "arrendada" end)
      IO.puts("Vendidas: #{vendidas} | Arrendadas: #{arrendadas}")
    else
      IO.puts("No hay datos de propiedades.")
    end
  end

  def cargar_propiedades do
    if File.exists?("data/properties.dat") do
      File.stream!("data/properties.dat")
      |> Enum.each(fn linea ->
        datos = String.split(linea, ";", trim: true)
        if length(datos) >= 9 and Enum.at(datos, 7) == "disponible" do
          id = Enum.at(datos, 0)
          if Registry.lookup(Inmobiliaria.PropertyRegistry, id) == [] do
            Inmobiliaria.PropertySupervisor.iniciar_propiedad(%{
              id: id, tipo: Enum.at(datos, 1), modalidad: Enum.at(datos, 2),
              ubicacion: Enum.at(datos, 3), precio: Enum.at(datos, 4),
              habitaciones: Enum.at(datos, 5), area: Enum.at(datos, 6),
              estado: "disponible", propietario: Enum.at(datos, 8)
            })
          end
        end
      end)
    end
  end
end
