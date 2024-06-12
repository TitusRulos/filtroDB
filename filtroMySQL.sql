create database proyecto_th;
use proyecto_th;

create table usuario(
	id int primary key auto_increment,
	nombre varchar(100),
	correo  varchar(100),
	fecha_registro date
);
create table producto(
	id int primary key auto_increment,
	nombre varchar(100),
	precio decimal (10,2),
	descripcion text
);

create table pedido(
	id int primary key auto_increment,
	usuario_id int,
	foreign key (usuario_id) references usuario(id),
	fecha date,
	total decimal(10,2)
);

create table pedido_detalles(
	pedido_id int,
	producto_id int,
	primary key(pedido_id, producto_id),
	foreign key(pedido_id) references pedido(id),
	foreign key(producto_id) references producto(id),
	cantidad int,
	precio_unitario decimal(10,2)
);

/**-----------------------------INSERTS-----------------------------**/

insert into producto(nombre, precio, descripcion) values
('iPhone 13', 799.99, 'Apple iPhone 13 con pantalla de 6.1 pulgadas y cámara dual.'),
('Samsung Galaxy S21', 699.99, 'Samsung Galaxy S21 con pantalla de 6.2 pulgadas y cámara triple.'),
('Sony WH-1000XM4', 349.99, 'Auriculares inalámbricos Sony con cancelación de ruido.'),
('MacBook Pro', 1299.99, 'Apple MacBook Pro con pantalla Retina de 13 pulgadas.'),
('Dell XPS 13', 999.99, 'Portátil Dell XPS 13 con pantalla de 13.3 pulgadas y procesador Intel i7.'),
('GoPro HERO9', 399.99, 'Cámara de acción GoPro HERO9 con resolución 5K.'),
('Amazon Echo Dot', 49.99, 'Altavoz inteligente Amazon Echo Dot con Alexa.'),
('Kindle Paperwhite', 129.99, 'Amazon Kindle Paperwhite con pantalla de 6 pulgadas y luz ajustable.'),
('Apple Watch Series 7', 399.99, 'Apple Watch Series 7 con GPS y pantalla Retina siempre activa.'),
('Bose QuietComfort 35 II', 299.99, 'Auriculares inalámbricos Bose con cancelación de ruido.'), 
('Nintendo Switch', 299.99, 'Consola de videojuegos Nintendo Switch con controles Joy-Con. '),
('Fitbit Charge 5', 179.95, 'Monitor de actividad física Fitbit Charge 5 con GPS y seguimiento del sueño.');

insert into usuario(nombre, correo, fecha_registro) values
('Juan Perez', 'juan.perez@example.com', '2024-01-01'),
('Maria Lopez', 'maria.lopez@example.com', '2024-01-05'),
('Carlos Mendoza', 'carlos.mendoza@example.com', '2024-02-10'),
('Ana González', 'ana.gonzalez@example.com', '2024-02-20'),
('Luis Torres', 'luis.torres@example.com', '2024-03-05'),
('Laura Rivera', 'laura.rivera@example.com', '2024-03-15');

insert into pedido (usuario_id, fecha, total) values
(1, '2024-02-25', 1049.98),
(2, '2024-03-10', 1349.98),
(3, '2024-03-20', 1249.99),
(4, '2024-03-25', 449.98),
(5, '2024-04-05', 699.99),
(6, '2024-04-10', 399.99);

insert into pedido_detalles(pedido_id, producto_id, cantidad, precio_unitario) values
(1, 1, 1, 799.99),
(1, 7, 5, 49.99),
(2, 4, 1, 1299.99),
(2, 8, 1, 129.99),
(3, 2, 1, 699.99),
(3, 9, 1, 399.99),
(4, 5, 1, 999.99),
(4, 10, 1, 299.99),
(5, 11, 1, 299.99),
(5, 3, 1, 349.99),
(6, 6, 1, 399.99);

/**-----------------------------CONSULTAS---------------------**/

-- 1. Obtener la lista de todos los productos con sus precio 

select p.nombre, p.precio from producto p;

-- 2. Encontrar todos los pedidos realizados por un usuario específico, por ejemplo, Juan Perez

select pe.id, pe.fecha, pe.total
from pedido pe where pe.usuario_id = 1;

-- 3. Listar los detalles de todos los pedidos, incluyendo el nombre del producto, cantidad y precio unitario

select pe.id as PedidoID, p.nombre as Producto, ped.cantidad as cantidad, ped.precio_unitario
from pedido pe
join pedido_detalles ped on ped.pedido_id = pe.id
join producto p on ped.producto_id = p.id;

-- 4. Calcular el total gastado por cada usuario en todos sus pedidos

