-- CONSULTAS FOODHUB
-- 1.	Mostrar todos los usuarios registrados en el sistema.
select * from usuarios;

-- 2.	Listar todos los productos disponibles con su categoría.
select * from productos order by categoria;

-- 3.	Obtener todas las ventas realizadas en septiembre de 2025.
select * from ventas where month(fechaVenta) = 09;

-- 4.	Consultar los detalles de venta para una venta específica.
select * from detalleVenta where venta_id = 3;

-- 5.	Mostrar las reservas realizadas por un cliente en particular.
select * from reservas where cliente_id = 2;

-- 6.	Listar los productos vendidos en una venta específica.
select p.nombreProducto 
from productos p
join detalleVenta_has_productos dvp on p.idProducto = dvp.producto_id
where dvp.detalleVenta_idVenta = 1; 
 
-- 7.	Ver el historial de ventas de un cliente.
select * from detalleVenta where cliente_id = 1;

-- 8.	Mostrar los productos que pertenecen a la categoría "Alimentos".
SELECT * FROM productos WHERE categoria = 'alimentos';

-- 9.	Consultar los usuarios que tienen el rol de "Administrador".
select u.nombreCliente,u.apellidoCliente, r.rol 
from usuarios u
join roles r where rol = 'administrador';

-- 10.	Listar todas las ventas que superen los $100.00.
select * from ventas where montoTotal > 100;

-- 11.	Calcular el total de ventas realizadas por cada cliente.
select u.nombreCliente, count(*) 
from ventas v
join usuarios u on u.idCliente = v.cliente_id
group by v.cliente_id;

-- 12.	Obtener el monto total vendido por categoría de producto.
select p.categoria, sum(p.precio) as totalVendido
from ventas_has_productos vp 
join productos p on vp.producto_id = p.idProducto
group by p.categoria;

-- 13.	Contar cuántas reservas ha hecho cada cliente.
select u.idCliente, u.nombreCliente, r.cliente_id
from reservas r
left join usuarios u on r.cliente_id = u.idCliente
group by r.cliente_id, u.nombreCliente, u.idCliente;

-- 14.	Calcular el promedio de montoTotal en todas las ventas.
select avg(montoTotal) as promedioVentas from ventas;

-- 15.	Mostrar el producto más vendido por cantidad.
select p.nombreProducto, count(dp.producto_id) as productoMasVendido
from productos p
join detalleVenta_has_productos dp on dp.producto_id = p.idProducto
group by p.nombreProducto, dp.producto_id
order by dp.producto_id desc limit 1; 

-- 16.	Listar los clientes con 2 o mas ventas registradas.
select u.nombreCliente, u.apellidoCliente, u.correoCliente 
from usuarios u
join ventas v on v.cliente_id = u.idCliente
group by v.cliente_id, u.nombreCliente, u.apellidoCliente, u.correoCliente
having count(v.cliente_id) >= 2;

-- 17.	Calcular el total recaudado por cada tipo de rol.
select r.rol, sum(v.montoTotal) as totalRecaudado
from ventas v 
join roles r on v.rol_id = r.idRol
group by r.rol; 

-- 18.	Obtener el número de productos vendidos por cada cliente.
select u.nombreCliente, u.apellidoCliente, count(vp.producto_id) as cantProductos
from usuarios u
join ventas v on v.cliente_id = u.idCliente
join ventas_has_productos vp on vp.venta_id = v.idVenta
group by u.nombreCliente, u.apellidoCliente;

-- 19.	Mostrar el total de productos vendidos por fecha.
select v.fechaVenta, count(*) as cantProductos
from ventas_has_productos vp
join ventas v on vp.venta_id = v.idVenta
group by v.fechaVenta;

-- 20.	Ver el total de ingresos generados por cada producto.
select p.nombreProducto, sum(p.precio)
from ventas_has_productos vp
left join productos p on p.idProducto = vp.producto_id
group by vp.producto_id, p.precio;

-- 21.	Mostrar los productos asociados a cada detalle de venta.
select p.nombreProducto as prodVendido, vp.venta_id as venta
from productos p
join ventas_has_productos vp on vp.producto_id = p.idProducto;

-- 22.	Consultar los productos vendidos por cada cliente.
select p.nombreProducto as prodVendido, u.nombreCliente as cliente
from ventas_has_productos vp 
join usuarios u on u.idCliente = vp.ventas_idCliente
join productos p on vp.producto_id = p.idProducto
group by u.idCliente, p.nombreProducto;

