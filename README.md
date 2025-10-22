# mssql-server
## Procedures

- **sp_createlogin**: procedure para criação de login utilizando senha de complexidade alta retornando o script de criação com o SID
    - @login_name: (obrigatório)
    - @password (opcional): caso não preenchido gera uma senha seguindo os próximos parâmetros
    - @default_database (opcional): default master
    - @check_policy (opcional): default 1 (on)
    - @expiration (opcional): default 0 (off)
    - @size (opcional): default 20 número de caracteres da senha
    - @spchar (opcional): default 1 inclui caracteres especiais na senha
    - @num (opcional): default 1 inclui números na senha
    - @caps (opcional): default 1 inclui caracteres maiúsculos na senha
    - @drop (opcional): default 1 remove login, deixando apenas o script de criação com o SID para execução em outras instâncias evitando o problema de usuário órfão.
    - Exemplo de execução: exec sp_createlogin 'nome_usuario'
    - Resultado:
        - Login: nome_usuario
        - Password: 5YmEg^fANF{xu=(jy3It
        - Script_Create: create login \[nome_usuario\] with password = 0x030096C197B6E9908B15751AD470109357311AF026E60A5E3E032047DE9A97AFA9B99A4D14AE63F987A182748005392CF633B320CAFD6E463A228B24D55219A9C51F60D945CE hashed, sid = 0x1BF996A6B32DC14695BCD8CAED5532D3, default_database=\[master\], check_expiration=off, check_policy=on