# Guía del estudiante | Recovery DB en AWS Academy

**Misión:** desplegar, operar, recuperar y optimizar una base PostgreSQL en EC2.
**Producto esperado:** informe técnico sustentado en evidencia, comandos ejecutados, decisiones justificadas y pruebas reproducibles.

## 0. Contexto y reglas

La empresa ficticia **NovaStore** aloja información comercial en PostgreSQL: clientes, productos, pedidos y detalle de pedidos. Un error de mantenimiento deja la información inaccesible. A la vez, las consultas del tablero comercial presentan latencias. Formas parte del equipo DBA responsable de la continuidad y el rendimiento.

**No se califica copiar comandos:** se evalúa capacidad de determinar el estado del sistema, contrastar hipótesis, documentar y demostrar recuperación. Los scripts del repositorio crean datos de laboratorio; no incluyen una solución de backup ni índices recomendados.

**Alcance autorizado:** tu propia EC2 en AWS Academy. Nunca apliques instrucciones destructivas a sistemas de terceros o producción.

### Resultados de aprendizaje

- Implementar y administrar un servicio PostgreSQL sobre Ubuntu en AWS.
- Obtener respaldos consistentes, identificar su formato, verificar artefactos y recuperar datos.
- Medir consultas con herramientas nativas y sustentar cambios de optimización.
- Evaluar seguridad, continuidad operacional, integridad y reproducibilidad.

## 1. Planificación y bitácora (antes de comenzar)

Abre `plantillas/bitacora.md` y registra **hora de inicio**, región, AMI, tipo EC2, tamaño/volumen EBS, PostgreSQL, direcciones IP sin información sensible, repositorio y commit usado. Señala qué riesgos tienen los siguientes elementos: almacenamiento efímero, pérdida de credenciales, acceso excesivo a la red, backups guardados en la misma máquina y eliminación accidental.

**Pregunta guía:** ¿qué elemento de la infraestructura conservaría el respaldo si la EC2 dejara de estar disponible?

## 2. Misión A — Infraestructura AWS Academy

1. Ingresa a AWS Academy Learner Lab y valida que el laboratorio esté activo y exista presupuesto disponible.
2. Despliega una instancia EC2 Linux compatible con los recursos del curso. Comprueba región, AMI, tipo de instancia, volumen de almacenamiento y regla SSH del Security Group.
3. Accede mediante SSH o el método autorizado en tu Learner Lab; evita transferir claves privadas a compañeros.
4. Comprueba identidad, versión SO, hostname, IP privadas, CPU, RAM, espacio disponible, discos montados y servicio SSH.
5. Instala Git y los paquetes de PostgreSQL siguiendo instrucciones oficiales para tu versión de Ubuntu. Documenta repositorio de paquetes y versión instalada.
6. Comprueba que PostgreSQL esté activo, su puerto de escucha, directorio de datos, configuración, logs y estado de las conexiones.
7. Evalúa si **realmente necesitas exponer** PostgreSQL en red. Por defecto, trabaja con `psql` local vía SSH y NO abras 5432 públicamente.

**Preguntas de investigación:** ¿dónde vive el cluster PostgreSQL? ¿qué diferencia hay entre usuario Linux y rol de base de datos? ¿qué implican `listen_addresses`, `pg_hba.conf` y Security Groups? ¿qué permanece al reiniciar y al terminar el laboratorio?

**Evidencias:** captura de instancia (sin credenciales), SSH funcional, versión de PostgreSQL, servicio y configuración de escucha, inventario de almacenamiento y explicación de reglas de seguridad.

## 3. Misión B — Modelo y línea base

1. Clona este repositorio en EC2 y guarda el identificador del commit.
2. Lee `sql/01_esquema.sql` antes de ejecutarlo; reconoce llaves primarias, relaciones, restricciones y tipos de datos.
3. Crea **una base de laboratorio propia**, usando una convención de nombres que permita reconocer a tu equipo.
4. Ejecuta el esquema y los datos de `sql/02_datos.sql`. Revisa cómo se define `lab.escala` para ajustar el volumen de información si los recursos son limitados.
5. Verifica tablas, filas aproximadas, integridad referencial y tamaño de la base. Ejecuta las comprobaciones de `sql/04_integridad.sql`.
6. Identifica cuáles objetos fueron creados automáticamente por PostgreSQL y cuáles hacen falta según la carga de trabajo.
7. Registra una **línea base** de los recursos EC2 y del estado de PostgreSQL.

**Preguntas:** ¿por qué se necesita una carga de datos suficientemente grande para estudiar optimización? ¿por qué `COUNT(*)` y estadísticas estimadas pueden diferir? ¿qué tareas hace `ANALYZE`?

**Evidencias:** listado de tablas, resultado de al menos cuatro comprobaciones, tamaño de BD, diagrama o descripción de relaciones, captura del servicio.

## 4. Misión C — Estrategia de respaldo

La empresa exige recuperar los datos creados hasta un punto conocido sin depender de que la instancia original permanezca operativa.

1. Revisa en el material de estudio las diferencias entre respaldo lógico, físico y archivado de WAL.
2. Define por escrito **qué** respaldarás (base, esquema, datos, roles), **cómo**, **dónde**, **con qué periodicidad** y **cómo verificarás** el artefacto.
3. Investiga `pg_dump`, `pg_dumpall --globals-only`, `pg_restore`, `psql`, permisos de archivos y formatos de dump.
4. Produce un **respaldo lógico consistente** de tu base, con un nombre que indique fecha y base; elige y justifica un formato.
5. Registra el tamaño del archivo, su checksum criptográfico y el tiempo de creación.
6. Verifica que pueda ser inspeccionado mediante herramientas apropiadas para el formato elegido.
7. Explica por qué un archivo existente **no prueba** que una recuperación funcione.

