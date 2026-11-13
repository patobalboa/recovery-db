# Recovery DB | PostgreSQL en AWS Academy

**Asignatura:** Administración de Base de Datos · **Modalidad:** laboratorio libre de cantidad de grupo con diferencia de calidad · **Infraestructura:** instancia EC2 de AWS Academy Learner Lab · **Motor:** PostgreSQL · **Enfoque:** SRE/DBA (operación, recovery y performance).


## Caso: «La tienda vuelve a operar»

Una empresa mantiene una base PostgreSQL en EC2. Tras una intervención, se pierden objetos de la base. Además, la aplicación presenta consultas lentas. El equipo DBA debe montar un entorno reproducible, demostrar recuperación íntegra y proponer mejoras medibles sin comprometer los datos.

### Competencias

1. Desplegar PostgreSQL sobre Linux en una instancia EC2 de AWS Academy y documentar su configuración.
2. Analizar roles, conexiones, servicios, almacenamiento, logs y controles de acceso.
3. Diseñar y **probar** una estrategia de respaldo y recuperación, distinguiendo respaldos lógicos y físicos.
4. Investigar el comportamiento de consultas mediante `EXPLAIN (ANALYZE, BUFFERS)`, estadísticas y catálogo.
5. Justificar una mejora de rendimiento mediante mediciones comparables antes/después.
6. Documentar resultados técnicos, fallas, límites y medidas operacionales.

## Inicio rápido

1. Lee [Guía de estudiante](docs/guia-estudiante.md) **antes** de ejecutar scripts.
2. Revisa [AWS Academy y seguridad](docs/aws-academy.md).
3. Revisa [Material de estudio](docs/material-estudio.md) y [Rúbrica](docs/rubrica.md).
4. Desde la EC2, clona el repositorio:
   ```bash
   git clone https://github.com/patobalboa/recovery-db.git
   cd recovery-db
   ```
5. Prepara PostgreSQL **según la documentación oficial**. Dispones de [comprobaciones de entorno](scripts/diagnostico.sh), [esquema](sql/01_esquema.sql), [dataset](sql/02_datos.sql) y [consultas de diagnóstico](sql/03_consultas.sql).
6. Entrega un informe técnico individual o grupal, según indique el docente.

## Archivos

| Ruta | Propósito |
|---|---|
| `docs/guia-estudiante.md` | Misión completa y evidencias |
| `docs/aws-academy.md` | Preparación EC2, seguridad, costos y troubleshooting |
| `docs/material-estudio.md` | Lecturas y conceptos orientadores |
| `docs/rubrica.md` | Rúbrica de 100 puntos |
| `sql/01_esquema.sql` | Modelo de negocio para el laboratorio |
| `sql/02_datos.sql` | Población sintética reproducible |
| `sql/03_consultas.sql` | Consultas base a investigar (no optimizadas) |
| `sql/04_integridad.sql` | Consultas de verificación sin valores esperados |
| `scripts/diagnostico.sh` | Captura pasiva de estado del servidor |
| `plantillas/bitacora.md` | Bitácora de experimentos |
| `plantillas/informe.md` | Estructura de entrega |
| `docs/extension.md` | Desafíos opcionales PITR, monitoreo y hardening |

## Reglas de seguridad

- Usar **solo** el entorno autorizado de AWS Academy.
- No ejecutar operaciones destructivas en bases ajenas o productivas.
- No publicar contraseñas, claves privadas SSH, tokens o capturas con secretos.
- No abrir PostgreSQL/5432 a Internet. Se recomienda `psql` local desde SSH en la EC2.
- Validar la persistencia de los respaldos y **restaurar en un destino distinto** antes de declarar éxito.
- Registrar fecha, versión PostgreSQL, tipo de instancia, volumen, versión del dataset y métricas.
- Detener la EC2 al finalizar según política de AWS Academy (revisar si existen cargos/limitaciones y recursos que persistan).

## Requisitos sugeridos

Ubuntu Server en EC2, conexión SSH, Git y PostgreSQL instalado en el guest. El tamaño de instancia, permisos, tipo de AMI y disponibilidad de herramientas dependen de la cuenta AWS Academy. Para dataset mediano, disponer de al menos 2 vCPU/2 GiB si el laboratorio lo permite; si no, reducir `lab.escala` (ver script de datos). No se requiere RDS, Docker ni acceso público al puerto 5432.

## Ruta de trabajo

**Bloque 1:** infraestructura e instalación → **Bloque 2:** exploración/modelado → **Bloque 3:** respaldo → **Bloque 4:** incidente y recuperación → **Bloque 5:** optimización y medición → **Bloque 6:** evidencia y defensa.

La versión de tres horas sirve para el recorrido mínimo; la actividad **completa** puede trabajarse en dos sesiones o como evaluación extendida, especialmente la optimización.

**Autoría académica:** material preparado para docencia práctica de Administración de Base de Datos. Licencia educativa: ver [LICENSE](LICENSE).
