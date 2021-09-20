CREATE OR REPLACE PACKAGE pck_crud_pessoa
IS
  PROCEDURE prc_buscar_pessoa (p_id_pessoa  IN  pessoa.id_pessoa%TYPE
                              ,p_pessoa     OUT pessoa%ROWTYPE
                              ,p_id_retorno OUT NUMBER
                              ,p_retorno    OUT VARCHAR2);
  PROCEDURE prc_adicionar_pessoa (p_pessoa     IN OUT pessoa%ROWTYPE
                                 ,p_id_retorno    OUT NUMBER
                                 ,p_retorno       OUT VARCHAR2);
  PROCEDURE prc_excluir_pessoa (p_id_pessoa  IN  pessoa.id_pessoa%TYPE
                               ,p_id_retorno OUT NUMBER
                               ,p_retorno    OUT VARCHAR2);
  PROCEDURE prc_editar_pessoa (p_pessoa     IN  pessoa%ROWTYPE,
                               p_id_retorno OUT NUMBER,
                               p_retorno    OUT VARCHAR2);
END pck_crud_pessoa
/

CREATE OR REPLACE PACKAGE BODY pck_crud_pessoa
IS
  PROCEDURE prc_buscar_pessoa (p_id_pessoa  IN  pessoa.id_pessoa%TYPE
                              ,p_pessoa     OUT pessoa%ROWTYPE
                              ,p_id_retorno OUT NUMBER
                              ,p_retorno    OUT VARCHAR2) IS
    v_id_pessoa  pessoa.id_pessoa%TYPE := p_id_pessoa;
    v_pessoa     pessoa%ROWTYPE        := null;
    v_id_retorno NUMBER                := 0;
    v_retorno    VARCHAR2(100);
    --
  BEGIN
    IF (v_id_pessoa is null) THEN
      v_id_retorno := 101;
      v_retorno    := 'Necessário informar o código da pessoa.';
    END IF;
    --
    IF (v_id_retorno = 0) THEN
      BEGIN
        select *
          into v_pessoa
          from pessoa a 
         where 1=1
           and a.id_pessoa = v_id_pessoa
          ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_id_retorno := 102;
          v_retorno    := 'Nenhum registro encontrado para o código: '||v_id_pessoa||'.';
        WHEN OTHERS THEN
          v_id_retorno := 103;
          v_retorno    := 'Erro não tratado na busca por pessoa: '||sqlerrm;
      END;
    END IF;
    --
    p_pessoa     := v_pessoa;
    p_id_retorno := v_id_retorno;
    p_retorno    := v_retorno;
    --
  EXCEPTION
    WHEN OTHERS THEN
      p_id_retorno := 100;
      p_retorno    := 'Erro não tratado: '||sqlerrm;
  END prc_buscar_pessoa;
  --
  PROCEDURE prc_adicionar_pessoa (p_pessoa     IN OUT pessoa%ROWTYPE
                                 ,p_id_retorno    OUT NUMBER
                                 ,p_retorno       OUT VARCHAR2) IS
    v_pessoa     pessoa%ROWTYPE := p_pessoa;
    v_id_retorno NUMBER         := 0;
    v_retorno    VARCHAR2(100)  := 'Registro adicionado com sucesso.';
    --
  BEGIN
    IF (v_pessoa.nome_completo is null or v_pessoa.email is null or 
        v_pessoa.dt_nascimento is null or v_pessoa.sexo is null or 
        v_pessoa.status is null) THEN
      v_id_retorno := 201;
      v_retorno    := 'Necessário todas as informações da pessoa.';
    END IF;
    --
    IF (v_id_retorno = 0) THEN
      BEGIN
        v_pessoa.id_pessoa     := sq_pessoa.nextval;
        --
        insert into pessoa (id_pessoa,nome_completo,email,dt_nascimento,sexo,status)
                    values (v_pessoa.id_pessoa,v_pessoa.nome_completo,v_pessoa.email,v_pessoa.dt_nascimento,v_pessoa.sexo,v_pessoa.status);
        /*insert into pessoa values (v_pessoa);*/  
      EXCEPTION
        WHEN OTHERS THEN
          v_id_retorno := 202;
          v_retorno    := 'Erro não tratado ao inserir pessoa: '||sqlerrm;
      END;
    END IF;
    --
    p_pessoa     := v_pessoa;
    p_id_retorno := v_id_retorno;
    p_retorno    := v_retorno;
    --
  EXCEPTION
    WHEN OTHERS THEN
      p_id_retorno := 200;
      p_retorno    := 'Erro não tratado: '||sqlerrm;
  END prc_adicionar_pessoa;
  --
  PROCEDURE prc_excluir_pessoa (p_id_pessoa  IN  pessoa.id_pessoa%TYPE
                               ,p_id_retorno OUT NUMBER
                               ,p_retorno    OUT VARCHAR2) IS
    v_id_pessoa  pessoa.id_pessoa%TYPE := p_id_pessoa;
    v_pessoa     pessoa%ROWTYPE        := null;
    v_id_retorno NUMBER                := 0;
    v_retorno    VARCHAR2(100);
    --
  BEGIN
    IF (v_id_pessoa is null) THEN
      v_id_retorno := 301;
      v_retorno    := 'Necessário informar o código da pessoa.';
    END IF;
    --
    IF (v_id_retorno = 0) THEN
      prc_buscar_pessoa(
           p_id_pessoa  => v_id_pessoa
          ,p_pessoa     => v_pessoa
          ,p_id_retorno => v_id_retorno
          ,p_retorno    => v_retorno
      );
      --
      IF (v_id_retorno = 0) THEN
        --
        BEGIN
          delete 
            from pessoa a 
           where 1=1
             and a.id_pessoa = v_pessoa.id_pessoa
          ;
          --
          v_retorno := 'Registro excluído com sucesso.';
          --
        EXCEPTION
          WHEN OTHERS THEN
            v_id_retorno := 302;
            v_retorno    := 'Erro não tratado ao excluir pessoa: '||sqlerrm;
        END;
        --
      END IF;
      --
    END IF;
    --
    p_id_retorno := v_id_retorno;
    p_retorno    := v_retorno;
    --
  EXCEPTION
    WHEN OTHERS THEN
      p_id_retorno := 300;
      p_retorno    := 'Erro não tratado: '||sqlerrm;
  END prc_excluir_pessoa;
  --
  PROCEDURE prc_editar_pessoa (p_pessoa     IN  pessoa%ROWTYPE
                              ,p_id_retorno OUT NUMBER
                              ,p_retorno    OUT VARCHAR2) IS
    v_pessoa       pessoa%ROWTYPE := p_pessoa;
    v_pessoa_busca pessoa%ROWTYPE := null;
    v_id_retorno   NUMBER         := 0;
    v_retorno      VARCHAR2(100);
    --
  BEGIN
    IF (v_pessoa.nome_completo is null or v_pessoa.email is null or 
        v_pessoa.dt_nascimento is null or v_pessoa.sexo is null or 
        v_pessoa.status is null) THEN
      v_id_retorno := 401;
      v_retorno    := 'Necessário todas as informações da pessoa.';
    END IF;
    --
    IF (v_id_retorno = 0) THEN
      prc_buscar_pessoa(
           p_id_pessoa  => v_pessoa.id_pessoa
          ,p_pessoa     => v_pessoa_busca
          ,p_id_retorno => v_id_retorno
          ,p_retorno    => v_retorno
      );
      --
      IF (v_id_retorno = 0) THEN
        --
        BEGIN
          update pessoa a 
             set a.nome_completo = v_pessoa.nome_completo
                ,a.email         = v_pessoa.email
                ,a.dt_nascimento = v_pessoa.dt_nascimento
                ,a.sexo          = v_pessoa.sexo
                ,a.status        = v_pessoa.status
           where 1=1
             and a.id_pessoa = v_pessoa_busca.id_pessoa
          ;
          --
          v_retorno := 'Registro editado com sucesso.';
          --
        EXCEPTION
          WHEN OTHERS THEN
            v_id_retorno := 402;
            v_retorno    := 'Erro não tratado ao editar pessoa: '||sqlerrm;
        END;
        --
      END IF;
      --
    END IF;
    --
    p_id_retorno := v_id_retorno;
    p_retorno    := v_retorno;
    --
  EXCEPTION
    WHEN OTHERS THEN
      p_id_retorno := 400;
      p_retorno    := 'Erro não tratado: '||sqlerrm;
  END prc_editar_pessoa;
  --
END pck_crud_pessoa
/

/*
-- CRIACAO DA SEQUENCE
CREATE SEQUENCE sq_pessoa
 START WITH     4
 INCREMENT BY   1
 NOCACHE
 NOCYCLE
;

-- CRIACAO DE TABELAS
CREATE TABLE pessoa (
    id_pessoa NUMBER(11) NOT NULL,
    nome_completo VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    dt_nascimento DATE NOT NULL,
    sexo VARCHAR2(1) NOT NULL,
    status VARCHAR2(1) NOT NULL, --I=INATIVO,A=ATIVO
    PRIMARY KEY (id_pessoa)
);

-- INCLUSAO DE INFORMACOES
insert into pessoa values (1,'João Henrique da Silva','joaohs@joaohs.com',to_date('01/01/1990','dd/mm/yyyy'),'M','A');
insert into pessoa values (2,'Ana Patrícia Monteiro Dias','anapmd@anapmd.com',to_date('05/05/2006','dd/mm/yyyy'),'F','A');
insert into pessoa values (3,'Carlos José Pinheiro','carlosjp@carlosjp.com',to_date('05/05/2006','dd/mm/yyyy'),'M','I');


*/