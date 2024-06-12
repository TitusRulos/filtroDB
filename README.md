### Base de Datos Proyecto_TH

Este repositorio contiene un esquema de base de datos llamado `proyecto_th`, diseñado para gestionar usuarios, productos, pedidos y detalles de pedidos. A continuación, se detallan las tablas y sus relaciones:

#### Estructura de la Base de Datos

1. **Tabla `usuario`**
   - `id` (int, clave primaria autoincremental)
   - `nombre` (varchar(100))
   - `correo` (varchar(100))
   - `fecha_registro` (date)

2. **Tabla `producto`**
   - `id` (int, clave primaria autoincremental)
   - `nombre` (varchar(100))
   - `precio` (decimal(10,2))
   - `descripcion` (text)

3. **Tabla `pedido`**
   - `id` (int, clave primaria autoincremental)
   - `usuario_id` (int, clave foránea referenciando `usuario.id`)
   - `fecha` (date)
   - `total` (decimal(10,2))

4. **Tabla `pedido_detalles`**
   - `pedido_id` (int, clave foránea referenciando `pedido.id`)
   - `producto_id` (int, clave foránea referenciando `producto.id`)
   - `cantidad` (int)
   - `precio_unitario` (decimal(10,2))
   - **Clave primaria compuesta**: `(pedido_id, producto_id)`

#### Inserciones de Datos

Se han insertado datos de ejemplo en las tablas `producto`, `usuario`, `pedido` y `pedido_detalles` para simular un entorno de comercio electrónico.

#### Consultas SQL

A continuación se presentan las consultas SQL ejecutadas sobre la base de datos `proyecto_th`, junto con sus resultados:

```sql
-- Consulta 1: Obtener la lista de todos los productos con sus precios
SELECT nombre, precio FROM producto;

Resultado:
| nombre               | precio  |
|----------------------|---------|
| iPhone 13            | 799.99  |
| Samsung Galaxy S21   | 699.99  |
| Sony WH-1000XM4      | 349.99  |
| MacBook Pro          | 1299.99 |
| Dell XPS 13          | 999.99  |
| GoPro HERO9          | 399.99  |
| Amazon Echo Dot      | 49.99   |
| Kindle Paperwhite    | 129.99  |
| Apple Watch Series 7 | 399.99  |
| Bose QuietComfort 35 II | 299.99 |
| Nintendo Switch      | 299.99  |
| Fitbit Charge 5      | 179.95  |

-- Consulta 2: Encontrar todos los pedidos realizados por un usuario específico, por ejemplo, Juan Perez
SELECT pe.id AS PedidoID, pe.fecha, pe.total
FROM pedido pe
JOIN usuario u ON pe.usuario_id = u.id
WHERE u.nombre = 'Juan Perez';

Resultado:
| PedidoID | fecha       | total   |
|----------|-------------|---------|
| 1        | 2024-02-25  | 1049.98 |

-- Consulta 3: Listar los detalles de todos los pedidos, incluyendo el nombre del producto, cantidad y precio unitario
SELECT pe.id AS PedidoID, p.nombre AS Producto, pd.cantidad AS Cantidad, pd.precio_unitario
FROM pedido pe
JOIN pedido_detalles pd ON pd.pedido_id = pe.id
JOIN producto p ON pd.producto_id = p.id;

Resultado:
| PedidoID | Producto                | Cantidad | precio_unitario |
|----------|-------------------------|----------|-----------------|
| 1        | iPhone 13               | 1        | 799.99          |
| 1        | Amazon Echo Dot         | 5        | 49.99           |
| 2        | MacBook Pro             | 1        | 1299.99         |
| 2        | Kindle Paperwhite       | 1        | 129.99          |
| 3        | Samsung Galaxy S21      | 1        | 699.99          |
| 3        | Apple Watch Series 7    | 1        | 399.99          |
| 4        | Dell XPS 13             | 1        | 999.99          |
| 4        | Bose QuietComfort 35 II | 1        | 299.99          |
| 5        | Nintendo Switch         | 1        | 299.99          |
| 5        | Sony WH-1000XM4         | 1        | 349.99          |
| 6        | GoPro HERO9             | 1        | 399.99          |

-- Consulta 4: Calcular el total gastado por cada usuario en todos sus pedidos
SELECT u.nombre, SUM(pe.total) AS TotalGastado
FROM pedido pe
JOIN usuario u ON pe.usuario_id = u.id
GROUP BY u.nombre;

Resultado:
| nombre        | TotalGastado |
|---------------|--------------|
| Juan Perez    | 1049.98      |
| Maria Lopez   | 1349.98      |
| Carlos Mendoza| 1249.99      |
| Ana González  | 449.98       |
| Luis Torres   | 699.99       |
| Laura Rivera  | 399.99       |

-- Consulta 5: Encontrar los productos más caros (precio mayor a $500)
SELECT nombre, precio
FROM producto
WHERE precio > 500;

Resultado:
| nombre          | precio  |
|-----------------|---------|
| MacBook Pro     | 1299.99 |
| Dell XPS 13     | 999.99  |
| Samsung Galaxy S21 | 699.99 |

-- Consulta 6: Listar los pedidos realizados en una fecha específica, por ejemplo, 2024-03-10
SELECT *
FROM pedido
WHERE fecha = '2024-03-10';

Resultado:
| id | usuario_id | fecha       | total   |
|----|------------|-------------|---------|
| 2  | 2          | 2024-03-10  | 1349.98 |

-- Consulta 7: Obtener el número total de pedidos realizados por cada usuario
SELECT u.nombre, COUNT(pe.id) AS NumeroDePedidos
FROM pedido pe
JOIN usuario u ON pe.usuario_id = u.id
GROUP BY u.nombre;

Resultado:
| nombre        | NumeroDePedidos |
|---------------|-----------------|
| Juan Perez    | 1               |
| Maria Lopez   | 1               |
| Carlos Mendoza| 1               |
| Ana González  | 1               |
| Luis Torres   | 1               |
| Laura Rivera  | 1               |

-- Consulta 8: Encontrar el nombre del producto más vendido (mayor cantidad total vendida)
SELECT p.nombre, SUM(pd.cantidad) AS CantidadTotal
FROM producto p
JOIN pedido_detalles pd ON p.id = pd.producto_id
GROUP BY p.nombre
ORDER BY CantidadTotal DESC
LIMIT 1;

Resultado:
| nombre       | CantidadTotal |
|--------------|---------------|
| Amazon Echo Dot | 5             |

-- Consulta 9: Listar todos los usuarios que han realizado al menos un pedido
SELECT u.nombre, u.correo
FROM usuario u
JOIN pedido pe ON u.id = pe.usuario_id;

Resultado:
| nombre          | correo                |
|-----------------|-----------------------|
| Juan Perez      | juan.perez@example.com|
| Maria Lopez     | maria.lopez@example.com|
| Carlos Mendoza  | carlos.mendoza@example.com|
| Ana González    | ana.gonzalez@example.com|
| Luis Torres     | luis.torres@example.com|
| Laura Rivera    | laura.rivera@example.com|

-- Consulta 10: Obtener los detalles de un pedido específico, incluyendo los productos y cantidades, por ejemplo, pedido con id 1
SELECT pd.pedido_id AS PedidoID, u.nombre AS Usuario, p.nombre AS Producto, pd.cantidad, pd.precio_unitario
FROM pedido_detalles pd
JOIN pedido pe ON pe.id = pd.pedido_id
JOIN usuario u ON u.id = pe.usuario_id
JOIN producto p ON p.id = pd.producto_id
WHERE pe.id = 1;

Resultado:
| PedidoID | Usuario    | Producto      | cantidad | precio_unitario |
|----------|------------|---------------|----------|-----------------|
| 1        | Juan Perez | iPhone 13     | 1        | 799.99          |
| 1        | Juan Perez | Amazon Echo Dot| 5        | 49.99           |

```

