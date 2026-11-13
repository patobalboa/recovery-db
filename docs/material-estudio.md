# Material de estudio | PostgreSQL Recovery & Performance

Lee los apartados indicados e incorpora citas o referencias en tu informe cuando respalden decisiones. **No basta con seguir comandos sin explicar por qué funcionan.**

## Arquitectura y operación

- [PostgreSQL: Server Configuration](https://www.postgresql.org/docs/current/runtime-config.html): memoria, procesos y parámetros.
- [PostgreSQL: Client Authentication](https://www.postgresql.org/docs/current/client-authentication.html): `pg_hba.conf` y método de autenticación.
- [PostgreSQL: Monitoring Database Activity](https://www.postgresql.org/docs/current/monitoring.html): vistas `pg_stat_*`, actividad e índices.
- [PostgreSQL: System Catalogs](https://www.postgresql.org/docs/current/catalogs.html): metadatos.

**Conceptos a dominar:** instancia y cluster, `PGDATA`, postmaster, WAL, transacciones ACID, catálogo, roles, `VACUUM` y `ANALYZE`.

## Respaldo y recuperación

- [Backup and Restore](https://www.postgresql.org/docs/current/backup.html): estrategias.
- [SQL Dump](https://www.postgresql.org/docs/current/backup-dump.html): respaldos lógicos.
- [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html): formatos y consistencia.
- [pg_restore](https://www.postgresql.org/docs/current/app-pgrestore.html): restauración.
- [pg_dumpall](https://www.postgresql.org/docs/current/app-pg-dumpall.html): roles/globales.
- [Continuous Archiving and PITR](https://www.postgresql.org/docs/current/continuous-archiving.html): recuperación a un punto temporal.

**Distingue:** RTO vs RPO; dump lógico vs backup físico; copia en disco local vs fuera del servidor; consistencia vs integridad; backup tomado vs backup **restaurado y probado**. Comprende que `pg_dump` no ofrece por sí solo recuperación continua de cambios posteriores.

## Consultas y optimización

- [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html): `EXPLAIN`, `ANALYZE`, `BUFFERS`, estimaciones y planes.
- [Performance Tips](https://www.postgresql.org/docs/current/performance-tips.html): planificador y acceso.
- [Indexes](https://www.postgresql.org/docs/current/indexes.html): propósito, trade-offs y tipos.
- [Multicolumn Indexes](https://www.postgresql.org/docs/current/indexes-multicolumn.html): índices compuestos.
- [Partial Indexes](https://www.postgresql.org/docs/current/indexes-partial.html): predicados.
- [Routine Vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html): estadísticas y mantenimiento.
- [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html): agregación de estadísticas de consultas; requiere configuración y, según versión, reinicio.

**Distingue:** lectura secuencial vs indexada; costo estimado vs tiempo real; selectividad, cardinalidad, filas estimadas/reales, shared hit/read, caching, sort, join, mantenimiento de índices y amplificación de escritura.

## AWS y seguridad

- [AWS Academy](https://aws.amazon.com/training/awsacademy/)
- [EC2: Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)
- [Amazon EBS](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html)

## Preguntas para autoevaluación

1. ¿Qué informa el WAL y por qué no equivale a un dump SQL?
2. ¿Por qué probar el restore en una base diferente?
3. ¿Cuáles objetos y permisos pueden no quedar cubiertos por un dump de una sola base?
4. ¿Por qué crear índices para todos los campos no es una estrategia sensata?
5. ¿Qué diferencia hay entre `EXPLAIN` y `EXPLAIN ANALYZE`?
6. ¿Por qué una consulta puede ser más rápida en una segunda ejecución sin modificar SQL?
7. ¿Qué criterio usarías para comparar dos intervenciones de performance?
8. ¿Cómo se vinculan RTO y RPO con decisiones empresariales?

Elabora respuestas técnicas propias y vincúlalas con las evidencias del laboratorio.
