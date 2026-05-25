defmodule Inmobiliaria.Location do

  def es_valida?(ubicacion) do
    unless File.exists?("data/locations.dat") do
      File.mkdir_p!("data")
      File.write!("data/locations.dat", "Armenia\nBogota\nMedellin\nCali\nPereira\n")
    end

    contenido = File.read!("data/locations.dat")

    ubicaciones =
      String.split(contenido, "\n", trim: true)
      |> Enum.map(&String.downcase/1)

    Enum.member?(ubicaciones, String.downcase(ubicacion))
  end

end