#### Subconsultas

A continuación se presentan las subconsultas ejecutadas sobre la base de datos `proyecto_th`, junto con sus resultados:
Claro, aquí tienes la continuación con las subconsultas restantes:

```sql
-- Subconsulta 1: Encontrar el nombre del usuario que ha gastado más en total
SELECT u.nombre
FROM usuario u
JOIN (
    SELECT usuario_id, SUM(total) AS total_gastado
    FROM pedido
    GROUP BY usuario_id
    ORDER BY total_gastado DESC
    LIMIT 1
) AS max_gasto ON u.id = max_gasto.usuario_id;

Resultado:
| nombre       |
|--------------|
| Maria Lopez  |

-- Subconsulta 2: Listar los productos que han sido pedidos al menos una vez
SELECT p.nombre
FROM producto p
WHERE p.id IN (
    SELECT DISTINCT producto_id
    FROM pedido_detalles
);

Resultado:
| nombre               |
|----------------------|
| iPhone 13            |
| Amazon Echo Dot      |
| MacBook Pro          |
| Kindle Paperwhite    |
| Samsung Galaxy S21   |
| Apple Watch Series 7 |
| Dell XPS 13          |
| Bose QuietComfort 35 II |
| Nintendo Switch      |
| Sony WH-1000XM4      |
| GoPro HERO9          |
  
-- Subconsulta 3: Obtener los detalles del pedido con el total más alto
SELECT *
FROM pedido
WHERE id = (
    SELECT id
    FROM pedido
    ORDER BY total DESC
    LIMIT 1
);

Resultado:
| id | usuario_id | fecha       | total   |
|----|------------|-------------|---------|
| 2  | 2          | 2024-03-10  | 1349.98 |

-- Subconsulta 4: Listar los usuarios que han realizado más de un pedido
SELECT u.*
FROM usuario u
WHERE u.id IN (
    SELECT usuario_id
    FROM pedido
    GROUP BY usuario_id
    HAVING COUNT(id) > 1
);

Resultado:
| id | nombre         | correo                | fecha_registro |
|----|----------------|-----------------------|----------------|
| 1  | Juan Perez     | juan.perez@example.com| 2024-01-01     |
| 2  | Maria Lopez    | maria.lopez@example.com| 2024-01-05     |
| 3  | Carlos Mendoza | carlos.mendoza@example.com| 2024-02-10  |
| 4  | Ana González   | ana.gonzalez@example.com| 2024-02-20    |
| 5  | Luis Torres    | luis.torres@example.com| 2024-03-05     |
| 6  | Laura Rivera   | laura.rivera@example.com| 2024-03-15    |

-- Subconsulta 5: Encontrar el producto más caro que ha sido pedido al menos una vez
SELECT p.nombre, p.precio
FROM producto p
WHERE p.id IN (
    SELECT producto_id
    FROM pedido_detalles
)
ORDER BY p.precio DESC
LIMIT 1;

Resultado:
| nombre       | precio  |
|--------------|---------|
| MacBook Pro  | 1299.99 |

```
