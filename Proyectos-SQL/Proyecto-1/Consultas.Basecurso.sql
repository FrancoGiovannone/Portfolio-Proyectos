#Traer las fechas, números de factura y monto total de mis ventas.
SELECT Ventas_Fecha,Ventas_NroFactura,Ventas_Total
FROM ventas

#Traer los ID de productos, cantidad y precio de mi detalle de ventas de los registros donde el 
#precio sea mayor a 0.
SELECT VD_ProdId,VD_Cantidad, VD_Precio
FROM ventas_detalle
WHERE VD_Precio>0

#Traer el total vendido por fecha de factura
SELECT Ventas_Fecha AS Fecha, sum(Ventas_Total) AS Total
FROM ventas
GROUP BY Fecha

#Traer el total vendido por año y mes de factura
SELECT year(Ventas_Fecha) AS Año,MONTH(Ventas_Fecha) AS Mes, sum(Ventas_Total) AS Total
FROM ventas
GROUP BY Año, Mes

#Traer los productos de la tabla productos que pertenezcan al proveedor 62.
SELECT *
FROM productos
WHERE Prod_ProvId = 62

#Traer la lista de productos vendidos (solo su ID) sin repeticiones
#y con el total vendido por cada uno. Ordenados por Total Vendido de manera descendente
SELECT VD_ProdId AS 'Producto ID', SUM((VD_Cantidad * VD_Precio)) 'Total Vendido'
FROM ventas_detalle
GROUP BY 1
ORDER BY 2 DESC

#Traer fecha de factura, nro de factura, id de cliente, razón social del cliente y monto total vendido.
SELECT Ventas_Fecha AS Fecha,
       Ventas_NroFactura AS Factura,
       Ventas_CliId AS ID,
       Cli_RazonSocial AS RS,
       Ventas_Total AS Total
FROM ventas
JOIN clientes ON Ventas_CliId=Cli_Id

#Traer fecha de factura, nro de factura, id de producto, descripción del producto,
#Id de proveedor, nombre proveedor, cantidad, precio unitario y parcial (cantidad * precio).
SELECT Ventas_Fecha AS Fecha, Ventas_NroFactura AS NroFactura,
       VD_ProdId AS ProdID, Prod_Descripcion AS Descripcion,
       Prod_ProvId AS ProvId, Prov_Nombre AS Proveedor,
       VD_Cantidad AS Cantidad, VD_Precio AS PrecioUnitario, 
		 (VD_Cantidad * VD_Precio) AS Parcial
FROM ventas
JOIN  ventas_detalle ON ventas.Ventas_Id = ventas_detalle.VD_VentasId
JOIN productos ON ventas_detalle.VD_ProdId = productos.Prod_Id
JOIN proveedores ON proveedores.Prov_Id = productos.Prod_ProvId

#Traer todos los productos que hayan sido vendidos entre el 14/01/2018 y
#el 16/01/2018 (sin repetir) y calculando la cantidad de unidades vendidas.
SELECT Prod_Id AS Codigo,
       Prod_Descripcion AS Descripcion,
       SUM(VD_Cantidad) AS 'Unidades Vendidas'
FROM productos
JOIN ventas_detalle ON VD_ProdId = Prod_Id
JOIN ventas ON Ventas_Id = VD_VentasId
WHERE Ventas_Fecha BETWEEN '2018-01-14' AND '2018-01-16'
GROUP BY 1
ORDER BY 1 ASC

#Traer todos los artículos cuya descripción tenga el string 'CINTA' y que tengan ventas realizadas.
SELECT distinct(Prod_Descripcion), Prod_Id
FROM productos
JOIN ventas_detalle ON ventas_detalle.VD_ProdId = productos.Prod_Id
WHERE Prod_Descripcion LIKE '%cinta%'
#Otra forma de hacerlo
SELECT Prod_Id, Prod_Descripcion
FROM productos
WHERE Prod_Id IN (SELECT VD_ProdId FROM ventas_detalle) AND Prod_Descripcion LIKE '%CINTA%'

#Traer todos los artículos cuya descripción comience con la palabra subterraneo.
SELECT * FROM productos
WHERE Prod_Descripcion LIKE 'subterraneo%'

#Traer todos los artículos que en su descripción o color o nombre de proveedor tenga el 
#string 'FERRO'.
SELECT Prod_Id, Prod_Descripcion, Prod_Color,Prov_Nombre
FROM productos
JOIN proveedores ON Prod_ProvId = Prov_Id
WHERE CONCAT(Prod_Descripcion, Prod_Color,Prov_Nombre) LIKE '%ferro%'
#WHERE Prod_Id LIKE '%ferro%' OR Prod_Descripcion LIKE '%ferro%' OR Prov_Nombre LIKE '%ferro%'


#traer la cantidad de productos que han sido vendidos
SELECT COUNT(DISTINCT(VD_ProdId)) AS cantidad
FROM productos
JOIN ventas_detalle ON VD_ProdId=Prod_Id

#Hago el join con la tabla detalle porque puede haber productos en la tabla detalle que ya no se venden
#es para asegurarse que esten en la tabla productos

#Traer el total vendido de los productos que fueron vendidos entre el 02/01/2018 y el 10/01/2018 
#y cuyo proveedor se encuentre entre el 2 y el 100.
SELECT SUM(VD_Precio*VD_Cantidad) AS 'Total'
FROM ventas_detalle
JOIN productos ON VD_ProdId=Prod_Id
JOIN ventas ON VD_VentasId=Ventas_Id
WHERE (Ventas_Fecha BETWEEN '2018-01-02' AND '2018-01-10') AND (Prod_ProvId BETWEEN 2 AND 100)

#Traer la factura de valor máximo, que haya tenido en sus items vendidos, el producto 656.
SELECT MAX(Ventas_Total)
FROM ventas
JOIN ventas_detalle ON VD_VentasID = Ventas_Id
WHERE VD_ProdId = 656

