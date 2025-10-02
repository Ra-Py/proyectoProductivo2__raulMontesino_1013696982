CREATE TABLE Auditoria (
    idAuditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(10),
    detalle TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 01. Trigger AFTER INSERT en la tabla usuarios para registrar la creación de nuevos usuarios en la tabla Auditoria.
drop trigger if exists nuevo_usuario_registro;
delimiter //
create trigger nuevo_usuario_registro
after insert on usuarios
for each row
begin
	insert into Auditoria (tabla_afectada, accion, detalle)
	values
		("Usuarios", "INSERT", 
        concat("Nuevo usuario: ", new.nombreCliente," ", new.apellidoCliente, " Telefono: ", new.telefonoCliente, " Correo: ", new.correoCliente));
end//
delimiter ;

insert into usuarios (nombreCliente, apellidoCliente, telefonoCliente, correoCliente, rol_id)
values ("Juana", "La Cubana", "322548871", "juana@yahoo.com", 1);

insert into usuarios (nombreCliente, apellidoCliente, telefonoCliente, correoCliente, rol_id)
values ("carla", "Orega", "3122548871", "carla@outlook.com", 2);

-- 02. Trigger BEFORE UPDATE en la tabla productos para registrar cambios en el precio o nombre del producto antes de que se apliquen.
delimiter //
create trigger cambio_nombre_precio_prod
before update on productos
for each row
begin
	insert into Auditoria (tabla_afectada, accion, detalle) values
    ("productos", "Update", 
     concat("Nombre anterior: ", old.nombreProducto, 
     " Precio anterior: ", old.precio,
     " Nuevo nombre: ", new.nombreProducto, " Nuevo precio: ", new.precio));
	end//
delimiter ;

update productos
set nombreProducto = "Hamburguesa con Bancon",
	precio = 45
where idProducto = 1;


-- 03. Trigger AFTER DELETE en la tabla reservas para registrar la eliminación de una 
-- reserva con su detalle completo.
drop trigger if exists auditoria_reserva_delete;
delimiter //

create trigger auditoria_reserva_delete
after delete on reservas
for each row
begin
    insert into Auditoria (
        tabla_afectada,
        accion,
        detalle
    )
    values (
        'reservas',
        'delete',
        concat(
            'reserva eliminada: id ', old.idreserva,
            ', cliente: ', old.cliente_id,
            ', fecha: ', old.fechareserva));
end //

delimiter ;

delete from reservas where idReserva = 1;


-- 04. Trigger AFTER INSERT en la tabla ventas para registrar la creación 
-- de una nueva venta con su monto total y cliente asociado.

delimiter //

create trigger auditoria_venta_insert
after insert on ventas
for each row
begin
    insert into Auditoria (
        tabla_afectada,
        accion,
        detalle
    )
    values (
        'ventas',
        'insert',
        concat(
            'venta registrada: id ', new.idventa,
            ', cliente: ', new.cliente_id,
            ', monto total: $', new.montototal
        ));
end//

delimiter ;

insert into ventas (fechaVenta, montoTotal, rol_id, cliente_id) values
('2025-06-25', 300000, 2, 5);


-- 05. Trigger BEFORE UPDATE en la tabla detalleVenta para registrar 
-- modificaciones en el precio o cantidad antes de que se actualicen.

delimiter //

create trigger auditoria_detalleventa_update
before update on detalleVenta
for each row
begin
    insert into Auditoria (
        tabla_afectada,
        accion,
        detalle
    )
    values (
        'detalleventa',
        'update',
        concat(
            'detalle de venta modificado: id ', old.idDetalleVenta,
            ', precio anterior: $', old.precio,
            ', cantidad anterior: ', old.cantidad,
            '|| , nueva cantidad: ', new.cantidad,
            ', nuevo precio: $', new.precio
        ));
end//

delimiter ;

update detalleVenta
set
	cantidad = 2,
    precio = 40
where idDetalleVenta = 1;