-- 01. Procedimiento para insertar un nuevo cliente en la tabla usuarios.
delimiter //

create procedure nuevo_cliente (
	in p_nombre varchar(100),
    in p_apellido varchar(100),
    in p_telefono varchar(50),
    in p_correo varchar(150),
    in p_idRol int
)
begin 
	insert into usuarios (nombreCliente, apellidoCliente, telefonoCliente, correoCliente, rol_id) values
    (p_nombre, p_apellido, p_telefono, p_correo, p_idRol);
end //
delimiter ;

call nuevo_cliente ("Camila", "Hernandez", "3506907856", "camilahernandez@gmail.com", 2);

-- 02. Procedimiento para registrar una nueva venta con su monto total y cliente asociado.
delimiter //
create procedure agregar_venta(
	in p_fecha date,
	in p_monto int,
    in p_idRol int,
    in p_idCliente int
)
begin
	insert into ventas(fechaVenta, montoTotal, rol_id, cliente_id) values
    (p_fecha, p_monto, p_idRol, p_idCliente);
end//

delimiter ;

call agregar_venta ("2025-09-25", 90000, 1, 6);


-- 03. Procedimiento para agregar un producto a una venta específica.
 delimiter //
 
 create procedure producto_venta (
	in p_venta_id int,
    in p_ventas_idCliente int,
    in p_rol_id int,
    in p_producto_id int
 )
begin
	insert into ventas_has_productos (venta_id, ventas_idCliente, rol_id, producto_id)
    values
    (p_venta_id, p_ventas_idCliente, p_rol_id, p_producto_id);
end//

delimiter ;

call producto_venta(5, 6, 2, 11);

-- 04. Procedimiento para actualizar el precio de un producto dado su ID.
delimiter //
create procedure actualizar_precio(
	in p_idProd int, 
    in p_precio float)
begin
	update productos
		set precio = p_precio 
        where idProducto = p_idProd;
end//
delimiter ;

call actualizar_precio (4, 55);


-- 05. Procedimiento para eliminar un producto de una venta.
delimiter //

create procedure eliminar_producto_venta(
	in p_venta int,
    in p_producto int
)
begin
    delete from ventas_has_productos
	where venta_id = p_venta and producto_id = p_producto;

end//

delimiter ;

call eliminar_producto_venta(1, 2);


-- 06. Procedimiento para consultar el historial de ventas de un cliente por su ID.
delimiter //
create procedure consultar_ventas_usuario(
	in p_idUsuario int
)
begin
	select * from ventas where cliente_id = p_idUsuario;
end //
delimiter ;

call consultar_ventas_usuario(2);

-- 07. Procedimiento para calcular y devolver el promedio de ventas por cliente.
delimiter //
create procedure promedio_ventas_cliente(
	in p_idCliente int
)
begin
	select round(avg(montoTotal), 2) from ventas
    group by cliente_id
    having cliente_id = p_idCliente;
end//
delimiter ;
    
call promedio_ventas_cliente(1);
    
-- 08. Procedimiento para listar todos los productos de una categoría específica.
delimiter //
create procedure prod_categoria(
	p_categoria varchar(100)
)
begin
	select * from productos
    where categoria = p_categoria;
end//
delimiter ;

call prod_categoria("Alimentos");

-- 09. Procedimiento para consultar los productos vendidos en un rango de fechas.
delimiter //
create procedure prods_fecha (
	p_fecha1 date,
    p_fecha2 date
)
begin
select p.nombreProducto, v.fechaVenta
	from ventas v
    join detalleVenta_has_productos dvp on dvp.detalleVenta_idVenta = v.idVenta
    join productos p on dvp.producto_id = p.idProducto
	where v.fechaVenta between p_fecha1 and p_fecha2;
end//
delimiter ;
call prods_fecha('2025-04-01','2025-10-30');

-- 10. Procedimiento para mostrar los clientes que no han realizado ninguna compra.
delimiter //
create procedure cliente_sin_compras()
begin
select * from usuarios where idCliente not in(
	select cliente_id from ventas);
end//
delimiter ;

call cliente_sin_compras;

-- 11. Procedimiento para registrar una nueva reserva asociada a un cliente.
delimiter //
create procedure nueva_reserva(
	in p_fecha date,
    in p_fechaRealizacion timestamp,
    in p_idCliente int,
    in p_idRol int)
begin
	insert into reservas(fechaReserva, fechaRealizacion, cliente_id, rol_id)
    values
    (p_fecha, p_fechaRealizacion, p_idCliente, p_idRol);
end //
delimiter ;
call nueva_reserva('2025-12-25', current_timestamp, 6, 2);

-- 12. Procedimiento para consultar los productos vendidos en la venta con mayor montoTotal.
delimiter //
create procedure productos_mayor_venta()
begin
	select p.*
	from productos p
	join ventas_has_productos vp on vp.producto_id = p.idProducto
	join ventas v on v.idVenta = vp.venta_id
	where v.montoTotal = (select max(montoTotal) from ventas);

end//
delimiter ;

call productos_mayor_venta();

-- 13. Procedimiento para obtener los detalles de venta cuyo precio supera el promedio general.
delimiter //
create procedure mayores_ventas()
begin
	select dv.*, v.montoTotal
	from detalleVenta dv
	join ventas v on dv.cliente_id = v.idVenta
	where v.montoTotal > (
		select round(avg(montoTotal), 2) from ventas);
end//
delimiter ;

call mayores_ventas();

-- 14. Procedimiento para mostrar los clientes que compraron productos con precio 
--     superior al promedio de su categoría.
delimiter //
create procedure compra_producto_categoria(
	in p_categoria varchar(50))
begin
	select u.*, p.nombreProducto
	from usuarios u
	join ventas_has_productos vp on vp.ventas_idCliente = u.idCliente
	join productos p on p.idProducto = vp.producto_id
	where p.precio > (
	select round(avg(precio),2) from productos where categoria = p_categoria);
end//
delimiter ;

call compra_producto_categoria("alimentos");

