-- ========= CRIAÇÃO DAS TABELAS DE CATÁLOGO E ESTRUTURA PRIMÁRIA =========

CREATE TABLE Empresa (
    id_empresa INTEGER PRIMARY KEY,
    nome_fantasia VARCHAR(100) NOT NULL,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE
);

CREATE TABLE Patio (
    id_patio INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    id_empresa_proprietaria INTEGER NOT NULL,
    CONSTRAINT fk_patio_empresa FOREIGN KEY (id_empresa_proprietaria) REFERENCES Empresa(id_empresa)
);

CREATE TABLE Vaga (
    id_vaga INTEGER PRIMARY KEY,
    id_patio INTEGER NOT NULL,
    codigo_vaga VARCHAR(20) NOT NULL, -- Código da vaga dentro do pátio (Ex: A01, S2-10)
    status_vaga VARCHAR(15) DEFAULT 'Livre' CHECK (status_vaga IN ('Livre', 'Ocupada', 'Manutenção', 'Reservada')),
    tipo_vaga VARCHAR(50), -- Opcional: Ex: 'Normal', 'PCD', 'Veículo Elétrico', 'Coberta'
    CONSTRAINT fk_vaga_patio FOREIGN KEY (id_patio) REFERENCES Patio(id_patio),
    CONSTRAINT uq_patio_codigo_vaga UNIQUE (id_patio, codigo_vaga) -- Garante que o código da vaga seja único dentro de cada pátio
);

