# Intercomunicador-Receptor-
# HOJA DE RUTA – PROYECTO INTERCOMUNICADOR

## 1. Idea inicial del proyecto

El proyecto surgió a partir de una necesidad de un centro de salud que cuenta con varias computadoras y una sala de espera.

La idea principal fue desarrollar un sistema que permitiera que el personal pudiera realizar llamados desde las computadoras de atención hacia la sala de espera, utilizando un micrófono y un botón dentro del programa.

Por ejemplo, un empleado podría seleccionar o indicar:

* Paciente.
* Número de sala.
* Consultorio.
* Ventanilla.
* Otro mensaje necesario.

El audio sería enviado a una computadora receptora conectada al sistema de sonido de la sala de espera.

El objetivo fue crear una solución sencilla, económica y adaptable a la infraestructura existente, evitando depender de un sistema de altavoces o intercomunicadores físicos independientes para cada puesto.

---

# 2. Primera etapa – Análisis de la necesidad

Inicialmente se planteó que el centro podría contar con aproximadamente 9 computadoras, con posibilidad de agregar algunas más en el futuro.

Se establecieron como requisitos principales:

* Utilizar la red local existente.
* Permitir varios puestos emisores.
* Utilizar un micrófono conectado a cada computadora.
* Contar con una computadora receptora.
* Reproducir el audio en los parlantes de la sala de espera.
* Mantener un consumo bajo de recursos.
* Poder ampliar el sistema posteriormente.

La comunicación se planteó inicialmente como un sistema cliente-servidor dentro de la misma red local.

---

# 3. Primer desarrollo – Prueba con C#

En una primera etapa se comenzó a desarrollar una versión utilizando C# y Windows Forms.

Se configuró un proyecto en Visual Studio y se realizaron distintas pruebas de interfaz y funcionamiento.

También se incorporó la biblioteca NAudio para trabajar con el micrófono.

Entre las primeras pruebas realizadas estuvieron:

* Detección del micrófono.
* Identificación del dispositivo de entrada.
* Grabación de audio.
* Reproducción del audio grabado.
* Pruebas de botones y mensajes.
* Pruebas básicas de la interfaz.

Esta etapa permitió comprobar que era posible capturar correctamente el audio desde el equipo.

Sin embargo, durante el desarrollo se decidió cambiar de tecnología debido a la complejidad que estaba tomando el proyecto y a la necesidad de trabajar con una tecnología que también sirviera como práctica para los conocimientos de programación orientada a objetos.

---

# 4. Cambio de tecnología – Java

El proyecto fue trasladado a **Java**.

Esta decisión permitió continuar trabajando sobre los conceptos de programación orientada a objetos que se estaban estudiando, al mismo tiempo que se desarrollaba el sistema real.

Para el audio se pasó a utilizar la API de sonido de Java:

`javax.sound.sampled`

La interfaz se desarrolló utilizando componentes gráficos de Java, principalmente:

* `JFrame`
* `JButton`
* `JLabel`
* Otros componentes de Swing.

La aplicación pasó a plantearse como un programa de escritorio independiente.

---

# 5. Organización del proyecto

Se planteó una estructura orientada a separar las diferentes responsabilidades del programa.

La idea fue dividir el proyecto en partes como:

```text
comunicador/
│
├── interfaz/
│
├── audio/
│
└── conexion/
```

### Interfaz

Responsable de la parte visual del programa:

* Botones.
* Indicadores.
* Controles.
* Mensajes al usuario.
* Estado del micrófono.

### Audio

Responsable de:

* Detectar el micrófono.
* Capturar el audio.
* Procesar la grabación.
* Reproducir el audio cuando corresponda.

### Conexión

Responsable de la comunicación entre las diferentes computadoras de la red.

La intención es que esta separación facilite futuras modificaciones y mantenimiento.

---

# 6. Desarrollo de la interfaz

Se creó la interfaz principal del comunicador.

Uno de los elementos principales fue el botón utilizado para realizar el llamado.

También se incorporó un indicador para mostrar el estado del micrófono.

Durante las pruebas se utilizaron mensajes como:

**"Micrófono apagado"**

y

**"Micrófono encendido"**

para comprobar visualmente el funcionamiento.

También se realizaron pruebas mediante botones para verificar que los diferentes eventos de la interfaz funcionaran correctamente.

---

# 7. Pruebas de audio

Una de las etapas más importantes fue comprobar que Java pudiera trabajar correctamente con el micrófono del equipo.

Se realizaron pruebas para:

1. Detectar los dispositivos de entrada.
2. Seleccionar el micrófono.
3. Capturar audio.
4. Grabar el sonido.
5. Reproducirlo nuevamente.

Finalmente se consiguió detectar correctamente el micrófono y realizar pruebas de grabación y reproducción.

Esto permitió confirmar que la parte fundamental del sistema de audio era viable.

---

# 8. Comunicación entre computadoras

Una vez comprobado el funcionamiento local del audio, el siguiente objetivo fue llevarlo a una comunicación entre diferentes equipos.

La arquitectura planteada consiste en:

