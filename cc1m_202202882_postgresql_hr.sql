
CREATE TABLE public.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo_pk PRIMARY KEY (id_cargo)
);
COMMENT ON COLUMN public.cargos.id_cargo IS 'Código de identificação do cargo exercido por determinado empregado.
Chave estrangeira para a tabela empregados e historico_cargos.';
COMMENT ON COLUMN public.cargos.cargo IS 'Nome do cargo de cada funcionário.';
COMMENT ON COLUMN public.cargos.salario_minimo IS 'Salário mínimo admitido ao funcionário de determinado cargo.';
COMMENT ON COLUMN public.cargos.salario_maximo IS 'Maior salário admitido a determinado funcionário.';


CREATE TABLE public.paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                CONSTRAINT id_pais_pk PRIMARY KEY (id_pais)
);
COMMENT ON TABLE public.paises IS 'Tabela que informa nome, código de países. Essa tabela contém uma chave primária (id_pais_pk), uma chave estrangeira (id_pais_fk) e nome dos paises.';
COMMENT ON COLUMN public.paises.id_pais IS 'Chave primária da tabela países. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';
COMMENT ON COLUMN public.paises.nome IS 'Nome do país onde se encontra filiais, escritórios, ou departamentos da empresa.';


CREATE TABLE public.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_regiao_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE public.regioes IS 'Tabela do tipo 1:N.
Contém o código de indentificação e nome de cada região cadastrada.';
COMMENT ON COLUMN public.regioes.id_regiao IS 'Chave primária da tabela regioes, tipo integer (numero não fracionário).
Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';
COMMENT ON COLUMN public.regioes.nome IS 'O nome das regiões estarão armazenadas nessa coluna.';
COMMENT ON COLUMN public.regioes.id_pais IS 'Chave primária da tabela países. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';


CREATE UNIQUE INDEX regioes_idx
 ON public.regioes
 ( nome );

CREATE TABLE public.localizacoes (
                id_localizacoes INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_regiao INTEGER,
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao_pk PRIMARY KEY (id_localizacoes)
);
COMMENT ON TABLE public.localizacoes IS 'Tabela de localizações, contém os endereços de diversos escritórios e facilidades da empresa. Não armazena endereços de clientes.';
COMMENT ON COLUMN public.localizacoes.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. É uma chave primária e por conta disso, não pode ser nula.
Chave estrangeira para a tabela departamentos.';
COMMENT ON COLUMN public.localizacoes.endereco IS 'Localização por endereço de uma filial, escritório, e/ou departamento da empresa.';
COMMENT ON COLUMN public.localizacoes.cep IS 'CEP do endereço/localização de um escritório ou facilidade empresarial.';
COMMENT ON COLUMN public.localizacoes.cidade IS 'Cidade onde está localizado o escritório ou outra filial da empresa.';
COMMENT ON COLUMN public.localizacoes.uf IS 'Estado (abreviado ou por extenso) onde está localizado o escritório ou outra facilidade da empresa.';
COMMENT ON COLUMN public.localizacoes.id_regiao IS 'Chave estrangeira referente a tabela regioes.';
COMMENT ON COLUMN public.localizacoes.id_pais IS 'Chave primária da tabela países. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';


CREATE TABLE public.departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(10),
                id_localizacoes INTEGER NOT NULL,
                CONSTRAINT id_departamento_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE public.departamentos IS 'Esta tabela reserva informações de identificação (id_departamento, nome, id_localização, id_gerente) dos departamentos da empresa.';
COMMENT ON COLUMN public.departamentos.id_departamento IS 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';
COMMENT ON COLUMN public.departamentos.nome IS 'Propriedade contendo o nome do departamento da tabela.';
COMMENT ON COLUMN public.departamentos.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. 
Chave estrangeira para a tabela departamentos.';


