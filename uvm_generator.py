import os
import shutil
import sys

def replace_content_in_file(filepath, prefix, template_str="{{prefix}}"):
    """
    Читает файл, заменяет все вхождения template_str на prefix,
    и записывает результат обратно.
    Возвращает True, если замена произошла, False иначе.
    """
    try:
        # Пытаемся прочитать как текст. Если файл бинарный, возникнет ошибка,
        # которую мы ловим и пропускаем файл.
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Выполняем замену
        if template_str in content:
            new_content = content.replace(template_str, prefix)
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
        return False
    except UnicodeDecodeError:
        # Пропускаем бинарные файлы
        return False
    except Exception as e:
        print(f"  Ошибка при обработке содержимого файла {filepath}: {e}")
        return False

def rename_files_add_prefix(base_path, prefix, extensions=None):
    """
    Рекурсивно переименовывает файлы, добавляя prefix в начало имени.

    Например:
        agent.sv -> my_uart_agent.sv

    Файл tb.sv / tb.svh не переименовывается.
    """
    renamed_count = 0

    for root, _, files in os.walk(base_path):
        for filename in files:
            name, ext = os.path.splitext(filename)

            if extensions is not None and ext not in extensions:
                continue

            # Не переименовываем tb.sv / tb.svh
            if name == "tb":
                print(f"  Пропуск tb файла: {filename}")
                continue

            if filename.startswith(f"{prefix}_"):
                continue

            new_filename = f"{prefix}_{filename}"

            old_filepath = os.path.join(root, filename)
            new_filepath = os.path.join(root, new_filename)

            if os.path.exists(new_filepath):
                print(f"  Пропуск: файл уже существует {new_filepath}")
                continue

            try:
                os.rename(old_filepath, new_filepath)
                print(f"  Переименован: {filename} -> {new_filename}")
                renamed_count += 1
            except Exception as e:
                print(f"  Ошибка при переименовании {filename}: {e}")

    return renamed_count

def process_uvm_structure(source_root, target_folder_name, prefix):
    """
    1. Копирует указанную папку (dv или agent) из template.
    2. Рекурсивно заменяет {{prefix}} во ВСЕХ файлах внутри новой папки.
    3. Переименовывает .sv файлы в папках, указанных в subdirs_to_process, добавляя префикс.
    """

    # 1. Определяем пути
    template_path = os.path.join(source_root, "template")
    source_target_path = os.path.join(template_path, target_folder_name)

    if not os.path.exists(source_target_path):
        print(f"Ошибка: Папка не найдена: {source_target_path}")
        return

    dest_target_path = os.path.join(source_root, f"{prefix}_{target_folder_name}")

    # Проверка на существование destination
    if os.path.exists(dest_target_path):
        print(f"Внимание: Папка {dest_target_path} уже существует. Удалите её перед повторным запуском.")
        return

    # 2. Копируем всю папку
    print(f"Копирование {source_target_path} -> {dest_target_path}")
    shutil.copytree(source_target_path, dest_target_path)
    print("Копирование завершено.")

    # 3. Глобальная замена шаблонов во ВСЕХ файлах рекурсивно
    print(f"Замена шаблонов '{{{{prefix}}}}' на '{prefix}' во всех файлах...")
    total_replacements = 0
    for root, dirs, files in os.walk(dest_target_path):
        for filename in files:
            filepath = os.path.join(root, filename)
            if replace_content_in_file(filepath, prefix, "{{prefix}}"):
                total_replacements += 1
                # print(f"  Обновлен: {filepath}")

    print(f"Замена шаблонов завершена. Изменено файлов: {total_replacements}")

    # 4. Переименование файлов с добавлением префикса
    print(f"Добавление префикса '{prefix}' к именам файлов...")

    extensions_to_process = {".sv", ".svh"}

    files_renamed_count = rename_files_add_prefix(
        dest_target_path,
        prefix,
        extensions=extensions_to_process
    )

    if files_renamed_count == 0:
        print("Файлы для переименования не найдены или уже имеют префикс.")
    else:
        print(f"Переименовано файлов: {files_renamed_count}")

    print("Готово.")

if __name__ == "__main__":
    # Использование:
    # python uvm_generator.py <путь_к_проекту> <префикс> <dv|agent>

    if len(sys.argv) < 4:
        print("Использование: python uvm_generator.py <путь_к_папке_template> <префикс> <тип_папки>")
        print("Пример 1: python uvm_generator.py ./projects my_axi dv")
        print("Пример 2: python uvm_generator.py ./projects my_uart agent")
        sys.exit(1)

    root_path     = sys.argv[1]
    user_prefix   = sys.argv[2]
    target_folder = sys.argv[3].lower()

    valid_folders = ["dv", "agent"]
    if target_folder not in valid_folders:
        print(f"Ошибка: Неверный тип папки '{target_folder}'. Выберите из: {valid_folders}")
        sys.exit(1)

    if not user_prefix.isidentifier():
        print("Предупреждение: Префикс содержит символы, недопустимые для идентификаторов SystemVerilog.")

    print(f"Запуск генерации для '{target_folder}' с префиксом '{user_prefix}'...")
    process_uvm_structure(root_path, target_folder, user_prefix)
