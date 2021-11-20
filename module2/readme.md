# 2.3 Подключение к Базам Данных и SQL
* необходимо установить БД и клиент SQL для подключения базы данных. 
* Создать 3 таблицы ([orders](https://github.com/Artyom174/DE-101/blob/main/module2/orders.sql), [people](https://github.com/Artyom174/DE-101/blob/main/module2/people.sql), [returns](https://github.com/Artyom174/DE-101/blob/main/module2/returns.sql)) и загрузить данные из Superstore Excel файл в базу данных. 
* Написать [SQL-запросы](https://github.com/Artyom174/DE-101/blob/main/module2/sql_query.ipynb), чтобы ответить на вопросы из Модуля 01.

скрипт для SQL-запросов из postgres с помощью python лежит [тут](https://github.com/Artyom174/DE-101/blob/main/module2/script_for_postgres.py)

# 2.4 Модели Данных
необходимо создать модель данных для данных [магазина](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls). Для начала создадим:
* [концептуальную модель](https://github.com/Artyom174/DE-101/blob/main/module2/%D0%BA%D0%BE%D0%BD%D1%86%D0%B5%D0%BF%D1%82%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C.png)
* [логическую модель](https://github.com/Artyom174/DE-101/blob/main/module2/%D0%BB%D0%BE%D0%B3%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C.png)
* [физическую модель](https://github.com/Artyom174/DE-101/blob/main/module2/%D1%84%D0%B8%D0%B7%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C.png)

Создание [данной схемы](https://github.com/Artyom174/DE-101/blob/main/module2/ddl_superstore.sql) данных по физической модели. 