CREATE TABLE public.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                cpf CHAR(11) NOT NULL,
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT id_empregados_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE public.empregados IS 'Tabela que armazena informações dos funcionários da empresa.';
COMMENT ON COLUMN public.empregados.id_empregado IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';
COMMENT ON COLUMN public.empregados.nome IS 'Nome completo do funcionário.';
COMMENT ON COLUMN public.empregados.email IS 'endereço de email do funcionário (apenas parte inicial anterior ao @).';
COMMENT ON COLUMN public.empregados.telefone IS 'Telefone do funcionário com espaço para o código do país e estado.';
COMMENT ON COLUMN public.empregados.cpf IS 'Cadastro de pessoa física do funcionário.';
COMMENT ON COLUMN public.empregados.data_contratacao IS 'Data de contratação do funcionário para o cargo atual.';
COMMENT ON COLUMN public.empregados.id_cargo IS 'Identificação do cargo atual do funcionário. Também é chave estrangeira para a tabela cargos.';
COMMENT ON COLUMN public.empregados.salario IS 'Valor do salário mensal do funcionário.';
COMMENT ON COLUMN public.empregados.comissao IS 'Porcentagem de comissão do funcionário no departamento de vendas.';
COMMENT ON COLUMN public.empregados.id_departamento IS 'Código de identificação do departamento onde o funcionário trabalha.';
COMMENT ON COLUMN public.empregados.id_supervisor IS 'Chave estrangeira para a tabela empregados (auto-relacionamento).
Esta propriedade indica o supervisor direto do funcionário em determinado departamento.
Somente nulo se o funcionário cadastrado for supervisor.';


CREATE INDEX empregados_idx
 ON public.empregados
 ( id_supervisor );

CREATE UNIQUE INDEX empregados_idx1
 ON public.empregados
 ( email );

CREATE TABLE public.gerentes (
                id_empregado INTEGER NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT id_empregados_pk_fk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE public.gerentes IS 'Tabela de gerente com chave primária estrangeira para a tabela funcionarios.';
COMMENT ON COLUMN public.gerentes.id_empregado IS 'Chave primária estrangeira para a tabela funcionários. 
Essa propriedade será referenciada na tabela departamentos como id_gerente.';
COMMENT ON COLUMN public.gerentes.id_departamento IS 'Departamento designado ao gerente.';


CREATE TABLE public.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT data_inicial_pk PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE public.historico_cargos IS 'Essa tabela armazena o histórico de cargos do funcionário. Novas linhas serão adicionadas caso houver mudança de departamento dentro de um cargo ou vice-versa.';
COMMENT ON COLUMN public.historico_cargos.id_empregado IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.
Referenciada na tabela histórico_cargo.';
COMMENT ON COLUMN public.historico_cargos.data_inicial IS 'Indica a data de inicio do funcionário em determinado cargo. Essa propriedade deve apresentar valores menores que do que a propriedade data_final.';
COMMENT ON COLUMN public.historico_cargos.data_final IS 'Último dia de um funcionário em um determinado cargo. 
O valor inserido nesta propriedade deve ser maior do que a data inicial.';
COMMENT ON COLUMN public.historico_cargos.id_cargo IS 'Código de identificação do último cargo exercido pelo empregado.
Chave estrangeira (tabela cargos).';
COMMENT ON COLUMN public.historico_cargos.id_departamento IS 'Código que identifica o departamento cadastrado de acordo com o código de identificação.
Corresponde ao último departamento onde o empregado trabalhou.';


ALTER TABLE public.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES public.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES public.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES public.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.regioes ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_pais)
REFERENCES public.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.localizacoes ADD CONSTRAINT regioes_localizacoes_fk
FOREIGN KEY (id_regiao)
REFERENCES public.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacoes)
REFERENCES public.localizacoes (id_localizacoes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES public.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES public.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.gerentes ADD CONSTRAINT gerentes_departamentos_fk
FOREIGN KEY (id_departamento)
REFERENCES public.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES public.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.gerentes ADD CONSTRAINT empregados_gerentes_fk
FOREIGN KEY (id_empregado)
REFERENCES public.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
