-- Consultas de validación para comparar línea base y base restaurada.
-- Registra resultados reales en tu bitácora: aquí no se facilitan números esperados.
SELECT current_database() AS base, now() AS fecha_verificacion, version() AS version;
SELECT 'clientes' AS entidad, count(*) AS filas FROM novastore.clientes
UNION ALL SELECT 'productos',count(*) FROM novastore.productos
UNION ALL SELECT 'pedidos',count(*) FROM novastore.pedidos
UNION ALL SELECT 'pedido_detalle',count(*) FROM novastore.pedido_detalle
UNION ALL SELECT 'eventos_auditoria',count(*) FROM novastore.eventos_auditoria;
SELECT estado, count(*) AS pedidos, sum(total) AS monto
FROM novastore.pedidos GROUP BY estado ORDER BY estado;
SELECT count(*) AS pedidos_sin_cliente FROM novastore.pedidos p
LEFT JOIN novastore.clientes c USING (cliente_id)
WHERE c.cliente_id IS NULL;
SELECT count(*) AS detalles_sin_pedido FROM novastore.pedido_detalle d
LEFT JOIN novastore.pedidos p USING (pedido_id)
WHERE p.pedido_id IS NULL;
SELECT count(*) AS detalles_sin_producto FROM novastore.pedido_detalle d
LEFT JOIN novastore.productos p USING (producto_id)
WHERE p.producto_id IS NULL;
SELECT pg_size_pretty(pg_database_size(current_database())) AS tamano_base;
