#!/bin/bash

# Директории (относительные пути)
SOURCE_DIR="../"  # Текущая директория
DEST_DIR="./competition_package"
REGLAMENT_DIR="$DEST_DIR/01_reglament"
PROTOCOL_DIR="$DEST_DIR/02_proto-col"
TASKS_DIR="$DEST_DIR/03_tasks"
FINAL_DOCS_DIR="$DEST_DIR/04_final_docs"


echo "Поиск и компиляция всех .tex файлов в $SOURCE_DIR..."

# Находим все .tex файлы рекурсивно и компилируем их
find "$SOURCE_DIR" -name "*.tex" -type f | while read -r tex_file; do
    # Получаем директорию и имя файла
    dir_path=$(dirname "$tex_file")
    file_name=$(basename "$tex_file")
    base_name="${file_name%.tex}"
    
    echo "Компиляция: $tex_file"
    
    # Переходим в директорию файла и компилируем
    (cd "$dir_path" && \
     pdflatex -interaction=nonstopmode "$file_name" > /dev/null 2>&1 && \
     pdflatex -interaction=nonstopmode "$file_name" > /dev/null 2>&1)
    
    # Проверяем, создался ли PDF
    pdf_file="$dir_path/$base_name.pdf"
    if [ -f "$pdf_file" ]; then
        echo "  ✓ Успешно: $base_name.pdf"
    else
        echo "  ⚠ Ошибка: Не удалось создать PDF для $file_name"
    fi
done

echo "Готово! Все .tex файлы скомпилированы."

# Создание структуры директорий
echo "Создание структуры директорий..."
mkdir -p "$TASKS_DIR"
mkdir -p "$PROTOCOL_DIR"
mkdir -p "$FINAL_DOCS_DIR"
mkdir -p "$REGLAMENT_DIR"

# Копирование файлов заданий (только PDF)
echo "Копирование файлов заданий..."
cp "$SOURCE_DIR/03_tasks/001_City/city_task.pdf" "$TASKS_DIR" 2>/dev/null || echo "  ⚠ city_task.pdf не найден"
cp "$SOURCE_DIR/03_tasks/002_Garden/garden_task.pdf" "$TASKS_DIR" 2>/dev/null || echo "  ⚠ garden_task.pdf не найден"
cp "$SOURCE_DIR/03_tasks/006_Cuprum/cuprum_task.pdf" "$TASKS_DIR" 2>/dev/null || echo "  ⚠ cuprum_task.pdf не найден"
cp "$SOURCE_DIR/03_tasks/007_IceSnow/icesnow_task.pdf" "$TASKS_DIR" 2>/dev/null || echo "  ⚠ icesnow_task.pdf не найден"

cp "$SOURCE_DIR/02_proto-col/001_City/city.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ city.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/002_Garden/garden.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ garden.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/006_Cuprum/cuprum.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ cuprum.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/007_IceSnow/icesnow.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ icesnow.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/001_City_v2/city_v2.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ city_v2.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/002_Garden_v2/garden_v2.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ garden_v2.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/006_Cuprum_v2/cuprum_v2.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ cuprum_v2.pdf не найден"
cp "$SOURCE_DIR/02_proto-col/007_IceSnow_v2/icesnow_v2.pdf" "$PROTOCOL_DIR" 2>/dev/null || echo "  ⚠ icesnow_v2.pdf не найден"



cp "$SOURCE_DIR/01_reglament/main.pdf" "$REGLAMENT_DIR" 2>/dev/null || echo "  ⚠ main.pdf не найден"

# Копирование финальных документов (только PDF)
echo "Копирование финальных документов..."
for pdf_file in "$SOURCE_DIR/04_final_docs"/*.pdf; do
    if [ -f "$pdf_file" ]; then
        cp "$pdf_file" "$FINAL_DOCS_DIR/"
        echo "  ✓ $(basename "$pdf_file")"
    fi
done

# Копирование competition.sty
echo "Копирование общих файлов..."
if [ -f "$SOURCE_DIR/footer_options.tex" ]; then
    cp "$SOURCE_DIR/footer_options.tex" "$DEST_DIR/"
    echo "  ✓ footer_options.tex"
else
    echo "  ⚠ footer_options.tex не найден"
fi

# Создание README файла
echo "Создание README..."

# Создание скрипта для быстрой компиляции
cat > "$DEST_DIR/compile_all.sh" << 'EOF'
#!/bin/bash
echo "Компиляция LaTeX документов..."

cd 04_final_docs
for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        echo "Компиляция $tex_file..."
        pdflatex -interaction=nonstopmode "$tex_file"
        pdflatex -interaction=nonstopmode "$tex_file"
    fi
done
cd ..

echo "Готово!"
EOF

chmod +x "$DEST_DIR/compile_all.sh"

# Создание архива
echo "Создание архива..."
cd "$(dirname "$DEST_DIR")"
tar -czf "competition_package_$(date +%Y%m%d).tar.gz" "$(basename "$DEST_DIR")"

echo "Готово! Пакет создан в: $DEST_DIR"
echo "Архив: competition_package_$(date +%Y%m%d).tar.gz"