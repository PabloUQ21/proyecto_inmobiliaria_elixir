defmodule Inmobiliaria.Menu do

  def iniciar do
    IO.puts("\n===== SISTEMA INMOBILIARIO =====")
    IO.puts("1. Registrar / Login")
    IO.puts("2. Publicar propiedad")
    IO.puts("3. Listar propiedades")
    IO.puts("4. Buscar propiedades")
    IO.puts("5. Comprar propiedad")
    IO.puts("6. Arrendar propiedad")
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
    id = IO.gets("ID: ") |> String.trim()
    tipo = IO.gets("Tipo (casa/apartamento/oficina/lote): ") |> String.trim()
    modalidad = IO.gets("Modalidad (venta/arriendo): ") |> String.trim()
    ubicacion = IO.gets("Ubicación: ") |> String.trim()
    precio = IO.gets("Precio: ") |> String.trim()
    habitaciones = IO.gets("Habitaciones: ") |> String.trim()
    area = IO.gets("Área: ") |> String.trim()
    propietario = IO.gets("Propietario: ") |> String.trim()

    
    if Inmobiliaria.Location.es_valida?(ubicacion) do
      Inmobiliaria.PropertyManager.publicar_propiedad(
        id, tipo, modalidad, ubicacion, precio, habitaciones, area, propietario
      )
    else
      IO.puts("Error: Ubicación '#{ubicacion}' no es válida. Revise locations.dat")
    end

    iniciar()
  end


  def ejecutar("3") do
    Inmobiliaria.PropertyManager.listar_propiedades()
    iniciar()
  end


  def ejecutar("4") do
    IO.puts("\n--- Opciones de Búsqueda ---")
    IO.puts("1. Buscar por Tipo")
    IO.puts("2. Buscar por Ubicación")
    IO.puts("3. Buscar por Modalidad (venta / arriendo)")
    IO.puts("4. Buscar por Precio Máximo")

    sub_opcion = IO.gets("Seleccione un filtro (1-4): ") |> String.trim()

    case sub_opcion do
      "1" ->
        tipo = IO.gets("Tipo a buscar: ") |> String.trim()
        Inmobiliaria.PropertyManager.buscar_por_tipo(tipo)
      "2" ->
        ubicacion = IO.gets("Ubicación a buscar: ") |> String.trim()
        Inmobiliaria.PropertyManager.buscar_por_ubicacion(ubicacion)
      "3" ->
        modalidad = IO.gets("Modalidad a buscar: ") |> String.trim()
        Inmobiliaria.PropertyManager.buscar_por_modalidad(modalidad)
      "4" ->
        precio = IO.gets("Precio máximo: ") |> String.trim()
        Inmobiliaria.PropertyManager.buscar_por_precio(precio)
      _ ->
        IO.puts("Opción de búsqueda inválida")
    end

    iniciar()
  end


  def ejecutar("5") do
    id = IO.gets("ID propiedad: ") |> String.trim()
    comprador = IO.gets("Comprador: ") |> String.trim()
    Inmobiliaria.PropertyManager.comprar_propiedad(id, comprador)
    iniciar()
  end


  def ejecutar("6") do
    id = IO.gets("ID propiedad: ") |> String.trim()
    arrendatario = IO.gets("Arrendatario: ") |> String.trim()
    Inmobiliaria.PropertyManager.arrendar_propiedad(id, arrendatario)
    iniciar()
  end


  def ejecutar("7") do
    Inmobiliaria.PropertyManager.estadisticas()
    iniciar()
  end


  def ejecutar("8") do
    Inmobiliaria.PropertyManager.ver_resultados()
    iniciar()
  end


  def ejecutar("9") do
    Inmobiliaria.UserManager.ranking()
    iniciar()
  end


  def ejecutar("10") do
    propiedad = IO.gets("ID de la propiedad a contactar: ") |> String.trim()
    cliente = IO.gets("Tu nombre de usuario: ") |> String.trim()
    mensaje = IO.gets("Mensaje: ") |> String.trim()

    Inmobiliaria.MessageManager.enviar_mensaje(propiedad, cliente, mensaje)
    iniciar()
  end


  def ejecutar("11") do
    Inmobiliaria.MessageManager.ver_mensajes()
    iniciar()
  end


  def ejecutar("12") do
    IO.puts("Saliendo del sistema...")
  end


  def ejecutar(_) do
    IO.puts("Opción inválida")
    iniciar()
  end

end
