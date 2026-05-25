defmodule Inmobiliaria.MessageManager do

  def enviar_mensaje(propiedad, cliente, mensaje) do
    fecha = Date.to_string(Date.utc_today())
    linea = "#{fecha};#{propiedad};#{cliente};#{mensaje}\n"

    File.mkdir_p!("data")
    File.write!("data/messages.log", linea, [:append])

    IO.puts("Mensaje enviado exitosamente a la propiedad #{propiedad}")
  end

  def ver_mensajes do
    if File.exists?("data/messages.log") do
      contenido = File.read!("data/messages.log")
      IO.puts("\n=== HISTORIAL DE MENSAJES ===")
      IO.puts(contenido)
      IO.puts("=============================\n")
    else
      IO.puts("No hay mensajes registrados aún.")
    end
  end

end