```text
COMPUTADORAS DE ATENCIÓN
        │
        │
        │  Red local
        │
        ▼
COMPUTADORA RECEPTORA
        │
        ▼
   PARLANTES
        │
        ▼
    SALA DE ESPERA
```

Cada computadora de atención funciona como punto emisor.

La computadora receptora recibe la información y se encarga de reproducir el audio en el sistema de sonido de la sala de espera.

Esto permite centralizar la reproducción sin necesidad de instalar un sistema independiente de audio en cada puesto.

---

# 9. Empaquetado de la aplicación

Una vez avanzado el desarrollo, se trabajó en la posibilidad de instalar el programa en otras computadoras sin tener que abrir el proyecto desde el entorno de desarrollo.

Para esto se configuró Java/JDK y finalmente se trabajó con **JDK 27**.

Se utilizó `jpackage`, una herramienta de Java que permite generar paquetes instalables para aplicaciones Java.

El objetivo fue pasar de tener simplemente archivos `.java` o `.jar` a disponer de una aplicación que pudiera instalarse y ejecutarse como un programa normal de Windows.

---

# 10. Generación del instalador

Se logró generar el paquete de instalación del programa utilizando `jpackage`.

Esto permitió instalar la aplicación en otra computadora.

Después de realizar la instalación, se generó una estructura similar a:

```text
C:\Archivos de programa\ComunicadorApp\
│
└── app\
    ├── Intercomunicador.jar
    ├── Receptor.jar
    ├── archivos del programa
    └── archivos necesarios para la aplicación
```

De esta manera, el programa deja de depender directamente del proyecto utilizado durante el desarrollo.

La intención es que una computadora del centro de salud pueda tener instalada la aplicación y utilizarla como un programa convencional.

---

# 11. Situación actual del proyecto

Actualmente el proyecto cuenta con varios componentes importantes ya desarrollados:

* Proyecto realizado en Java.
* Interfaz gráfica.
* Detección del micrófono.
* Captura y reproducción de audio.
* Desarrollo del concepto de emisor y receptor.
* Preparación para comunicación mediante red local.
* JDK configurado.
* Empaquetado mediante `jpackage`.
* Instalación de la aplicación en otra computadora.
* Generación de los archivos `.jar`.
* Pruebas de instalación fuera del entorno de desarrollo.

El proyecto ya pasó de ser solamente una prueba de programación a convertirse en una aplicación que puede ser instalada en otro equipo.

---


Comprobar:

* Pérdida de conexión.
* Reinicio del programa.
* Micrófono desconectado.
* Varios llamados.
* Problemas de red.
* Calidad del audio.

### 6. Instalación definitiva

Instalar el sistema en los equipos correspondientes del centro de salud.

### 7. Documentación

Preparar una pequeña guía para el personal indicando:

* Cómo realizar un llamado.
* Cómo verificar el estado del sistema.
* Qué hacer ante un problema.
* Cómo reiniciar la aplicación.

---

# 13. Tecnologías utilizadas

Durante el desarrollo se utilizaron principalmente:

**Lenguaje:**

* Java

**Interfaz:**

* Java Swing

**Audio:**

* `javax.sound.sampled`

**Entorno de desarrollo:**

* Visual Studio Code / herramientas de desarrollo Java

**Java:**

* JDK 27

**Empaquetado:**

* `jpackage`

**Sistema operativo objetivo:**

* Windows

**Comunicación prevista:**

* Red local mediante Wi-Fi/Ethernet.

---

# 14. Resultado del proyecto

El proyecto comenzó como una idea para solucionar una necesidad concreta de comunicación dentro de un centro de salud y fue evolucionando hasta convertirse en una aplicación de escritorio desarrollada en Java.

Durante el desarrollo se realizaron pruebas de interfaz, micrófono, captura de audio, reproducción, comunicación entre componentes y finalmente empaquetado e instalación.

La arquitectura permite continuar ampliando el sistema para soportar más computadoras y diferentes puestos de atención.

El siguiente objetivo principal es completar y probar la comunicación de audio entre los equipos emisores y el receptor, para posteriormente realizar una instalación piloto en el centro de salud.

---

## Resumen de la evolución

```text
NECESIDAD DEL CENTRO DE SALUD
            ↓
     IDEA DEL SISTEMA
            ↓
     PRUEBAS CON C#
            ↓
      PRUEBAS DE AUDIO
            ↓
       CAMBIO A JAVA
            ↓
   DESARROLLO DE INTERFAZ
            ↓
   CAPTURA Y REPRODUCCIÓN
          DE AUDIO
            ↓
   DISEÑO EMISOR/RECEPTOR
            ↓
   COMUNICACIÓN POR RED
            ↓
       JDK 27 + jpackage
            ↓
     INSTALACIÓN EN PC
            ↓
      PRUEBAS FINALES
            ↓
   IMPLEMENTACIÓN PILOTO
```

## Estado actual

**Proyecto:** Intercomunicador para centro de salud
**Lenguaje:** Java
**Estado:** Desarrollo avanzado / etapa de integración
**Empaquetado:** Realizado mediante `jpackage`
**Instalación:** Probada en otra computadora
**Audio:** Probado localmente
**Siguiente objetivo:** Completar la comunicación de audio entre emisores y receptor y realizar pruebas con varios equipos.
