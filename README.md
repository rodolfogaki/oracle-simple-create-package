## oracle-simple-create-package
###### exec buscar:
```
DECLARE
  v_pessoa     pessoa%ROWTYPE;
  v_id_retorno NUMBER;
  v_retorno    VARCHAR2(100);
BEGIN
    pck_crud_pessoa.prc_buscar_pessoa (
                    p_id_pessoa  => 2 --codigo da pessoa adicionada
                   ,p_pessoa     => v_pessoa
                   ,p_id_retorno => v_id_retorno
                   ,p_retorno    => v_retorno
    );
    --
    dbms_output.put_line(v_id_retorno||' - '||v_retorno||' - '||v_pessoa.nome_completo);
END;
```

###### exec inserir:
```
DECLARE
  v_pessoa     pessoa%ROWTYPE;
  v_id_retorno NUMBER;
  v_retorno    VARCHAR2(100);
BEGIN
    v_pessoa.nome_completo := 'Lucy Dantas Irineu';
    v_pessoa.email         := 'lucydi@lucydi.com';
    v_pessoa.dt_nascimento := sysdate-7000;
    v_pessoa.sexo          := 'F';
    v_pessoa.status        := 'A';
    --
    pck_crud_pessoa.prc_adicionar_pessoa (
                    p_pessoa     => v_pessoa
                   ,p_id_retorno => v_id_retorno
                   ,p_retorno    => v_retorno
    );
    --
    dbms_output.put_line(v_id_retorno||' - '||v_retorno||' - '||v_pessoa.id_pessoa||' : '||v_pessoa.nome_completo);
END;
```

###### exec excluir:
```
DECLARE
  v_id_retorno NUMBER;
  v_retorno    VARCHAR2(100);
BEGIN
    pck_crud_pessoa.prc_excluir_pessoa (
                    p_id_pessoa  => 6 --codigo da pessoa adicionada
                   ,p_id_retorno => v_id_retorno
                   ,p_retorno    => v_retorno
    );
    --
    dbms_output.put_line(v_id_retorno||' - '||v_retorno);
END;
```

###### exec editar:
```
DECLARE
  v_pessoa     pessoa%ROWTYPE;
  v_id_retorno NUMBER;
  v_retorno    VARCHAR2(100);
BEGIN
    v_pessoa.id_pessoa     := 11;
    v_pessoa.nome_completo := 'Lucy Dantas Irineu - TESTE EDIÇÃO';
    v_pessoa.email         := 'lucydi@lucydi.com - TESTE EDIÇÃO';
    v_pessoa.dt_nascimento := sysdate-9000;
    v_pessoa.sexo          := 'F';
    v_pessoa.status        := 'I';
    --
    pck_crud_pessoa.prc_editar_pessoa (
                    p_pessoa     => v_pessoa --codigo da pessoa adicionada
                   ,p_id_retorno => v_id_retorno
                   ,p_retorno    => v_retorno
    );
    --
    dbms_output.put_line(v_id_retorno||' - '||v_retorno||' - '||v_pessoa.id_pessoa||' : '||v_pessoa.nome_completo);
END;
```
