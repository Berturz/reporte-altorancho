# Guía para editar el Reporte Semanal

Este repositorio es **la única fuente de la verdad** del reporte publicado en
`https://berturz.github.io/reporte-altorancho/`.

> ⚠️ **Regla de oro (para no pisar el trabajo del otro):**
> **`git pull` ANTES de editar** y **`git push` AL TERMINAR**. Nunca editar los dos a la vez sin avisar.

---

## ¿Qué querés hacer?

### A) Solo cargar datos / actualizar el Excel
**No necesitás nada de esto.** Entrá al sitio publicado con tu usuario y contraseña,
cargá el Excel y apretá **"Guardar en Supabase"**. Listo, se actualiza solo.

### B) Modificar el código o una fórmula
Seguí los pasos de abajo (una sola vez el setup, después es rápido).

---

## Setup (una vez)

1. **Cuenta de GitHub** (gratis): crearla en https://github.com/signup y pasarle
   tu usuario al dueño del repo para que te agregue como *colaborador*.
2. **Instalar en tu PC:**
   - **Node.js** (LTS): https://nodejs.org  → para ver el preview local.
   - **Git**: https://git-scm.com  → para bajar y subir cambios. La primera vez
     te va a pedir loguearte con tu cuenta de GitHub.
   - **Claude Code** (con cuenta de Anthropic): para editar hablando, sin tocar
     el HTML a mano.
3. **Clonar el repo:**
   ```
   git clone https://github.com/Berturz/reporte-altorancho.git
   cd reporte-altorancho
   ```

---

## Flujo de trabajo (cada vez que edites)

1. **Traer lo último:**
   ```
   git pull
   ```
2. **Abrir la carpeta con Claude Code** y pedirle el cambio en español, por ejemplo:
   *"Cambiá la fórmula del margen para que use X"* o *"agregá una columna Y"*.
3. **Ver el preview:** pedile a Claude que levante el preview (config `reporte`,
   `localhost:8145`) o corré:
   ```
   node preview-server.js
   ```
   Abrí http://localhost:8145 y entrá con tu login del reporte para ver los datos.
4. **Cuando esté OK, publicar:**
   ```
   git add -A
   git commit -m "descripción del cambio"
   git push
   ```
5. Esperá ~1 minuto: GitHub Pages actualiza el sitio solo.

---

## Notas

- Los **datos** (facturación, etc.) NO están en este archivo: viven en Supabase y
  bajan sólo después de iniciar sesión. Por eso el repo puede ser público sin
  exponer datos.
- Si `git push` da error de "rechazado" es porque alguien subió cambios: hacé
  `git pull` (resolvé si hay conflicto) y volvé a `git push`.
- Ante la duda, preguntale a Claude Code: sabe manejar git, el preview y el código.