-- 23.	Listar los clientes que compraron productos de la categoría "Servicios".
select u.nombreCliente as cliente, p.categoria
from ventas_has_productos vp
join usuarios u on u.idCliente = vp.ventas_idCliente
join productos p where p.categoria = 'Servicios'
group by u.nombreCliente;

-- 24.	Ver los productos que aparecen en ambas tablas: detalleVenta_has_productos y ventas_has_productos.
select p.idProducto, p.nombreProducto as producto
from productos p
join detalleVenta_has_productos dvp on dvp.producto_id = p.idProducto
join ventas_has_productos vp on dvp.producto_id = vp.producto_id
group by p.nombreProducto, p.idProducto;

-- 25.	Mostrar las ventas que incluyen más de un producto.
select v.idVenta, v.fechaVenta
from ventas v
join ventas_has_productos vp on v.idVenta = vp.venta_id
group by v.idVenta
having count(vp.producto_id) > 1;

-- 26.	Consultar los clientes que han hecho reservas y también han realizado ventas.
select u.nombreCliente
from usuarios u 
join ventas v on v.cliente_id = u.idCliente
join reservas r where v.cliente_id = r.cliente_id
group by u.nombreCliente;

-- 27.	Ver los productos comprados por clientes con rol "Cliente".
select p.nombreProducto, u.nombreCliente
from usuarios u
join roles r on r.idRol = u.rol_id
join ventas_has_productos vp on vp.ventas_idCliente = u.idCliente
join productos p on p.idProducto = vp.producto_id
order by u.nombreCliente;

-- 28.	Mostrar los detalles de venta junto con el nombre del producto.
select d.idDetalleVenta as detalleVenta, 
d.cantidad, 
d.precio as precioUnitario, 
d.venta_id, 
d.cliente_id as cliente, 
p.nombreProducto as producto
from productos p
inner join detalleVenta_has_productos dvp on p.idProducto = dvp.producto_id
inner join detalleVenta d on dvp.detalleVenta_id = d.idDetalleVenta;


-- 29.	Consultar las ventas que incluyen productos de más de una categoría.
SELECT vp.venta_id
FROM ventas_has_productos vp
JOIN productos p ON vp.producto_id = p.idProducto
GROUP BY vp.venta_id
HAVING COUNT(DISTINCT p.categoria) > 1;

-- 30.	Ver los clientes que han comprado productos de la categoría "Ropa" y "Alimentos".
select u.nombreCliente, u.apellidoCliente
from usuarios u
join detalleVenta_has_productos dvp on dvp.detalleVenta_cliente_id = u.idCliente
join productos p on p.idProducto = dvp.producto_id
where p.categoria in ('Ropa', 'Alimentos')
group by u.idCliente, u.nombreCliente, u.apellidoCliente;


-- SUBCONSULTAS FOODHUB---------------------------------------------------------------------------------------

-- 1.	Mostrar los clientes cuyo total de ventas supera el promedio general.
select * from usuarios where idCliente in(
	select cliente_id
	from ventas
	group by cliente_id
	having avg(montoTotal) > (
		select avg(montoTotal) from ventas));
			
-- 2.	Listar los productos cuyo precio es mayor al precio promedio de todos los productos.
select * from productos where precio >
	(select avg(precio) from productos);

-- 3.	Consultar los clientes que han comprado el producto más vendido.
select distinct u.* 
from usuarios u 
join ventas_has_productos vp on vp.ventas_idCliente = u.idCliente
where vp.producto_id in (
	SELECT producto_id
	FROM ventas_has_productos
	GROUP BY producto_id
	HAVING COUNT(*) = (
		SELECT MAX(cantidad)
		FROM (
			SELECT COUNT(*) AS cantidad
			FROM ventas_has_productos
			GROUP BY producto_id
		) AS conteos
));

-- 4.	Ver las ventas que contienen productos con precio mayor al promedio.
select v.* 
from ventas v
join ventas_has_productos vp on v.cliente_id = vp.ventas_idCliente
where vp.producto_id in (
	select idProducto from productos where precio >
		(select avg(precio) from productos));

-- 5.	Mostrar los productos que no han sido vendidos nunca.
select * from productos where idProducto not in(
	select producto_id from ventas_has_productos);

-- 6.	Consultar los clientes que no han hecho ninguna reserva.
select * from usuarios where idCliente not in(
	select cliente_id from reservas);

