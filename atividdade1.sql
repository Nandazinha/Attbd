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


    drop database Hospital;   
   
   create database Hospital;
   
   use Hospital;
   
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

        INSERT INTO Especialidades (codigo_especialidade, nome_especialidade) VALUES
        (1, 'Cardiologia'),
        (2, 'Pediatria'),
        (3, 'Ortopedia');

        INSERT INTO Medicos (codigo_medico, nome_medico, email_medico, codigo_especialidade) VALUES
        (1, 'Dr. João Martins', 'joao.martins@hospital.com', 1),
        (2, 'Dra. Maria Oliveira', 'maria.oliveira@hospital.com', 2),
        (3, 'Dr. Pedro Souza', 'pedro.souza@hospital.com', 3);

        INSERT INTO Atendimentos (codigo_atendimento, nome_paciente, data_atendimento, codigo_medico) VALUES
        (1, 'Lucas Silva', '2024-06-20', 1),
        (2, 'Ana Costa', '2024-06-21', 2),
        (3, 'Carlos Mendes', '2024-06-22', 3);
        
        select * from Equipe_Atendimento;


--------------PARTE 4-----------------


CREATE TABLE Clientes (
    codigo_cliente INT NOT NULL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE Vendedores (
    codigo_vendedor INT NOT NULL PRIMARY KEY,
    nome_vendedor VARCHAR(100) NOT NULL,
    email_vendedor VARCHAR(100) NOT NULL
);

CREATE TABLE Categorias (
    codigo_categoria INT NOT NULL PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE Produtos (
    codigo_produto INT NOT NULL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    codigo_categoria INT NOT NULL,
    FOREIGN KEY (codigo_categoria) REFERENCES Categorias(codigo_categoria)
);

CREATE TABLE Pedidos (
    codigo_pedido INT NOT NULL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    codigo_cliente INT NOT NULL,
    codigo_vendedor INT NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES Clientes(codigo_cliente),
    FOREIGN KEY (codigo_vendedor) REFERENCES Vendedores(codigo_vendedor)
);

CREATE TABLE Itens_Pedido (
    codigo_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (codigo_pedido, codigo_produto),
    FOREIGN KEY (codigo_pedido) REFERENCES Pedidos(codigo_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES Produtos(codigo_produto)
);

-- Dados de exemplo
INSERT INTO Clientes VALUES
(1, 'Carlos Silva', 'São Paulo'),
(2, 'Maria Souza', 'Rio de Janeiro'),
(3, 'João Pereira', 'Belo Horizonte'),
(4, 'Ana Lima', 'Curitiba');

INSERT INTO Vendedores VALUES
(1, 'Fernanda Costa', 'fernanda@vendas.com'),
(2, 'Roberto Alves', 'roberto@vendas.com');

INSERT INTO Categorias VALUES
(1, 'Eletrônicos'),
(2, 'Livros'),
(3, 'Roupas');

INSERT INTO Produtos VALUES
(1, 'Notebook', 3500.00, 1),
(2, 'Smartphone', 2500.00, 1),
(3, 'Livro SQL', 120.00, 2),
(4, 'Camisa Polo', 80.00, 3),
(5, 'Tablet', 1800.00, 1);

INSERT INTO Pedidos VALUES
(1, '2024-01-10', 7000.00, 1, 1),
(2, '2024-02-15', 120.00, 2, 2),
(3, '2024-03-20', 2580.00, 3, 1),
(4, '2024-04-05', 8000.00, 1, 2),
(5, '2023-12-25', 80.00, 4, 1),
(6, '2024-05-10', 3500.00, 2, 2),
(7, '2024-06-01', 1800.00, 3, 1),
(8, '2024-06-15', 2500.00, 4, 2),
(9, '2024-06-20', 120.00, 1, 1),
(10, '2024-06-25', 80.00, 2, 2);

INSERT INTO Itens_Pedido VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(3, 2, 1),
(3, 4, 1),
(4, 1, 2),
(4, 2, 2),
(5, 4, 1),
(6, 1, 1),
(7, 5, 1),
(8, 2, 1),
(9, 3, 1),
(10, 4, 1);

-- View Boletim_Pedidos
CREATE VIEW Boletim_Pedidos AS
SELECT
    p.codigo_pedido,
    c.nome_cliente,
    p.data_pedido,
    p.valor_total,
    c.cidade
FROM
    Pedidos p
    INNER JOIN Clientes c ON p.codigo_cliente = c.codigo_cliente;

-- View Produto_Categoria
CREATE VIEW Produto_Categoria AS
SELECT
    pr.nome_produto,
    ca.nome_categoria
FROM
    Produtos pr
    INNER JOIN Categorias ca ON pr.codigo_categoria = ca.codigo_categoria;

-- View Vendedor_Pedido
CREATE VIEW Vendedor_Pedido AS
SELECT
    v.nome_vendedor,
    p.codigo_pedido,
    c.nome_cliente,
    p.data_pedido
FROM
    Pedidos p
    INNER JOIN Vendedores v ON p.codigo_vendedor = v.codigo_vendedor
    INNER JOIN Clientes c ON p.codigo_cliente = c.codigo_cliente;

-- View Cliente_MaiorCompra
CREATE VIEW Cliente_MaiorCompra AS
SELECT
    c.nome_cliente,
    p.data_pedido,
    p.valor_total
FROM
    Pedidos p
    INNER JOIN Clientes c ON p.codigo_cliente = c.codigo_cliente
WHERE
    p.valor_total > 5000.00;

-- View Categoria_MaisVendida
CREATE VIEW Categoria_MaisVendida AS
SELECT
    ca.nome_categoria,
    SUM(ip.quantidade) AS quantidade_total_vendida
FROM
    Itens_Pedido ip
    INNER JOIN Produtos pr ON ip.codigo_produto = pr.codigo_produto
    INNER JOIN Categorias ca ON pr.codigo_categoria = ca.codigo_categoria
GROUP BY
    ca.nome_categoria;

-- View Cliente_TotalPedidos
CREATE VIEW Cliente_TotalPedidos AS
SELECT
    c.nome_cliente,
    c.cidade,
    COUNT(p.codigo_pedido) AS total_pedidos
FROM
    Clientes c
    LEFT JOIN Pedidos p ON c.codigo_cliente = p.codigo_cliente
GROUP BY
    c.codigo_cliente, c.nome_cliente, c.cidade;

-- View Vendedor_Faturamento
CREATE VIEW Vendedor_Faturamento AS
SELECT
    v.nome_vendedor,
    COUNT(p.codigo_pedido) AS total_pedidos,
    SUM(p.valor_total) AS total_vendas
FROM
    Vendedores v
    LEFT JOIN Pedidos p ON v.codigo_vendedor = p.codigo_vendedor
GROUP BY
    v.codigo_vendedor, v.nome_vendedor;

-- View Produtos_NaoVendidos
CREATE VIEW Produtos_NaoVendidos AS
SELECT
    pr.*
FROM
    Produtos pr
WHERE
    pr.codigo_produto NOT IN (
        SELECT DISTINCT ip.codigo_produto
        FROM Itens_Pedido ip
        INNER JOIN Pedidos p ON ip.codigo_pedido = p.codigo_pedido
        WHERE YEAR(p.data_pedido) = 2024
    );

-- View Clientes_Premium
CREATE VIEW Clientes_Premium AS
SELECT
    c.nome_cliente,
    c.cidade
FROM
    Clientes c
    INNER JOIN Pedidos p ON c.codigo_cliente = p.codigo_cliente
GROUP BY
    c.codigo_cliente, c.nome_cliente, c.cidade
HAVING
    COUNT(p.codigo_pedido) >= 10;