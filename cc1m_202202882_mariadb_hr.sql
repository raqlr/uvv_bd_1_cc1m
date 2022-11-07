CREATE USER 'raquel'@localhost identified by '202202882';

CREATE DATABASE uvv
                CHARACTER SET UTF8
                COLLATE UTF8_general_ci;
                
GRANT ALL ON uvv.* TO 'raquel'@localhost;

USE uvv;


CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'Tabela que armazena informações sobre salário e código dos cargos na empresa.'

ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Código de identificação do cargo exercido por determinado empregado.
Chave estrangeira para a tabela empregados e historico_cargos.';

ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'Nome do cargo de cada funcionário.';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'Salário mínimo admitido ao funcionário de determinado cargo.';

ALTER TABLE cargos MODIFY COLUMN salario_maximo DECIMAL(8, 2) COMMENT 'Maior salário admitido a determinado funcionário.';


CREATE TABLE regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela do tipo 1:N.
Contém o código de indentificação e nome de cada região cadastrada.';

ALTER TABLE regioes MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave primária da tabela regioes, tipo integer (numero não fracionário).
Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'O nome das regiões estarão armazenadas nessa coluna.';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'Tabela que informa nome, código de países. Essa tabela contém uma chave primária (id_pais_pk), uma chave estrangeira (id_pais_fk) e nome dos paises.';

ALTER TABLE paises MODIFY COLUMN id_pais CHAR(2) COMMENT 'Chave primária da tabela países. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'Nome do país onde se encontra filiais, escritórios, ou departamentos da empresa.';

ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave primária da tabela regioes, tipo integer (numero não fracionário).
Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';


CREATE TABLE localizacoes (
                id_localizacoes INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR,
                PRIMARY KEY (id_localizacoes)
);

ALTER TABLE localizacoes COMMENT 'Tabela de localizações, contém os endereços de diversos escritórios e facilidades da empresa. Não armazena endereços de clientes.';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacoes INTEGER COMMENT 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. É uma chave primária e por conta disso, não pode ser nula.
Chave estrangeira para a tabela departamentos.';

ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Localização por endereço de uma filial, escritório, e/ou departamento da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN cep VARCHAR(12) COMMENT 'CEP do endereço/localização de um escritório ou facilidade empresarial.';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'Cidade onde está localizado o escritório ou outra filial da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'Estado (abreviado ou por extenso) onde está localizado o escritório ou outra facilidade da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR COMMENT 'Chave estrangeira que referencia a tabela paises. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';


CREATE UNIQUE INDEX localizacoes_idx
 ON localizacoes
 ( cep );

CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(10),
                id_localizacoes INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'Esta tabela reserva informações de identificação (id_departamento, nome, id_localização, id_gerente) dos departamentos da empresa.';

ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';

ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(10) COMMENT 'Propriedade contendo o nome do departamento da tabela.';

ALTER TABLE departamentos MODIFY COLUMN id_localizacoes INTEGER COMMENT 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. 
Chave estrangeira para a tabela departamentos.';


CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                cpf CHAR(11) NOT NULL,
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario DECIMAL(8,2) NOT NULL,
                comissao DECIMAL(4,2),
                id_departamento INT NOT NULL,
                id_supervisor INT,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela que armazena informações dos funcionários da empresa.';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'Nome completo do funcionário.';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'endereço de email do funcionário (apenas parte inicial anterior ao @).';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'Telefone do funcionário com espaço para o código do país e estado.';

ALTER TABLE empregados MODIFY COLUMN cpf CHAR(11) COMMENT 'Cadastro de pessoa física do funcionário.';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Data de contratação do funcionário para o cargo atual.';

ALTER TABLE empregados MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Identificação do cargo atual do funcionário. Também é chave estrangeira para a tabela cargos.';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'Valor do salário mensal do funcionário.';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'Porcentagem de comissão do funcionário no departamento de vendas.';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'Código de identificação do departamento onde o funcionário trabalha.';

ALTER TABLE empregados MODIFY COLUMN id_supervisor INTEGER COMMENT 'Chave estrangeira para a tabela empregados (auto-relacionamento). Esta propriedade indica o supervisor direto do funcionário em determinado departamento.';


CREATE UNIQUE INDEX empregados_idx1
 ON empregados
 ( email );

CREATE TABLE gerentes (
                id_gerente INT NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (id_gerente)
);

ALTER TABLE gerentes COMMENT 'Tabela de gerente com chave primária estrangeira para a tabela funcionarios.';

ALTER TABLE gerentes MODIFY COLUMN id_gerente INTEGER COMMENT 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';

ALTER TABLE gerentes MODIFY COLUMN id_departamento INTEGER COMMENT 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';


CREATE TABLE historico_cargos (
                id_empregado INT NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (id_empregado, data_inicial)
);

ALTER TABLE historico_cargos COMMENT 'Essa tabela armazena o histórico de cargos do funcionário. Novas linhas serão adicionadas caso houver mudança de departamento dentro de um cargo ou vice-versa.';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.
Referenciada na tabela histórico_cargo.';

ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'Indica a data de inicio do funcionário em determinado cargo. Essa propriedade deve apresentar valores menores que do que a propriedade data_final.';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'Último dia de um funcionário em um determinado cargo. 
O valor inserido nesta propriedade deve ser maior do que a data inicial.';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR COMMENT 'Código de identificação do último cargo exercido pelo empregado.
Chave estrangeira (tabela cargos).';

ALTER TABLE historico_cargos MODIFY COLUMN id_departamento INTEGER COMMENT 'Código que identifica o departamento cadastrado de acordo com o código de identificação.
Corresponde ao último departamento onde o empregado trabalhou.';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE paises ADD CONSTRAINT paises_regioes_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacoes)
REFERENCES localizacoes (id_localizacoes)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE gerentes ADD CONSTRAINT departamentos_gerentes_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE gerentes ADD CONSTRAINT gerentes_empregados_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
