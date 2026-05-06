## Описание

Репозиторий содержит генератор необходимого минимума файлов и директорий для написания UVM окружений.

## Зачем

Мне надоело каждый раз при создании нового окружения делать ctrl+c ctrl+v из старых проектов. Особенно надоело добавлять префиксы к файлам. Поэтому создано это чудо.

## Использование
```
python uvm_generator.py <путь_к_папке_template> <префикс> dv|agent
```

Примеры:
1. Создаёт папки `dv/uvm/env`, `dv/uvm/test`, `dv/tb` и `dv/build`, где к файлам добавлен префикс `my_axi`.
2. Создаёт папку `agent`, где к файлам добавлен префикс `my_axi`.
```
python uvm_generator.py . my_axi dv
python uvm_generator.py . my_axi agent
```

## Для разработки

Я забывашка, поэтому пишу гайд себе же.

Создание `venv`:

```
python -m venv venv
```

Активация `venv`:
```
.\venv\Scripts\Activate.ps1
```
Деактивация `venv`:
```
deactivate
```

Заморозка зависимостей:
```
pip freeze > requirements.txt
```

Установка зависимостей:
```
pip install -r requirements.txt
```