**No entregamos el comando final:** debes construirlo, ejecutarlo y explicar parámetros. Consulta `pg_dump --help` y la documentación oficial.

**Evidencias:** estrategia de respaldo, comando comentado, archivo generado (solo metadata/captura, no subir dumps grandes ni datos privados), checksum, comprobación de formato y medición de duración.

## 5. Misión D — Incidente de pérdida y restauración

**Control de seguridad:** confirma el nombre exacto de la base y dispone de una copia recuperable **antes** de modificar objetos. No borres la EC2 ni el volumen EBS. Ejecuta daños deliberados solo sobre la BD de laboratorio.

**Escenario:** un operador ejecuta una sentencia DDL que elimina un objeto de negocio crítico. El profesor indicará qué objeto o evento simular. Debes registrar el estado antes de la intervención.

1. Documenta el estado sano y la hora del punto de recuperación.
2. Simula únicamente el evento autorizado (por ejemplo, eliminación de una tabla de laboratorio). Anota la sentencia exacta.
3. Registra el error o la inconsistencia visible tras el incidente.
4. Diseña un procedimiento que **no sobrescriba la única copia disponible**. Puedes utilizar una base de destino independiente.
5. Restaura el artefacto; captura códigos de salida, advertencias y conflictos de objetos.
6. Ejecuta pruebas de integridad y consultas equivalentes a las de la línea base.
7. Compara estado esperado vs estado observado; informa cualquier pérdida deliberada de transacciones posteriores al respaldo.
8. Calcula un **RTO observado** (inicio del incidente → servicio validado) y estima **RPO observado** según punto de backup y registros introducidos después.

**Investigación obligatoria:** ¿qué diferencia existe entre `pg_restore` y cargar un archivo SQL con `psql`? ¿qué ocurre con roles y extensiones? ¿cómo se validan secuencias y relaciones?

**Evidencias:** antes/después, comando de recuperación razonado, destino independiente, verificación objetiva, tiempos y conclusiones.

## 6. Misión E — Optimización fundamentada en evidencia

**Prohibido** proponer una mejora solo por intuición. Debes medir, formular hipótesis, intervenir con cambios controlados y volver a medir.

1. Lee `sql/03_consultas.sql`. Identifica filtros, uniones, agregaciones y ordenamientos.
2. Para **al menos dos consultas**, captura su comportamiento inicial utilizando `EXPLAIN (ANALYZE, BUFFERS)` sobre un dataset representativo.
3. Registra: tiempo de ejecución, plan elegido, filas estimadas y reales, `Seq Scan` / `Index Scan`, joins, ordenamientos y buffers compartidos.
4. Determina si existen estadísticas desactualizadas, cardinalidades anómalas, filtros poco selectivos o patrones de acceso costosos.
5. Formula hipótesis: cambio de consulta SQL, índices, estadísticas, particionamiento, configuración u otra alternativa. **No apliques todas a la vez.**
6. Realiza **una intervención por iteración** y vuelve a medir, idealmente tres ejecuciones por escenario, descartando explícitamente o controlando efectos de cache.
7. Compara impacto en lectura, escritura, espacio, mantenibilidad y comportamiento del planificador.
8. Conserva el plan original, el plan final y los cambios SQL para permitir revertirlos.
9. Explica por qué una mejora para una consulta puede perjudicar otras operaciones.

**Precaución:** `EXPLAIN ANALYZE` ejecuta realmente la sentencia; úsalo solo en consultas de lectura durante esta misión. No modifiques `postgresql.conf` globalmente sin snapshot/bitácora.

**Preguntas:** ¿siempre es conveniente crear índices? ¿cuándo un `Seq Scan` es correcto? ¿qué significa una estimación equivocada? ¿por qué medir en la misma instancia/tamaño de dataset?

**Evidencias:** tabla antes/después de dos consultas, planes reales completos, hipótesis, script de modificación SQL, costos, riesgos y explicación del resultado.

## 7. Misión F — Defensa y entrega

Elabora el informe siguiendo `plantillas/informe.md` y adjunta evidencia suficiente. Entrega un PDF en Canvas (con comandos **explicados**, no solo capturas). Deja fuera contraseñas, secretos y direcciones que no deban hacerse públicas.

**Preguntas de defensa:** ¿qué recuperarías primero ante caída total de la EC2? ¿cómo te asegurarías de que un dump no está corrupto? ¿qué dependencias necesita el restore? ¿por qué tu optimización funcionó o no? ¿qué harías diferente con un SLO de disponibilidad?

## Cronograma recomendado

| Fase | Tiempo orientativo |
|---|---:|
| Introducción, inventario y AWS Academy | 30 min |
| Instalación, esquema y datos | 35 min |
| Respaldo y validación | 30 min |
| Incidente y restauración | 35 min |
| Primera optimización medible | 35 min |
| Cierre, bitácora y defensa | 15 min |

**Total recorrido mínimo: 180 min.** Para dos consultas optimizadas, análisis comparativo profundo, RPO/RTO y documentación completa se sugiere trabajo adicional o segunda sesión. El docente puede flexibilizar tiempos.

## Criterios de éxito

Se considera logrado el laboratorio cuando el alumno **demuestra** que la base fue recuperada en un destino seguro y que al menos dos consultas fueron analizadas rigurosamente. El rendimiento no necesita mejorar necesariamente: un resultado nulo, si está bien medido y explicado, es mejor que inventar un éxito.

Consulta la [rúbrica](rubrica.md) antes de comenzar.
