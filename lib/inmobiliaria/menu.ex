defmodule Inmobiliaria.Menu do

  def iniciar do
    IO.puts("\n===== SISTEMA INMOBILIARIO =====")
    IO.puts("1. Registrar / Login")
    IO.puts("2. Publicar propiedad (Solo Vendedores/Arrendadores)")
    IO.puts("3. Listar propiedades")
    IO.puts("4. Buscar propiedades")
    IO.puts("5. Comprar propiedad (Solo Clientes)")
    IO.puts("6. Arrendar propiedad (Solo Clientes)")
    IO.puts("7. Ver estadísticas")
    IO.puts("8. Ver resultados (Historial)")
    IO.puts("9. Ver ranking global")
    IO.puts("10. Enviar mensaje a propiedad")
    IO.puts("11. Ver mensajes")
    IO.puts("12. Salir")

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()
    ejecutar(opcion)
  end

  def ejecutar("1") do
    usuario = IO.gets("Usuario: ") |> String.trim()
    password = IO.gets("Password: ") |> String.trim()
    rol = IO.gets("Rol (cliente/vendedor/arrendador): ") |> String.trim()

    Inmobiliaria.UserManager.connect(usuario, password, rol)
    iniciar()
  end

  def ejecutar("2") do
    sesion = Agent.get(Inmobiliaria.SesionUsuario, & &1)
    if sesion.rol == "vendedor" or sesion.rol == "arrendador" do
      id = IO.gets("ID: ") |> String.trim()
      tipo = IO.gets("Tipo (casa/apartamento/oficina/lote): ") |> String.trim()
      modalidad = IO.gets("Modalidad (venta/arriendo): ") |> String.trim()
      ubicacion = IO.gets("Ubicación: ") |> String.trim()
      precio = IO.gets("Precio: ") |> String.trim()
      habitaciones = IO.gets("Habitaciones: ") |> String.trim()
      area = IO.gets("Área: ") |> String.trim()
      propietario = sesion.usuario # Se usa el usuario logueado automáticamente

      if Inmobiliaria.Location.es_valida?(ubicacion) do
        Inmobiliaria.PropertyManager.publicar_propiedad(id, tipo, modalidad, ubicacion, precio, habitaciones, area, propietario)
      else
        IO.puts("Error: Ubicación '#{ubicacion}' no es válida.")
      end
    else
      IO.puts("Acceso denegado: Solo vendedores o arrendadores pueden publicar.")
    end
    iniciar()
  end

  def ejecutar("3") do
    Inmobiliaria.PropertyManager.listar_propiedades()
    iniciar()
  end

  def ejecutar("4") do
    IO.puts("\n--- Opciones de Búsqueda ---")
    IO.puts("1. Buscar por Tipo | 2. Por Ubicación | 3. Por Modalidad | 4. Precio Máximo")
    sub_opcion = IO.gets("Seleccione un filtro (1-4): ") |> String.trim()
    case sub_opcion do
      "1" -> Inmobiliaria.PropertyManager.buscar_por_tipo(IO.gets("Tipo: ") |> String.trim())
      "2" -> Inmobiliaria.PropertyManager.buscar_por_ubicacion(IO.gets("Ubicación: ") |> String.trim())
      "3" -> Inmobiliaria.PropertyManager.buscar_por_modalidad(IO.gets("Modalidad: ") |> String.trim())
      "4" -> Inmobiliaria.PropertyManager.buscar_por_precio(IO.gets("Precio máximo: ") |> String.trim())
      _ -> IO.puts("Opción inválida")
    end
    iniciar()
  end

  def ejecutar("5") do
    sesion = Agent.get(Inmobiliaria.SesionUsuario, & &1)
    if sesion.rol == "cliente" do
      id = IO.gets("ID propiedad: ") |> String.trim()
      Inmobiliaria.PropertyManager.comprar_propiedad(id, sesion.usuario)
    else
      IO.puts("Acceso denegado: Solo clientes pueden comprar.")
    end
    iniciar()
  end

  def ejecutar("6") do
    sesion = Agent.get(Inmobiliaria.SesionUsuario, & &1)
    if sesion.rol == "cliente" do
      id = IO.gets("ID propiedad: ") |> String.trim()
      Inmobiliaria.PropertyManager.arrendar_propiedad(id, sesion.usuario)
    else
      IO.puts("Acceso denegado: Solo clientes pueden arrendar.")
    end
    iniciar()
  end

  def ejecutar("7"), do: (Inmobiliaria.PropertyManager.estadisticas(); iniciar())
  def ejecutar("8"), do: (Inmobiliaria.PropertyManager.ver_resultados(); iniciar())
  def ejecutar("9"), do: (Inmobiliaria.UserManager.ranking(); iniciar())

  def ejecutar("10") do
    propiedad = IO.gets("ID de la propiedad a contactar: ") |> String.trim()
    cliente = Agent.get(Inmobiliaria.SesionUsuario, & &1.usuario) || IO.gets("Tu usuario: ") |> String.trim()
    mensaje = IO.gets("Mensaje: ") |> String.trim()
    Inmobiliaria.MessageManager.enviar_mensaje(propiedad, cliente, mensaje)
    iniciar()
  end

  def ejecutar("11"), do: (Inmobiliaria.MessageManager.ver_mensajes(); iniciar())
  def ejecutar("12"), do: IO.puts("Saliendo del sistema...")
  def ejecutar(_), do: (IO.puts("Opción inválida"); iniciar())
end
