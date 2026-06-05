CREATE DATABASE CineMaxCesde;
USE CineMaxCesde;

-- Tabla 1: Categorías de películas (Géneros)
CREATE TABLE Categorias (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(250) NOT NULL
);

-- Tabla 2: Películas
CREATE TABLE Peliculas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    TiempoMinutos INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    UltimaFuncion DATE NULL,
    CategoriasId INT NOT NULL,
    CONSTRAINT FK_Peliculas_Categorias FOREIGN KEY (CategoriasId)
        REFERENCES Categorias(Id)
);

-- Tabla 3: Salas de proyección
CREATE TABLE Salas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
);

-- Tabla 4: Clientes del cine
CREATE TABLE Clientes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NOT NULL UNIQUE
);

-- Tabla 5: Funciones (Horarios programados para proyectar películas en salas)
CREATE TABLE Funciones (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PeliculasId INT NOT NULL,
    SalasId INT NOT NULL,
    Fecha DATE NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    CONSTRAINT FK_Funciones_Peliculas FOREIGN KEY (PeliculasId)
        REFERENCES Peliculas(Id),
    CONSTRAINT FK_Funciones_Salas FOREIGN KEY (SalasId)
        REFERENCES Salas(Id)
);

-- ==========================================
-- 3. INSERCIÓN DE DATOS DE EJEMPLO
-- ==========================================

-- Insertar Categorías
INSERT INTO Categorias (Nombre, Descripcion) 
VALUES 
('Terror', 'Contiene escenas de violencia y suspenso'),
('Acción', 'Secuencias de lucha, persecuciones y ritmo frenético'),
('Comedia', 'Contenido diseñado para el humor y la risa'),
('Drama', 'Historias centradas en el desarrollo emocional y conflictos serios'),
('Ciencia Ficción', 'Relatos sobre tecnología futura, espacio o conceptos científicos'),
('Animación', 'Contenido creado mediante técnicas de dibujo o CGI');

-- Insertar Películas
INSERT INTO Peliculas (Nombre, TiempoMinutos, Precio, UltimaFuncion, CategoriasId)
VALUES 
('El Conjuro', 120, 12500.00, '2026-04-29', 1),
('Rápidos y Furiosos 10', 141, 15000.00, '2026-05-01', 2),
('Interestelar', 169, 18000.00, '2026-03-15', 5),
('Toy Story 4', 100, 11000.00, '2026-05-10', 6),
('John Wick 4', 169, 16500.00, '2026-04-20', 2),
('Duna: Parte 2', 166, 19500.00, '2026-05-12', 5),
('Inside Out 2', 100, 13000.00, '2026-05-13', 6),
('Deadpool & Wolverine', 127, 17500.00, '2026-05-13', 2);

-- Insertar Salas
INSERT INTO Salas (Nombre)
VALUES 
('Sala 1 - General'),
('Sala 2 - 3D'),
('Sala 3 - VIP Premium'),
('Sala 4 - General Macro');

-- Insertar Clientes
INSERT INTO Clientes (Nombre, Correo)
VALUES
('Juan Pérez', 'juan.perez@email.com'),
('María Gómez', 'maria.gomez@email.com'),
('Carlos Mendoza', 'carlos.mendoza@email.com'),
('Diana Restrepo', 'diana.restrepo@email.com');

-- Insertar Funciones
INSERT INTO Funciones (PeliculasId, SalasId, Fecha, HoraInicio, HoraFin)
VALUES
(1, 1, '2026-06-05', '14:00:00', '16:00:00'), -- El Conjuro en Sala 1
(7, 2, '2026-06-05', '15:30:00', '17:10:00'), -- Inside Out 2 en Sala 2
(8, 3, '2026-06-05', '18:00:00', '20:07:00'), -- Deadpool & Wolverine en Sala 3
(6, 4, '2026-06-06', '20:00:00', '22:46:00'), -- Duna: Parte 2 en Sala 4
(2, 1, '2026-06-06', '13:00:00', '15:21:00'); -- Rápidos y Furiosos 10 en Sala 1

-- ==========================================
-- 4. CONSULTAS DE EJEMPLO (DML)
-- ==========================================

-- Consulta 1: Listado de películas con sus respectivas categorías
SELECT 
    p.Id AS PeliculaId,
    p.Nombre AS Pelicula,
    p.TiempoMinutos AS Duracion,
    p.Precio,
    c.Nombre AS Categoria
FROM Peliculas p
INNER JOIN Categorias c ON p.CategoriasId = c.Id;

-- Consulta 2: Cartelera programada (Funciones con detalles de película y sala)
SELECT 
    f.Id AS FuncionId,
    p.Nombre AS Pelicula,
    s.Nombre AS Sala,
    f.Fecha,
    f.HoraInicio,
    f.HoraFin,
    p.Precio AS PrecioBoleta
FROM Funciones f
INNER JOIN Peliculas p ON f.PeliculasId = p.Id
INNER JOIN Salas s ON f.SalasId = s.Id
ORDER BY f.Fecha, f.HoraInicio;

-- Consulta 3: Cantidad de películas por categoría
SELECT 
    c.Nombre AS Categoria,
    COUNT(p.Id) AS CantidadPeliculas,
    AVG(p.Precio) AS PrecioPromedio
FROM Categorias c
LEFT JOIN Peliculas p ON c.Id = p.CategoriasId
GROUP BY c.Nombre;

-- Consulta 4: Películas que pertenecen a la categoría 'Acción'
SELECT * 
FROM Peliculas 
WHERE CategoriasId = (SELECT Id FROM Categorias WHERE Nombre = 'Acción');