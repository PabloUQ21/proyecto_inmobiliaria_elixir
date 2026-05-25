defmodule Inmobiliaria.PropertyManager do

  def existe_propiedad(id) do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      lineas = String.split(contenido, "\n", trim: true)
      Enum.any?(lineas, fn linea ->
        datos = String.split(linea, ";")
        Enum.at(datos, 0) == id
      end)
    else
      false
    end
  end

  def publicar_propiedad(id, tipo, modalidad, ubicacion, precio, habitaciones, area, propietario) do
    if existe_propiedad(id) do
      IO.puts("La propiedad ya existe")
    else
      propiedad = "#{id};#{tipo};#{modalidad};#{ubicacion};#{precio};#{habitaciones};#{area};disponible;#{propietario}\n"
      File.mkdir_p!("data")
      File.write!("data/properties.dat", propiedad, [:append])

      {:ok, _pid} = Inmobiliaria.PropertySupervisor.iniciar_propiedad(%{
        id: id, tipo: tipo, modalidad: modalidad, ubicacion: ubicacion,
        precio: precio, habitaciones: habitaciones, area: area,
        estado: "disponible", propietario: propietario
      })
      IO.puts("Propiedad publicada y proceso iniciado")
    end
  end

  def listar_propiedades do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      IO.puts(contenido)
    else
      IO.puts("No hay propiedades registradas.")
    end
  end

  def buscar_por_tipo(tipo_buscar) do
    filtrar_propiedades(1, tipo_buscar)
  end

  def buscar_por_ubicacion(ubicacion_buscar) do
    filtrar_propiedades(3, ubicacion_buscar)
  end

  def buscar_por_modalidad(modalidad_buscar) do
    filtrar_propiedades(2, modalidad_buscar)
  end

  def buscar_por_precio(precio_maximo) do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      lineas = String.split(contenido, "\n")
      maximo = String.to_integer(precio_maximo)

      Enum.each(lineas, fn linea ->
        datos = String.split(linea, ";")
        if length(datos) > 7 do
          precio = String.to_integer(Enum.at(datos, 4))
          estado = Enum.at(datos, 7)
          if precio <= maximo and estado == "disponible", do: IO.puts(linea)
        end
      end)
    end
  end

  defp filtrar_propiedades(indice, valor_buscar) do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      lineas = String.split(contenido, "\n")
      Enum.each(lineas, fn linea ->
        datos = String.split(linea, ";")
        if length(datos) > 7 do
          valor = Enum.at(datos, indice)
          estado = Enum.at(datos, 7)
          if valor == valor_buscar and estado == "disponible", do: IO.puts(linea)
        end
      end)
    end
  end

  def comprar_propiedad(id_propiedad, comprador) do
    case Inmobiliaria.Property.comprar(id_propiedad, comprador) do
      :ok -> actualizar_estado_archivo(id_propiedad, "vendida", comprador, "compra")
      _error -> IO.puts("Operación fallida. (Asegúrate de que la propiedad esté disponible y sea de venta)")
    end
  end

  def arrendar_propiedad(id_propiedad, arrendatario) do
    case Inmobiliaria.Property.arrendar(id_propiedad, arrendatario) do
      :ok -> actualizar_estado_archivo(id_propiedad, "arrendada", arrendatario, "arriendo")
      _error -> IO.puts("Operación fallida. (Asegúrate de que la propiedad esté disponible y sea de arriendo)")
    end
  end

  defp actualizar_estado_archivo(id_propiedad, nuevo_estado, cliente, operacion) do
    contenido = File.read!("data/properties.dat")
    lineas = String.split(contenido, "\n")

    nuevas_lineas = Enum.map(lineas, fn linea ->
      datos = String.split(linea, ";")
      if length(datos) > 7 and Enum.at(datos, 0) == id_propiedad do
        tipo = Enum.at(datos, 1)
        modalidad = Enum.at(datos, 2)
        ubicacion = Enum.at(datos, 3)
        precio = Enum.at(datos, 4)
        habitaciones = Enum.at(datos, 5)
        area = Enum.at(datos, 6)
        propietario = Enum.at(datos, 8)

        fecha = Date.to_string(Date.utc_today())
        resultado = "#{fecha};cliente=#{cliente};responsable=#{propietario};propiedad=#{id_propiedad};operacion=#{operacion};ubicacion=#{ubicacion};precio=#{precio};status=Completada\n"
        File.mkdir_p!("data")
        File.write("data/results.log", resultado, [:append])

        Inmobiliaria.UserManager.sumar_puntos(cliente, 10)
        Inmobiliaria.UserManager.sumar_puntos(propietario, 15)

        "#{id_propiedad};#{tipo};#{modalidad};#{ubicacion};#{precio};#{habitaciones};#{area};#{nuevo_estado};#{propietario}"
      else
        linea
      end
    end)

    File.write!("data/properties.dat", Enum.join(nuevas_lineas, "\n"))
  end

  def ver_resultados do
    if File.exists?("data/results.log") do
      contenido = File.read!("data/results.log")
      IO.puts(contenido)
    else
      IO.puts("No hay resultados registrados.")
    end
  end

  def estadisticas do
    if File.exists?("data/properties.dat") do
      contenido = File.read!("data/properties.dat")
      lineas = String.split(contenido, "\n")

      total = Enum.count(lineas, fn linea -> linea != "" end)
      vendidas = Enum.count(lineas, fn linea ->
        datos = String.split(linea, ";")
        length(datos) > 7 and Enum.at(datos, 7) == "vendida"
      end)
      arrendadas = Enum.count(lineas, fn linea ->
        datos = String.split(linea, ";")
        length(datos) > 7 and Enum.at(datos, 7) == "arrendada"
      end)

      disponibles = total - (vendidas + arrendadas)

      IO.puts("Total propiedades: #{total}")
      IO.puts("Vendidas: #{vendidas}")
      IO.puts("Arrendadas: #{arrendadas}")
      IO.puts("Disponibles: #{disponibles}")
    else
      IO.puts("No hay datos para mostrar estadísticas.")
    end
  end

end
