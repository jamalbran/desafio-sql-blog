\echo '1. Crear base de datos llamada blog.'

DROP DATABASE blog;
CREATE DATABASE blog;

\c blog;

\echo '2. Crear las tablas indicadas de acuerdo al modelo de datos.'

CREATE TABLE usuarios(
    id INT,
    email VARCHAR,
    PRIMARY KEY(id)
);

CREATE TABLE posts(
    id INT,
    usuario_id INT,
    titulo VARCHAR,
    fecha DATE,
    PRIMARY KEY(id),
    FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE comentarios(
    id INT,
    usuario_id INT,
    post_id INT,
    texto VARCHAR,
    fecha DATE,
    PRIMARY KEY(id),
    FOREIGN KEY(post_id) REFERENCES posts(id),
    FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

\echo '3. Insertar los siguientes registros.'

\COPY usuarios FROM 'usuarios.csv' CSV;

\COPY posts FROM 'posts.csv' CSV;

\COPY comentarios FROM 'comentarios.csv' CSV;

\echo '4. Seleccionar el correo, id y título de todos los post publicados por el usuario 5.'

SELECT p.id, u.email, p.titulo 
  FROM usuarios u 
  LEFT JOIN posts p ON u.id = p.usuario_id 
  WHERE u.id = 5; 

\echo '5. Listar el correo, id y el detalle de todos los comentarios que no hayan sido realizados por el usuario con email ​usuario06@hotmail.com.​'

SELECT u.email, c.id, c.texto 
  FROM comentarios c 
  FULL OUTER JOIN usuarios u ON c.usuario_id = u.id 
  WHERE u.email <> 'usuario06@hotmail.com' 
    AND c.id IS NOT NULL;

\echo '6. Listar los usuarios que no han publicado ningún post.'

SELECT usuarios.email 
  FROM usuarios u
  LEFT JOIN posts p ON u.id = p.usuario_id 
  WHERE p.id IS NULL;

\echo '7. Listar todos los post con sus comentarios (incluyendo aquellos que no poseen comentarios).'

SELECT * FROM posts p
  FULL OUTER JOIN comentarios c ON p.id = c.post_id;

\echo '8. Listar todos los usuarios que hayan publicado un post en Junio.'

SELECT DISTINCT(u.email) 
  FROM usuario u 
  LEFT JOIN post p ON u.id = p.usuario_id 
  WHERE EXTRACT(MONTH FROM p.fecha) = 6; 