select u.nombre, pe.total as TotalGastado
from pedido pe
join usuario u on pe.usuario_id = u.id;

-- 5. Encontrar los productos más caros (precio mayor a $500)

select p.nombre, p.precio
from producto p 
where p.precio > 500;

-- 6. Listar los pedidos realizados en una fecha específica, por ejemplo, 2024-03-10

select * from pedido
where fecha = '2024-03-10';

-- 7. Obtener el número total de pedidos realizados por cada usuario

select u.nombre, count(pe.id) as NumeroDePedidos
from pedido pe
join usuario u on pe.usuario_id = u.id
group by u.nombre;

-- 8. Encontrar el nombre del producto más vendido (mayor cantidad total vendida)

select p.nombre, sum(ped.cantidad) as CantidadTotal
from producto p 
join pedido_detalles ped on p.id = ped.producto_id
group by p.nombre
order by CantidadTotal desc limit 1;

-- 9. Listar todos los usuarios que han realizado al menos un pedido

select u.nombre, u.correo
from usuario u
join pedido pe on u.id = pe.usuario_id;

-- 10. Obtener los detalles de un pedido específico, incluyendo los productos y cantidades, por ejemplo, pedido con id 1

select ped.pedido_id as PedidoID, u.nombre as Usuario, p.nombre as Producto, ped.cantidad, ped.precio_unitario
from pedido_detalles ped
join pedido pe on pe.id = ped.pedido_id
join usuario u on u.id = pe.usuario_id
join producto p on p.id = ped.producto_id
where pe.id = 1;

/**-----------------------------------SUBCONSULTAS------------------------**/

-- 1. Encontrar el nombre del usuario que ha gastado más en total

select u.nombre
from usuario u
join (
    select usuario_id, SUM(total) as total_gastado
    from pedido
    group by usuario_id
    order by total_gastado desc
    limit 1
) as max_gasto on u.id = max_gasto.usuario_id;

-- 2. Listar los productos que han sido pedidos al menos una vez

select p.nombre
from producto p
where p.id in (
    select ped.producto_id
    from pedido_detalles ped
);

-- 3. Obtener los detalles del pedido con el total más alto

select pedido.*
from pedido
join (
    select id
    from pedido
    order by total desc
    limit 1
) as max_pedido on pedido.id = max_pedido.id;

-- 4. Listar los usuarios que han realizado más de un pedido
	 
select u.*
from usuario u
join (
    select pe.usuario_id
    from pedido pe
    group by pe.usuario_id
    having count(pe.id) > 1
) as multiples_pedidos on u.id = multiples_pedidos.usuario_id;

-- 5. Encontrar el producto más caro que ha sido pedido al menos una vez

select p.nombre, p.precio
from producto p
where p.precio = (
    select max(precio)
    from producto
    where id in (
        select producto_id
        from pedido_detalles
    )
);

/**-------------------------------PROCEDIMIENTOS-------------------**/


-- 1. Crear un procedimiento almacenado para agregar un nuevo producto

DELIMITER //


create procedure AgregarProducto(
    in p_nombre varchar(100),
    in p_descripcion text,
    in p_precio decimal(10,2)
)
begin
    insert into producto(nombre, descripcion, precio)
    values (p_nombre, p_descripcion, p_precio);
end //

DELIMITER ;

-- 2. Crear un procedimiento almacenado para obtener los detalles de un pedido

DELIMITER //

create procedure ObtenerDetallesPedido(
    in p_pedido_id int
)
begin
    select p.nombre as nombre_producto, pd.cantidad, pd.precio_unitario
    from pedido_detalles pd
    join producto p on pd.producto_id = p.id
    where pd.pedido_id = p_pedido_id;
end //

DELIMITER ;

-- 3. Crear un procedimiento almacenado para actualizar el precio de un producto

DELIMITER //

create procedure ActualizarPrecioProducto(
    in p_producto_id int,
    in p_nuevo_precio decimal(10,2)
)
begin
    update producto
    set precio = p_nuevo_precio
    where id = p_producto_id;
end //

DELIMITER ;

-- 4. Crear un procedimiento almacenado para eliminar un producto

DELIMITER //

create procedure EliminarProducto(
    in p_producto_id int
)
begin
    delete from producto
    where id = p_producto_id;
end //

DELIMITER ;

-- 5. Crear un procedimiento almacenado para obtener el total gastado por un usuario

DELIMITER //

create procedure TotalGastadoPorUsuario(
    in p_usuario_id int,
    out p_total_gastado decimal(10,2)
)
begin
    select sum(p.total) into p_total_gastado
    from pedido p
    where p.usuario_id = p_usuario_id;
end //

DELIMITER ;









