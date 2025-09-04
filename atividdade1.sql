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
    preco DECIMAL(10,2),
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

INSERT INTO livro (codigo_livro, titulo, codigo_categorico, autor,preco) VALUES
(101, 'O Amor nos Tempos do Cólera', 1, 'Gabriel García Márquez', 39.90),
(102, 'Duna', 2, 'Frank Herbert', 49.90),
(103, 'Steve Jobs', 3, 'Walter Isaacson', 59.90);

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






    --------------PARTE 2-----------------






    CREATE TABLE fornecedor (
        cnpj VARCHAR(14) NOT NULL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        telefone VARCHAR(15) NOT NULL
    );

    CREATE TABLE compra (
        codigo_compra INT NOT NULL PRIMARY KEY,
        cnpj_fornecedor VARCHAR(14) NOT NULL,
        cpf_funcionario VARCHAR(11) NOT NULL,
        valor_total DECIMAL(10,2) NOT NULL,
        data_compra DATE NOT NULL,
        FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj),
        FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
    );

    CREATE TABLE compraLivro (
        codigo_livro INT NOT NULL,
        codigo_compra INT NOT NULL,
        quantidade INT NOT NULL,
        PRIMARY KEY (codigo_livro, codigo_compra),
        FOREIGN KEY (codigo_livro) REFERENCES livro(codigo_livro),
        FOREIGN KEY (codigo_compra) REFERENCES compra(codigo_compra)
    );

    CREATE VIEW Relatorio_Compras_Livros AS
    SELECT
        f.nome AS nome_fornecedor,
        func.nome AS nome_funcionario,
        c.codigo_compra,
        l.titulo AS titulo_livro,
        cl.quantidade,
        c.valor_total,
        c.data_compra
    FROM
        compra c
        INNER JOIN fornecedor f ON c.cnpj_fornecedor = f.cnpj
        INNER JOIN funcionario func ON c.cpf_funcionario = func.cpf
        INNER JOIN compraLivro cl ON c.codigo_compra = cl.codigo_compra
        INNER JOIN livro l ON cl.codigo_livro = l.codigo_livro;


    INSERT INTO fornecedor (cnpj, nome, telefone) VALUES
    ('12345678000199', 'Livraria Central', '11333333333'),
    ('98765432000188', 'Mundo dos Livros', '21944444444'),
    ('45678912000177', 'Papelaria e Cia', '31955555555');

    INSERT INTO compra (codigo_compra, cnpj_fornecedor, cpf_funcionario, valor_total, data_compra) VALUES
    (1, '12345678000199', '45678901234', 199.90, '2024-06-10'),
    (2, '98765432000188', '56789012345', 299.85, '2024-06-12'),
    (3, '45678912000177', '67890123456', 149.75, '2024-06-15');

    INSERT INTO compraLivro (codigo_livro, codigo_compra, quantidade) VALUES
    (101, 1, 2),
    (102, 1, 1),
    (103, 2, 3),
    (101, 3, 1),
    (103, 3, 2);

    SELECT * FROM Relatorio_Compras_Livros;


    --------------PARTE 3-----------------


    CREATE TABLE Especialidades (
        codigo_especialidade INT NOT NULL PRIMARY KEY,
        nome_especialidade VARCHAR(100) NOT NULL
    );

    CREATE TABLE Medicos (
        codigo_medico INT NOT NULL PRIMARY KEY,
        nome_medico VARCHAR(100) NOT NULL,
        email_medico VARCHAR(100) NOT NULL,
        codigo_especialidade INT NOT NULL,
        FOREIGN KEY (codigo_especialidade) REFERENCES Especialidades(codigo_especialidade)
    );

    CREATE TABLE Atendimentos (
        codigo_atendimento INT NOT NULL PRIMARY KEY,
        nome_paciente VARCHAR(100) NOT NULL,
        data_atendimento DATE NOT NULL,
        codigo_medico INT NOT NULL,
        FOREIGN KEY (codigo_medico) REFERENCES Medicos(codigo_medico)
    );

    CREATE VIEW Equipe_Atendimento AS
    SELECT
        e.codigo_especialidade,
        e.nome_especialidade,
        m.nome_medico,
        m.email_medico,
        a.codigo_atendimento,
        a.nome_paciente,
        a.data_atendimento
    FROM
        Atendimentos a
        INNER JOIN Medicos m ON a.codigo_medico = m.codigo_medico
        INNER JOIN Especialidades e ON m.codigo_especialidade = e.codigo_especialidade;