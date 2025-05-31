@echo off
echo === INICIANDO UPLOAD PARA GITHUB ===

REM Navegar para a pasta origem
echo Navegando para c:\teste...
cd /d "c:\teste"

REM Inicializar repositório Git
echo Inicializando repositorio Git...
git init

REM Adicionar todos os arquivos
echo Adicionando todos os arquivos...
git add .

REM Fazer commit inicial
echo Realizando commit inicial...
git commit -m "Commit inicial - upload de todos os arquivos da pasta c:\teste"

REM Adicionar repositório remoto
echo Conectando ao repositorio remoto...
git remote add origin https://github.com/WanderMotta/teste.git

REM Definir branch principal
echo Definindo branch principal como 'main'...
git branch -M main

REM Fazer push para o GitHub
echo Fazendo upload para o GitHub...
echo ATENCAO: Voce precisara inserir suas credenciais do GitHub!
git push -u origin main

echo === UPLOAD CONCLUIDO COM SUCESSO! ===
echo Repositorio disponivel em: https://github.com/WanderMotta/teste

pause