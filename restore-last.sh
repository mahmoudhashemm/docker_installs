#!/bin/bash

# طلب إدخال البيانات من المستخدم
#!/bin/bash

# تحديد المجلد الافتراضي
BACKUP_DIR="${BACKUP_DIR:-/opt/backups}"

# البحث عن الملفات التي تنتهي بـ .tar.gz وترتيبها من الأحدث إلى الأقدم
echo "Searching for .tar.gz files in $BACKUP_DIR..."
FILES=($(find "$BACKUP_DIR" -type f -name "*.tar.gz" -exec ls -t {} +))

# التحقق إذا كانت هناك ملفات
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No .tar.gz files found in $BACKUP_DIR."
  exit 1
fi

# عرض الملفات للمستخدم لاختيار أحدها
echo "Found the following .tar.gz files:"
select BACKUP_FILE in "${FILES[@]}"; do
  if [ -n "$BACKUP_FILE" ]; then
    echo "You selected: $BACKUP_FILE"
    break
  else
    echo "Invalid selection. Please try again."
  fi
done



read -p "Enter the database container name (e.g., odoo-gemy2_db_1) [default: odoo-gemy2_db_1]: " DB_CONTAINER
DB_CONTAINER="${DB_CONTAINER:-odoo-gemy2_db_1}"

read -p "Enter the Odoo container name (e.g., odoo-gemy2) [default: odoo-gemy2_odoo16_1]: " ODOO_CONTAINER
ODOO_CONTAINER="${ODOO_CONTAINER: -odoo-gemy2_odoo16_1}"

read -p "Enter the database name to restore (e.g., eta1.osloop.org) [default: eta1.osloop.org]: " DB_NAME
DB_NAME="${DB_NAME:-eta1.osloop.org}"

read -p "Enter the database user (e.g., odoo) [default: odoo]: " DB_USER
DB_USER="${DB_USER:-odoo}"

read -p "Enter the database stack (e.g., odoo-one) [default: odoo-gemy2]: " DB_stack
DB_stack="${DB_stack:-odoo-gemy2}"

# إعداد المتغيرات
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESTORE_DIR="/tmp/odoo_restore"
FILESTORE_PATH="/opt/${DB_stack}/etc/filestore/${DB_NAME}"



# فك ضغط النسخة الاحتياطية
echo "Extracting the backup archive..."
mkdir -p "${RESTORE_DIR}"
tar -xzvf "${BACKUP_FILE}" -C "${RESTORE_DIR}"
if [ $? -eq 0 ]; then
    echo "Backup archive extracted to ${RESTORE_DIR}"
else
    echo "Failed to extract the backup archive. Exiting."
    exit 1
fi

DB_BACKUP="db_backup.backup"

# استعادة قاعدة البيانات
echo "Restoring database..."
docker exec -i ${DB_CONTAINER} psql -U ${DB_USER} -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${DB_NAME}' AND pid <> pg_backend_pid();"
docker exec -i ${DB_CONTAINER} psql -U ${DB_USER} -d postgres -c "DROP DATABASE IF EXISTS ${DB_NAME};"
docker exec -i ${DB_CONTAINER} psql -U ${DB_USER} -d postgres -c "CREATE DATABASE ${DB_NAME};"
docker exec -i ${DB_CONTAINER} pg_restore -U ${DB_USER} -d ${DB_NAME} -v < "${RESTORE_DIR}/db_backup.backup"
if [ $? -eq 0 ]; then
    echo "Database restored successfully."
else
    echo "Failed to restore database. Exiting."
    exit 1
fi


# استعادة ملفات filestore
echo "Restoring filestore..."
mkdir -p "${FILESTORE_PATH}"
cp -r "${RESTORE_DIR}/filestore"/* "${FILESTORE_PATH}"
if [ $? -eq 0 ]; then
    echo "Filestore restored successfully."
else
    echo "Failed to restore filestore. Exiting."
    exit 1
fi

# تنظيف الملفات المؤقتة
echo "Cleaning up temporary files..."
rm -rf "${RESTORE_DIR}"
if [ $? -eq 0 ]; then
    echo "Temporary files deleted successfully."
else
    echo "Failed to delete temporary files."
fi

echo "Restore process completed successfully!"
