# Base de dados para gestão de internamento hospitalar

Segunda submissão do projeto de Bases de Dados da FEUP, ano letivo 2026/2027, grupo 1705.

A base de dados acompanha os internamentos de uma unidade hospitalar. Cada episódio reúne os diagnósticos associados e as medições de sinais vitais. O modelo representa também as prescrições médicas, as colheitas para análise e as administrações de medicamentos.

## Ficheiros da entrega

- [ZIP da segunda submissão](Segunda_Submissao_BD_1705.zip) — inclui o relatório final em PDF e os quatro scripts SQL.
- [Relatório final em PDF](relatorio/Relatorio_BD_Grupo_1705_Final.pdf) e [versão editável em Word](relatorio/Relatorio_BD_Grupo_1705_Final.docx).
- [Diagrama UML revisto](modelo/Modelo_Revisto_do_UML.drawio.png) e [ficheiro editável no draw.io](modelo/Modelo_Revisto_do_UML.drawio).

| Versão | Criação das tabelas | Povoamento | Registos |
| --- | --- | --- | ---: |
| Inicial | [create1.sql](sql/create1.sql) | [populate1.sql](sql/populate1.sql) | 82 |
| Final | [create2.sql](sql/create2.sql) | [populate2.sql](sql/populate2.sql) | 120 |

As duas versões têm 23 tabelas. A versão final acrescenta restrições de integridade e mais exemplos de dados. Os contactos de telemóvel mantêm os valores de exemplo usados na versão inicial por uma questão de privacidade.

## Executar a versão final em SQLite

Na raiz do repositório, abre a consola SQLite numa base de dados temporária.

```sh
cd sql
sqlite3 :memory:
```

Se usares o ZIP, extrai os ficheiros e abre a consola na pasta onde estão os quatro scripts. Dentro da consola, executa os comandos pela ordem indicada.

```text
.bail on
.read create2.sql
.read populate2.sql
```

Para verificar a integridade da base de dados e das referências entre tabelas, executa as duas consultas seguintes.

```sql
PRAGMA integrity_check;
PRAGMA foreign_key_check;
```

A primeira consulta deve devolver `ok`. A segunda deve devolver zero linhas. Para reproduzir a versão inicial, abre outra base de dados temporária e executa `create1.sql` seguido de `populate1.sql`.

## Grupo 1705

André Castro, Gabriel Rodrigues e José Gomes contribuíram em partes iguais, com 33,3(3) % cada.