-- 7.	Ver los productos comprados por el cliente con más ventas.
SELECT p.*
FROM productos p
JOIN ventas_has_productos vp ON p.idProducto = vp.producto_id
WHERE vp.ventas_idCliente IN (
    SELECT ventas_idCliente
    FROM ventas_has_productos
    GROUP BY ventas_idCliente
    HAVING COUNT(*) = (
        SELECT MAX(cantidad)
        FROM (
            SELECT COUNT(*) AS cantidad
            FROM ventas_has_productos
            GROUP BY ventas_idCliente
        ) AS sub
    )
);

-- 8.	Mostrar los roles que no tienen usuarios asignados.
select rol from roles where idRol not in (
	select rol_id from usuarios);
    
-- 9.	Consultar las ventas realizadas por clientes que también tienen reservas.
select * from ventas where cliente_id in (
	select v.cliente_id
	from reservas r
	join ventas v on v.cliente_id = r.cliente_id);

-- 10.	Ver los productos comprados por clientes que compraron el producto "Combo Familiar".
select nombreProducto from productos where idProducto in (
	select producto_id from ventas_has_productos where ventas_idCliente in(
		(select ventas_idCliente from ventas_has_productos where producto_id =
			(select idProducto from productos where nombreProducto = 'Combo Familiar'))));

-- 11.	Mostrar los clientes cuyo número de ventas es mayor al promedio.
select * from usuarios where idCliente in (
	select cliente_id from detalleVenta 
	group by cliente_id
	having count(*) > (
		select avg(ventasXcliente) from (
			select count(*) as ventasXcliente from detalleVenta
			group by cliente_id) as ventXcliente));

-- 12.	Consultar los productos vendidos en la venta con mayor montoTotal.
SELECT p.nombreProducto
FROM productos p
JOIN ventas_has_productos vp ON p.idProducto = vp.producto_id
WHERE vp.venta_id = (
    SELECT idVenta
    FROM ventas
    ORDER BY montoTotal DESC
    LIMIT 1
);

-- 13.	Ver los detalles de venta cuyo precio es mayor al precio promedio de todos los detalles.
SELECT *
FROM detalleVenta
WHERE precio > (
    SELECT AVG(precio) FROM detalleVenta
);

-- 14.	Mostrar los clientes que compraron productos cuyo precio supera el promedio de su categoría.
SELECT DISTINCT u.idCliente, u.nombreCliente
FROM usuarios u
JOIN ventas_has_productos vp ON u.idCliente = vp.ventas_idCliente
JOIN productos p ON vp.producto_id = p.idProducto
WHERE p.precio > (
    SELECT AVG(p2.precio)
    FROM productos p2
    WHERE p2.categoria = p.categoria
);

-- 15.	Consultar las ventas que contienen productos vendidos más de una vez.
SELECT *
FROM ventas
WHERE idVenta IN (
    SELECT venta_id
    FROM ventas_has_productos
    GROUP BY venta_id, producto_id
    HAVING COUNT(*) > 1
);


-- 16.	Ver los productos que aparecen en más de una venta.
SELECT *
FROM productos
WHERE idProducto IN (
    SELECT producto_id
    FROM ventas_has_productos
    GROUP BY producto_id
    HAVING COUNT(DISTINCT venta_id) > 1
);



-- 17.	Mostrar los clientes que compraron todos los productos de la categoría "Alimentos".
SELECT u.idCliente, u.nombreCliente
FROM usuarios u
WHERE NOT EXISTS (
    SELECT p.idProducto
    FROM productos p
    WHERE p.categoria = 'Alimentos'
    AND p.idProducto NOT IN (
        SELECT vp.producto_id
        FROM ventas_has_productos vp
        WHERE vp.ventas_idCliente = u.idCliente
    )
);


-- 18.	Consultar los productos que han sido vendidos por más de un cliente.

SELECT *
FROM productos
WHERE idProducto IN (
    SELECT producto_id
    FROM ventas_has_productos
    GROUP BY producto_id
    HAVING COUNT(DISTINCT ventas_idCliente) > 1
);

-- 19.	Ver las reservas realizadas por el cliente con más productos comprados.
SELECT r.*
FROM reservas r
WHERE r.cliente_id = (
    SELECT ventas_idCliente
    FROM ventas_has_productos
    GROUP BY ventas_idCliente
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


-- 20.	Mostrar los productos que han sido comprados por clientes que también tienen el rol "Administrador".

SELECT *
FROM productos
WHERE idProducto IN (
    SELECT producto_id
    FROM ventas_has_productos
    WHERE ventas_idCliente IN (
        SELECT idCliente
        FROM usuarios
        WHERE rol_id = (
			select idRol from roles where rol = 'Administrador')
    )
);

