-- Dataset reproducible. Ejecutar DESPUÉS de sql/01_esquema.sql.
-- Para modificar escala antes de correr: psql -v escala=1 -f sql/02_datos.sql
-- escala=1: 5 000 clientes, 600 productos, 40 000 pedidos, 120 000 detalles.
-- escala=2 duplica volúmenes. escala=0 NO permitida.
-- Solo ejecutar en una BD de laboratorio vacía: se impide duplicación accidental.
\set ON_ERROR_STOP on
\if :{?escala}
\else
\set escala 1
\endif
SELECT CASE WHEN :escala::integer BETWEEN 1 AND 10 THEN 'OK'
  ELSE 1/0::text END AS escala_valida;
-- Protege contra recarga accidental sin borrar datos existentes
DO $$
BEGIN
  IF (SELECT count(*) FROM novastore.clientes)>0 OR
     (SELECT count(*) FROM novastore.pedidos)>0 THEN
    RAISE EXCEPTION 'El dataset ya tiene datos. Use una base nueva; no se hizo TRUNCATE.';
  END IF;
END $$;
BEGIN;
INSERT INTO novastore.clientes (nombre,email,segmento,region,creado_en)
SELECT 'Cliente '||g, 'cliente'||g||'@example.test',
       (ARRAY['PERSONA','PYME','EMPRESA'])[(g % 3)+1],
       (ARRAY['Biobío','Ñuble','Araucanía','Metropolitana'])[(g % 4)+1],
       '2025-01-01'::timestamptz + (g % 400)*interval '1 day'
FROM generate_series(1,5000*:escala) AS g;

INSERT INTO novastore.productos (sku,nombre,categoria,precio,activo)
SELECT 'SKU-'||lpad(g::text,6,'0'), 'Producto '||g,
       (ARRAY['TECNOLOGIA','HOGAR','LIBROS','OFICINA'])[(g % 4)+1],
       (1000 + (g % 500)*170)::numeric(12,2), (g % 20 <> 0)
FROM generate_series(1,600*:escala) AS g;

INSERT INTO novastore.pedidos (cliente_id,fecha,estado,canal,total)
SELECT 1 + ((g*17) % (5000*:escala)),
       '2025-01-01'::timestamptz + (g % 600)*interval '1 day' + (g % 24)*interval '1 hour',
       CASE WHEN g % 10 < 7 THEN 'PAGADO' WHEN g % 10 < 9 THEN 'PENDIENTE' ELSE 'CANCELADO' END,
       (ARRAY['WEB','MOBILE','TIENDA'])[(g % 3)+1],
       (10000 + (g % 500)*79)::numeric(14,2)
FROM generate_series(1,40000*:escala) AS g;

INSERT INTO novastore.pedido_detalle(pedido_id,producto_id,cantidad,precio_unitario)
SELECT 1 + ((g-1)/3),
       1 + ((g*13)%(600*:escala)),
       1 + (g % 4),
       (1000 + (g % 500)*170)::numeric(12,2)
FROM generate_series(1,120000*:escala) AS g;

INSERT INTO novastore.eventos_auditoria(entidad,entidad_id,accion,ocurrido_en)
SELECT 'pedido', pedido_id, 'CREACION', fecha FROM novastore.pedidos
WHERE pedido_id % 5=0;
COMMIT;
-- El estudiante decide si y cómo actualizar estadísticas. Documentar antes/después.
SELECT 'Carga finalizada' AS resultado;
