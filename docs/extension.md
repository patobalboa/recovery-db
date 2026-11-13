# Extensiones opcionales | Ingeniería DBA avanzada

No forman parte del recorrido mínimo de tres horas; se pueden desarrollar como desafíos avanzados o segunda sesión.

## Extensión 1 — PITR

Diseña sobre papel o implementa **en un entorno aislado** una estrategia con backup físico y archivado de WAL. Estudia `pg_basebackup`, `archive_mode`, `archive_command`, `restore_command` y recovery targets. Define un cambio de datos específico y documenta cómo recuperarías un instante anterior. **No confundas PITR con ejecutar un dump lógico.**

Preguntas: ¿qué garantiza la cadena de WAL? ¿qué puede salir mal si los archivos de WAL se almacenan en la misma instancia? ¿qué implica un timeline tras recuperación?

## Extensión 2 — Observabilidad

Investiga `pg_stat_activity`, `pg_stat_database`, `pg_stat_user_tables`, `pg_stat_user_indexes` y `pg_stat_statements`. Diseña indicadores de latencia, conexiones, locks, I/O, autovacuum y crecimiento de tabla. Establece señales, no umbrales inventados: consulta tu medición baseline.

## Extensión 3 — Optimización de escritura

Después de agregar un índice, mide un lote comparable de inserts en ambiente limpio e investiga impacto en write amplification, tamaño y `VACUUM`. ¿Puede un índice ayudar lecturas y perjudicar escrituras?

## Extensión 4 — Recuperación en EC2 nueva

Repite recuperación en **otra** instancia o cluster con versión compatible y documenta dependencias: roles, ownership, extensiones, locale, puertos, SG, red y política de almacenamiento. No dejes recursos activos después.

## Extensión 5 — Seguridad operativa

Diseña una matriz mínima de privilegios y un plan de cifrado y protección de backups (reposo/tránsito), retención, borrado y pruebas periódicas. Compara enfoque `pg_dump`, snapshots EBS y un respaldo off-host.