CREATE TABLE GrupoVeiculo (
    id_grupo INTEGER PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    valor_diaria_base NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Marca (
    id_marca INTEGER PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Modelo (
    id_modelo INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_marca INTEGER NOT NULL,
    CONSTRAINT fk_modelo_marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca)
);

CREATE TABLE Protecao (
    id_protecao INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    valor_diaria NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Acessorio (
    id_acessorio INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

-- ========= CRIAÇÃO DAS TABELAS DE ENTIDADES PRINCIPAIS =========

CREATE TABLE Veiculo (
    id_veiculo INTEGER PRIMARY KEY,
    placa VARCHAR(7) NOT NULL UNIQUE,
    chassi VARCHAR(17) NOT NULL UNIQUE,
    cor VARCHAR(30),
    ano_fabricacao INTEGER,
    mecanizacao VARCHAR(15) CHECK (mecanizacao IN ('Manual', 'Automática')),
    tem_ar_condicionado BOOLEAN DEFAULT FALSE,
    status_operacional VARCHAR(20) DEFAULT 'Disponível' CHECK (status_operacional IN ('Disponível', 'Alugado', 'Em Manutenção', 'Reservado')),
    id_modelo INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    id_empresa_proprietaria INTEGER NOT NULL,
    id_vaga_atual INTEGER, -- Veículo pode não estar em uma vaga específica (NULL)
    CONSTRAINT fk_veiculo_modelo FOREIGN KEY (id_modelo) REFERENCES Modelo(id_modelo),
    CONSTRAINT fk_veiculo_grupo FOREIGN KEY (id_grupo) REFERENCES GrupoVeiculo(id_grupo),
    CONSTRAINT fk_veiculo_empresa FOREIGN KEY (id_empresa_proprietaria) REFERENCES Empresa(id_empresa),
    CONSTRAINT fk_veiculo_vaga FOREIGN KEY (id_vaga_atual) REFERENCES Vaga(id_vaga) ON DELETE SET NULL -- Se uma vaga for removida, o veículo fica sem vaga, mas não é excluído.
);

CREATE TABLE Cliente (
    id_cliente INTEGER PRIMARY KEY,
    tipo_cliente VARCHAR(2) NOT NULL CHECK (tipo_cliente IN ('PF', 'PJ')),
    nome_razao_social VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    endereco_cobranca VARCHAR(255),
    cidade_origem VARCHAR(100),
    estado_origem VARCHAR(2)
);

CREATE TABLE Motorista (
    id_motorista INTEGER PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    cnh_numero VARCHAR(20) NOT NULL UNIQUE,
    cnh_categoria VARCHAR(5) NOT NULL,
    cnh_data_expiracao DATE NOT NULL,
    id_cliente_associado INTEGER NOT NULL,
    CONSTRAINT fk_motorista_cliente FOREIGN KEY (id_cliente_associado) REFERENCES Cliente(id_cliente)
);


-- ========= CRIAÇÃO DAS TABELAS TRANSACIONAIS E DE LIGAÇÃO  =========

CREATE TABLE Reserva (
    id_reserva INTEGER PRIMARY KEY,
    data_criacao_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_retirada_prevista TIMESTAMP NOT NULL,
    data_hora_devolucao_prevista TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendente' CHECK (status IN ('Confirmada', 'Pendente', 'Cancelada', 'Em Espera')),
    id_cliente INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    id_patio_retirada INTEGER NOT NULL,
    id_patio_devolucao INTEGER NOT NULL,
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_reserva_grupo FOREIGN KEY (id_grupo) REFERENCES GrupoVeiculo(id_grupo),
    CONSTRAINT fk_reserva_patio_retirada FOREIGN KEY (id_patio_retirada) REFERENCES Patio(id_patio),
    CONSTRAINT fk_reserva_patio_devolucao FOREIGN KEY (id_patio_devolucao) REFERENCES Patio(id_patio)
);

CREATE TABLE Locacao (
    id_locacao INTEGER PRIMARY KEY,
    data_hora_retirada_real TIMESTAMP NOT NULL,
    data_hora_devolucao_real TIMESTAMP,
    km_saida INTEGER NOT NULL,
    km_chegada INTEGER,
    valor_cobrado_final NUMERIC(10, 2),
    status VARCHAR(15) DEFAULT 'Ativa' CHECK (status IN ('Ativa', 'Finalizada', 'Cancelada')),
    id_reserva INTEGER,
    id_cliente INTEGER NOT NULL,
    id_motorista INTEGER NOT NULL,
    id_veiculo INTEGER NOT NULL,
    id_patio_retirada INTEGER NOT NULL,
    id_patio_devolucao INTEGER,
    CONSTRAINT fk_locacao_reserva FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva) ON DELETE SET NULL,
    CONSTRAINT fk_locacao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_locacao_motorista FOREIGN KEY (id_motorista) REFERENCES Motorista(id_motorista),
    CONSTRAINT fk_locacao_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo),
    CONSTRAINT fk_locacao_patio_retirada FOREIGN KEY (id_patio_retirada) REFERENCES Patio(id_patio),
    CONSTRAINT fk_locacao_patio_devolucao FOREIGN KEY (id_patio_devolucao) REFERENCES Patio(id_patio)
);


-- ========= CRIAÇÃO DAS TABELAS ASSOCIATIVAS (N:N) E COMPLEMENTARES =========

CREATE TABLE VeiculoAcessorio (
    id_veiculo INTEGER NOT NULL,
    id_acessorio INTEGER NOT NULL,
    CONSTRAINT pk_veiculo_acessorio PRIMARY KEY (id_veiculo, id_acessorio),
    CONSTRAINT fk_va_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo) ON DELETE CASCADE,
    CONSTRAINT fk_va_acessorio FOREIGN KEY (id_acessorio) REFERENCES Acessorio(id_acessorio) ON DELETE CASCADE
);

CREATE TABLE LocacaoProtecao (
    id_locacao INTEGER NOT NULL,
    id_protecao INTEGER NOT NULL,
    valor_contratado NUMERIC(10, 2) NOT NULL,
    CONSTRAINT pk_locacao_protecao PRIMARY KEY (id_locacao, id_protecao),
    CONSTRAINT fk_lp_locacao FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao) ON DELETE CASCADE,
    CONSTRAINT fk_lp_protecao FOREIGN KEY (id_protecao) REFERENCES Protecao(id_protecao) ON DELETE RESTRICT
);

CREATE TABLE ProntuarioManutencao (
    id_prontuario INTEGER PRIMARY KEY,
    data_servico DATE NOT NULL,
    descricao TEXT NOT NULL,
    quilometragem INTEGER,
    id_veiculo INTEGER NOT NULL,
    CONSTRAINT fk_prontuario_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo)
);

CREATE TABLE FotoVeiculoEstado (
    id_foto INTEGER PRIMARY KEY,
    url_foto VARCHAR(255) NOT NULL,
    tipo_momento VARCHAR(15) NOT NULL CHECK (tipo_momento IN ('Entrega', 'Devolução')),
    data_hora_foto TIMESTAMP NOT NULL,
    id_locacao INTEGER NOT NULL,
    CONSTRAINT fk_foto_locacao FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao)
);