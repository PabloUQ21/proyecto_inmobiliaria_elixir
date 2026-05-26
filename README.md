# Sistema Distribuido de Gestión Inmobiliaria en Elixir



Proyecto final de Programación III. Simula el flujo real de una inmobiliaria aplicando concurrencia, supervisión (OTP), persistencia y comunicación entre procesos usando GenServer en Elixir.



## Cómo ejecutar el proyecto



1. Clona este repositorio o descarga los archivos.

2. Abre una terminal en la carpeta raíz del proyecto.

3. Ejecuta el siguiente comando para iniciar el entorno de Elixir:

   ```bash

   iex.bat -S mix
   Inmobiliaria.Menu.iniciar()


   
Una vez iniciado el entorno interactivo, puede interactuar con el sistema mediante los siguientes flujos de comandos base:

*   Conexión / Registro: `connect [nombre] [clave] [cliente/vendedor/arrendador]`
*   Publicar Inmueble: `publish_property tipo=[casa/apto] modalidad=[venta/arriendo] ubicacion=[Ciudad] precio=[valor] habitaciones=[num] area=[num]`
*   Consultar Inventario: `list_properties` o `consultar_estado [id_propiedad]`
*   Mensajería: `send_message [id_propiedad] [texto del mensaje]`
*   Cierre de Operación: `buy_property [id_propiedad]` o `rent_property [id_propiedad]`

## Estructura del Almacenamiento (data/)

El sistema autogenera y gestiona los siguientes archivos de persistencia:
*   users.dat: Credenciales, roles y puntos acumulados del ranking.
*   properties.dat: Características e ID único de los inmuebles.
*   messages.log: Historial de mensajes de interés enviados por clientes.
*   results.log: Registro definitivo de compras y arriendos exitosos.
