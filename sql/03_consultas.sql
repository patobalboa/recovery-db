-- Consultas base NO OPTIMIZADAS. NO contiene índices sugeridos ni respuestas.
-- Ejecútalas primero como SELECT; investiga los planes con EXPLAIN (ANALYZE, BUFFERS).
-- Ten presente que un EXPLAIN ANALYZE ejecuta la consulta.
\timing on
-- Q1: historial de compras de un cliente (JOIN + rango temporal + sort)
SELECT p.pedido_id, p.fecha, p.estado, p.total
FROM novastore.pedidos p
WHERE p.cliente_id=115
  AND p.fecha >= '2025-06-01'::timestamptz
  AND p.fecha < '2026-07-01'::timestamptz
ORDER BY p.fecha DESC
LIMIT 30;

-- Q2: top de clientes según ventas pagadas desde una fecha
SELECT c.cliente_id, c.segmento, count(*) AS compras, sum(p.total) AS ingreso
FROM novastore.pedidos p
JOIN novastore.clientes c ON c.cliente_id=p.cliente_id
WHERE p.estado='PAGADO' AND p.fecha >= '2025-06-01'::timestamptz
GROUP BY c.cliente_id, c.segmento
ORDER BY ingreso DESC
LIMIT 25;

-- Q3: actividad por canal/estado (agregación)
SELECT canal, estado, date_trunc('month',fecha) AS mes,
       count(*) AS pedidos, sum(total) AS facturacion
FROM novastore.pedidos
WHERE fecha >= '2025-01-01'::timestamptz
GROUP BY canal,estado,date_trunc('month',fecha)
ORDER BY mes,canal,estado;

-- Q4: detalle y productos en una categoría (multi-join)
SELECT pr.categoria, pr.producto_id, pr.nombre, sum(d.cantidad) AS unidades
FROM novastore.pedido_detalle d
JOIN novastore.productos pr ON pr.producto_id=d.producto_id
JOIN novastore.pedidos p ON p.pedido_id=d.pedido_id
WHERE pr.categoria='TECNOLOGIA'
  AND p.estado='PAGADO'
GROUP BY pr.categoria, pr.producto_id, pr.nombre
ORDER BY unidades DESC
LIMIT 20;

-- Q5: búsqueda textual simple (investigar selectividad)
SELECT cliente_id, nombre, email
FROM novastore.clientes
WHERE lower(nombre) LIKE '%cliente 12%'
ORDER BY cliente_id LIMIT 50;
