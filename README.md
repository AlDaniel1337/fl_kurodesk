# Kurodesk

**Kurodesk** es un gestor minimalista de espacios de trabajo para Windows construido con **Flutter** y llamadas nativas a la **API Win32**. Inspirado en una barra flotante tipo *Dynamic Island*, permite agrupar ventanas activas por contexto de trabajo, alternar entre grupos con un clic y minimizar o restaurar conjuntos completos de aplicaciones al instante.

---

## Características principales

- **Grupos de ventanas personalizados:** Crea, renombra (doble clic sobre el título), reordena mediante arrastrar y soltar (*drag & drop*) y elimina espacios de trabajo según tu flujo (por ejemplo: `BLENDER`, `CODE`, `REFS`).
- **Modo Mini adaptativo:** Al hacer clic fuera de la ventana, **Kurodesk** se contrae automáticamente en una píldora flotante compacta que muestra el grupo activo y se expande de forma animada al pasar el cursor encima.
- **Grupo fijado y alternancia rápida (Quick Switch):** Marca cualquier grupo con clic derecho (`Pin`) para tener un botón de acceso directo en el modo mini. Al saltar al grupo fijado, el botón recuerda tu grupo anterior y cambia su icono para permitirte regresar con un solo clic.
- **Control nativo Win32:**
  - Filtra automáticamente ventanas ocultas del sistema, procesos en segundo plano (`DWMWA_CLOAKED`) y ventanas pertenecientes a otros escritorios virtuales (`IVirtualDesktopManager`).
  - Minimiza las ventanas de los grupos inactivos y restaura/enfoca las del grupo seleccionado.
  - Purga automáticamente las referencias (`HWND`) de ventanas que hayan sido cerradas externamente.
- **Multi-instancia por escritorio virtual:** Permite ejecutar instancias independientes en distintos escritorios virtuales de Windows sin conflictos de estado.

---

## Arquitectura y Stack Tecnológico

El proyecto sigue una estructura modular basada en **Clean Architecture** y gestión de estado reactiva:

- **Framework:** Flutter Desktop (Windows)
- **Gestión de estado:** `flutter_bloc` + `equatable`
- **Integración nativa:** `win32`
- **Control de ventana:** `window_manager`