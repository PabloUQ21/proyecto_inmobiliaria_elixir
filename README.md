# 🏢 Sistema Distribuido de Gestión Inmobiliaria en Elixir

Proyecto final para el curso de **Programación III**. Este sistema simula el funcionamiento de una inmobiliaria virtual aplicando principios avanzados de concurrencia, supervisión (OTP), y comunicación entre procesos usando el ecosistema de Elixir.

## 🚀 Características Principales

El sistema está diseñado para manejar múltiples usuarios y procesos simultáneos, cumpliendo con los siguientes requerimientos técnicos:

* **Roles de Usuario:** Soporte para `cliente`, `vendedor` y `arrendador`.
* **Procesos Independientes:** Cada propiedad publicada funciona como un proceso `GenServer` aislado, supervisado por un `DynamicSupervisor`.
* **Concurrencia Segura:** Uso de `Registry` para el enrutamiento de mensajes y prevención de condiciones de carrera (ej. dos clientes intentando comprar la misma casa al mismo tiempo).
* **Persistencia de Datos:** Almacenamiento en archivos de texto plano (`.dat` y `.log`) para usuarios, propiedades, ubicaciones, mensajes e historial de operaciones.
* **Sistema de Puntos y Ranking:** Gamificación integrada donde los usuarios ganan puntos por comprar, vender o arrendar propiedades.
* **Mensajería Interna:** Comunicación directa entre clientes y publicadores de propiedades.

## 🛠️ Tecnologías Utilizadas

* **Lenguaje:** Elixir
* **Arquitectura:** OTP (GenServer, Supervisor, DynamicSupervisor, Registry)
* **Interfaz:** CLI (Línea de comandos interactiva)

## ⚙️ Cómo ejecutar el proyecto

### 1. Requisitos previos
* Tener [Elixir](https://elixir-lang.org/install.html) instalado en tu máquina.
* Clonar este repositorio:
  ```bash
  git clone [https://github.com/PabloUQ21/proyecto_inmobiliaria_elixir.git](https://github.com/PabloUQ21/proyecto_inmobiliaria_elixir.git)