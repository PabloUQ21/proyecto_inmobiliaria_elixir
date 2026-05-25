defmodule Inmobiliaria.UserManager do

  def registrar(usuario, rol, password) do
    linea = usuario <> ";" <> rol <> ";" <> password <> ";0\n"
    File.write("data/users.dat", linea, [:append])
    IO.puts("Usuario registrado")
  end

  def existe_usuario(usuario) do
    if File.exists?("data/users.dat") do
      contenido = File.read!("data/users.dat")
      lineas = String.split(contenido, "\n", trim: true)
      Enum.any?(lineas, fn linea ->
        datos = String.split(linea, ";")
        length(datos) > 0 and Enum.at(datos, 0) == usuario
      end)
    else
      false
    end
  end

  def validar_password(usuario, password) do
    contenido = File.read!("data/users.dat")
    lineas = String.split(contenido, "\n", trim: true)
    Enum.any?(lineas, fn linea ->
      datos = String.split(linea, ";")
      length(datos) > 2 and Enum.at(datos, 0) == usuario and Enum.at(datos, 2) == password
    end)
  end

  def connect(usuario, password, rol) do
    if existe_usuario(usuario) do
      if validar_password(usuario, password) do
        IO.puts("Login exitoso")
      else
        IO.puts("Password incorrecta")
      end
    else
      registrar(usuario, rol, password)
    end
  end

  def listar_usuarios do
    if File.exists?("data/users.dat") do
      contenido = File.read!("data/users.dat")
      IO.puts(contenido)
    end
  end

  def sumar_puntos(usuario_buscar, puntos_sumar) do
    if File.exists?("data/users.dat") do
      contenido = File.read!("data/users.dat")
      lineas = String.split(contenido, "\n")
      nuevas_lineas = Enum.map(lineas, fn linea ->
        datos = String.split(linea, ";")
        if length(datos) > 3 and Enum.at(datos, 0) == usuario_buscar do
          usuario = Enum.at(datos, 0)
          rol = Enum.at(datos, 1)
          password = Enum.at(datos, 2)
          puntos_actuales = String.to_integer(String.trim(Enum.at(datos, 3)))
          nuevos_puntos = puntos_actuales + puntos_sumar
          "#{usuario};#{rol};#{password};#{nuevos_puntos}"
        else
          linea
        end
      end)
      File.write!("data/users.dat", Enum.join(nuevas_lineas, "\n"))
    end
  end

  def ranking do
    if File.exists?("data/users.dat") do
      contenido = File.read!("data/users.dat")
      lineas = String.split(contenido, "\n", trim: true)
      usuarios = Enum.map(lineas, fn linea ->
        datos = String.split(linea, ";")
        if length(datos) > 3 do
          %{
            usuario: Enum.at(datos, 0),
            puntos: String.to_integer(String.trim(Enum.at(datos, 3)))
          }
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.sort_by(& &1.puntos, :desc)

      IO.puts("\n=== RANKING GLOBAL DE USUARIOS ===")
      Enum.each(usuarios, fn u ->
        IO.puts("#{u.usuario} - #{u.puntos} puntos")
      end)
      IO.puts("==================================\n")
    else
      IO.puts("No hay usuarios registrados aún.")
    end
  end

end
