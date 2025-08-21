drop database biblioteca;

CREATE DATABASE biblioteca;

USE biblioteca;

CREATE TABLE usuario (
    cpf VARCHAR(11) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(15) NOT NULL
);

CREATE TABLE categoria(
    codigo_categoria INT NOT NULL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE livro(
    codigo_livro INT NOT NULL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    codigo_categorico INT NOT NULL,
    autor VARCHAR(100) NOT NULL,
    FOREIGN KEY (codigo_categorico) REFERENCES categoria(codigo_categoria)
);

CREATE TABLE funcionario(
    cpf VARCHAR(11) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    funcao varchar(50) NOT NULL
);

CREATE TABLE emprestimo(
    codigo_emprestimo INT NOT NULL PRIMARY KEY,
    cpf_usuario VARCHAR(11) NOT NULL,
    cpf_funcionario VARCHAR(11) NOT NULL,
    codigo_livro INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devo_prevista DATE NOT NULL,
    data_devolucao DATE,
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf),
    FOREIGN KEY (codigo_livro) REFERENCES livro(codigo_livro)
);

INSERT INTO usuario (cpf, nome, endereco, telefone) VALUES
('12345678901', 'Ana Silva', 'Rua das Flores, 123', '11999999999'),
('23456789012', 'Bruno Souza', 'Av. Brasil, 456', '21988888888'),
('34567890123', 'Carla Pereira', 'Praça Central, 789', '31977777777');

INSERT INTO categoria (codigo_categoria, descricao) VALUES
(1, 'Romance'),
(2, 'Ficção Científica'),
(3, 'Biografia');

INSERT INTO livro (codigo_livro, titulo, codigo_categorico, autor) VALUES
(101, 'O Amor nos Tempos do Cólera', 1, 'Gabriel García Márquez'),
(102, 'Duna', 2, 'Frank Herbert'),
(103, 'Steve Jobs', 3, 'Walter Isaacson');

INSERT INTO funcionario (cpf, nome, endereco, telefone, funcao) VALUES
('45678901234', 'Daniel Lima', 'Rua Verde, 321', '41966666666', 'Bibliotecário'),
('56789012345', 'Elisa Ramos', 'Av. Azul, 654', '51955555555', 'Atendente'),
('67890123456', 'Felipe Costa', 'Rua Amarela, 987', '61944444444', 'Gerente');

INSERT INTO emprestimo (codigo_emprestimo, cpf_usuario, cpf_funcionario, codigo_livro, data_emprestimo, data_devo_prevista, data_devolucao) VALUES
(1, '12345678901', '45678901234', 101, '2024-06-01', '2024-06-15', '2024-06-10'),
(2, '23456789012', '56789012345', 102, '2024-06-05', '2024-06-19', NULL),
(3, '34567890123', '67890123456', 103, '2024-06-07', '2024-06-21', '2024-06-20');

CREATE VIEW Historico_Emprestimos AS
SELECT
    u.nome AS nome_usuario,
    l.titulo AS titulo_livro,
    c.descricao AS descricao_categoria,
    f.nome AS nome_funcionario,
    e.data_emprestimo AS data_retirada,
    e.data_devo_prevista AS data_devolucao_prevista,
    e.data_devolucao AS data_devolucao_efetiva
FROM
    emprestimo e
    INNER JOIN usuario u ON e.cpf_usuario = u.cpf
    INNER JOIN funcionario f ON e.cpf_funcionario = f.cpf
    INNER JOIN livro l ON e.codigo_livro = l.codigo_livro
    INNER JOIN categoria c ON l.codigo_categorico = c.codigo_categoria;
    
    SELECT * FROM Historico_Emprestimos;