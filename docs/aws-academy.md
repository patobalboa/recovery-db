# AWS Academy Learner Lab | Preparación y seguridad

Esta guía no asume permisos IAM completos: el Learner Lab puede tener restricciones y presupuesto limitado.

## 1. Inventario de infraestructura

Registra: región, nombre y ID de EC2, sistema operativo, tipo de instancia, IP privada, volumen EBS y capacidad. No copies secretos a entregas. Si tu institución ofrece imágenes o tamaños definidos, respétalos.

**Ruta sugerida:** AWS Academy → Learner Lab → Start Lab → AWS Console → EC2 → Launch instance. Usa una AMI Ubuntu Server que la consola ofrezca y sea compatible con PostgreSQL. Elige almacenamiento suficiente para dataset + artefactos de respaldo; no asumas que todos los laboratorios admiten los mismos tamaños.

## 2. Security Group mínimo

- SSH TCP/22 exclusivamente desde tu IP pública actual o la red indicada por tu docente. No uses `0.0.0.0/0` salvo instrucción justificada y temporal.
- PostgreSQL TCP/5432 **no requiere regla inbound** si trabajas por SSH con `psql` local.
- No publiques usuarios/passwords en repositorios ni reportes.
- Mantén reglas de salida conforme al laboratorio para paquetes Git/apt.
- Diferencia entre firewall de sistema, Security Group, `listen_addresses` y `pg_hba.conf`.

## 3. Comprobaciones Linux

Puedes usar los siguientes comandos **de inventario**, que no resuelven las misiones:

```bash
cat /etc/os-release
hostnamectl
nproc
free -h
lsblk
df -h
ip -br address
systemctl --no-pager status postgresql
ss -lntp | grep 5432 || true
```

## 4. Instalar PostgreSQL

Consulta la documentación de Ubuntu/PostgreSQL según versión de la AMI. En Ubuntu, el repositorio de la distribución puede ofrecer una versión suficientemente reciente para el laboratorio; registra **la versión real** y no mezcles paquetes de distintas versiones sin una justificación. Debes instalar servidor y herramientas cliente compatibles.

En algunas instalaciones Ubuntu se usa el rol de sistema `postgres` y autenticación local `peer`: no presupongas que la contraseña del Linux equivale a la de la base de datos.

**Verifica** `psql --version`, `pg_config --version` y la versión informada por el servidor desde SQL. Si no coinciden, investiga.

## 5. Fallas habituales

| Síntoma | Ruta de diagnóstico |
|---|---|
| No conecta SSH | estado EC2, IP pública variable, IP permitida por SG, usuario de AMI, permisos de clave |
| `psql: command not found` | instalación de cliente, PATH, paquetes |
| `connection refused` | servicio, puerto, escucha y socket |
| `peer authentication failed` | usuario Linux, rol BD y `pg_hba.conf`; no desactivar autenticación por impulso |
| Error de permisos al ejecutar `.sql` | usuario actual, propiedad de BD, ruta del archivo y privilegios |
| No space left on device | `df -h`, EBS y ubicación de respaldo; evitar escribir dumps enormes sin comprobar capacidad |
| Laboratorio AWS finalizado | duración de sesión, persistencia de recursos y políticas del Learner Lab |
| Dataset tarda demasiado | reduce `lab.escala`, confirma CPU/RAM/EBS e informa nueva escala |

## 6. Costos y persistencia

El Learner Lab puede tener presupuesto, bloqueo automático, límites de duración y políticas de limpieza distintas. No presupongas que detener EC2 elimina costos de almacenamiento ni que los datos persisten al cerrar la sesión del laboratorio. Consulta instrucciones de tu curso.

Al finalizar, verifica respaldo de artefactos académicos, apaga/termina recursos según indicación docente y evita dejar EBS, snapshots u otros elementos innecesarios. No elimines recursos antes de respaldar evidencia.

## 7. Resiliencia y seguridad

- Un backup en el mismo disco que la BD comparte su dominio de falla.
- Un snapshot EBS y un `pg_dump` no son lo mismo.
- Una base restaurada en una instancia nueva necesita usuarios, configuraciones, extensiones, conectividad y permisos apropiados.
- Para acceso remoto, investiga SSH tunneling y el principio de menor privilegio antes de abrir 5432.

**Fuentes:** [AWS Academy](https://aws.amazon.com/training/awsacademy/), [EC2 Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html), [Conexión a instancias Linux](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-to-linux-instance.html), [Documentación PostgreSQL](https://www.postgresql.org/docs/current/).
