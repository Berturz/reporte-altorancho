# Control presupuestario 2026 — especificación

Página **aparte** del reporte comercial (`presupuesto.html`), con login propio, que muestra
forecast anual por sector, gastos reales, desvíos y el detalle de gastos de cada sector.
Se actualiza **una vez por mes**, subiendo dos Excel.

Misma arquitectura que el reporte: el HTML lleva solo el *código*; los datos viven en
Supabase y se cargan al entrar con usuario. **Ningún número entra al repo** (es público).

---

## 1. Fuentes de datos

### a) Forecast, reales y desvíos
`6.1.8 Presupuestos\Presupuestos Anuales\2026\Forecast anual de gastos 2026+ Análisis de desvios.xlsm`

Se leen 3 hojas:

| Hoja | Aporta |
|---|---|
| `Análisis de desvios` | La grilla completa: proyectado, real y desvío por sector y mes |
| `COMUNICACION SECTORES` | La misma grilla redondeada (versión para mostrar) |
| `Forecast` | Cómo se proyecta: inflación, ajuste salarial, histórico y FORECAST.ETS |

**Layout de `Análisis de desvios`** — columnas `C..N` = ene-26..dic-26, etiqueta de fila en `B`.
Tres secciones espejo, cada una con los mismos 4 bloques:

| Bloque | Proyectado | Real | Desvío |
|---|---|---|---|
| Sectores | f2–f8 (tot. f9) | f35–f41 (tot. f42) | f67–f73 (tot. f74) |
| Logística envíos | f13–f16 (tot. f17) | f46–f49 (tot. f50) | f78–f81 (tot. f82) |
| Salarios | f21–f24 (tot. f25) | f54–f57 (tot. f58) | f86–f89 (tot. f90) |
| Compras | f29–f30 (tot. f31) | f62–f63 (tot. f64) | f94–f95 (tot. f96) |

Totales generales: `f99` presupuestado · `f100` real · `f101` desvío.
La columna de **gastos reales se pega a mano** en el Excel cada mes.

Sectores: MKT · GRUPO · RRHH-gastos comunes · LOGISTICA · FABRICA/ROLON (variables) ·
FABRICA (fijos en CMV) · PRODUCTO (prototipos).

### b) Detalle de gastos por sector
`6.1.3 Análisis de Punto de equilibrio\Por Canal\2026\<NN. Mes>\(Gastos- )Punto de Equilibrio <Mes> 2026.xlsm`
→ hoja **`CF-gastos`**

Fila 1 vacía, encabezados en fila 2, datos desde fila 3. Columnas:
Sector Reponsable · Mes P.E · Categoría · Concepto · Fijo/Variable · Asignación ·
Asignación propia · TOTAL ($) · Proveedor/Detalle · Fecha Cashflow/Orden de Pago ·
Fuente · *(columnas de canal)* · Concepto (apertura).

Volumen: ~160–260 movimientos por mes.

---

## 2. Trampas del importador (leer todo por NOMBRE de encabezado, nunca por letra)

- La hoja `CF-gastos` **cambia de posición** entre archivos (enero es la 9ª, julio y agosto la 10ª)
  → buscar por nombre de hoja.
- Las **columnas de canal cambian durante el año**:
  enero = Lett / SI / **ND** / BE / Web · julio-agosto = Lett / SI / BE / **ALC** / Web.
- Enero escribe `Asiganción` (con typo) en vez de `Asignación`, y no tiene `Concepto (apertura)`.
- El nombre del archivo es inconsistente (`Punto de Equilibrio Enero 2026.xlsm` vs
  `Gastos- Punto de Equilibrio Julio 2026.xlsm`) → el mes se toma de la columna `Mes P.E`.

## 3. Conciliación detalle vs. forecast

El total de `CF-gastos` por sector debería explicar la columna de gastos reales del forecast.
En julio cierran LOGISTICA y PRODUCTO exacto, GRUPO al 0,01%, MKT y RRHH con diferencia
menor al 2%. Pendientes de revisar con el área:

- **Enero, sector GRUPO:** el detalle no cuadra con el real del forecast.
- **FABRICA:** `CF-gastos` trae solo el bloque variable (ROLON); los gastos fijos de producción
  salen de otra hoja (`Gastos Fábrica`). Definir si entran al detalle.

La página muestra un **semáforo de conciliación** por sector (✔ / ⚠) en vez de asumir que cuadra.

---

## 4. Secciones de la página

1. KPIs del mes y acumulado del año (presupuesto, real, desvío en $ y %).
2. Tarjetas presupuesto vs. real por sector, con el desvío destacado.
3. Tarjetas por bloque (sectores / envíos / salarios / compras) con sus líneas.
4. Mapa de calor de desvíos sector × mes.
5. Detalle de gastos por sector: composición por categoría, prorrateo por canal,
   corte fijo/variable y directo/indirecto, y la tabla de movimientos con proveedor.

## 5. Acceso

Mismo login que el reporte comercial (mismo proyecto de Supabase, mismo mail y contraseña),
pero los datos van en **tabla propia** `presupuesto_data` con una lista de mails habilitados:
quien entra al reporte y no está en la lista no ve el presupuesto. Necesario porque la página
expone salarios por sector.

Tabla y permisos: [`.claude/presupuesto-supabase.sql`](.claude/presupuesto-supabase.sql)
(completar la lista de mails antes de correrlo).

## 6. Rutina mensual

1. Cerrar el mes en el Excel de punto de equilibrio y en el forecast anual.
2. Entrar a `presupuesto.html` con usuario.
3. **Subir Forecast** (el `.xlsm` anual) → presupuesto, reales y desvíos.
4. **Subir CF-gastos del mes** (el punto de equilibrio) → detalle por sector.
5. Revisar el semáforo de conciliación y **Guardar**.
