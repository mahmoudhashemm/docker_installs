#!/bin/bash

# طلب إدخال البيانات من المستخدم مع تحديد قيم افتراضية
read -p "Enter the backup directory path (e.g., /path/to/backup) [default: /opt/backups]: " BACKUP_DIR
BACKUP_DIR="${BACKUP_DIR:-/opt/backups}"

read -p "Enter the database container name (e.g., odoo-gemy2_db_1) [default: odoo-gemy2_db_1]: " DB_CONTAINER
DB_CONTAINER="${DB_CONTAINER:-odoo-gemy2_db_1}"

read -p "Enter the Odoo container name (e.g., odoo-gemy2) [default: odoo-gemy2_odoo16_1]: " ODOO_CONTAINER
ODOO_CONTAINER="${ODOO_CONTAINER:-odoo-gemy2_odoo16_1}"

read -p "Enter the database name (e.g., eta1.osloop.org) [default: eta1.osloop.org]: " DB_NAME
DB_NAME="${DB_NAME:-eta1.osloop.org}"

read -p "Enter the database user (e.g., odoo) [default: odoo]: " DB_USER
DB_USER="${DB_USER:-odoo}"

read -p "Enter the database stack (e.g., odoo-one) [default: odoo-gemy2]: " DB_stack
DB_stack="${DB_stack:-odoo-gemy2}"

# إعداد المتغيرات
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_BACKUP="${BACKUP_DIR}/db_backup.backup"
FILESTORE_PATH="/opt/${DB_stack}/etc/filestore/${DB_NAME}"
FILESTORE_BACKUP="${BACKUP_DIR}/filestore"
FULL_BACKUP="${BACKUP_DIR}/odoo_full_backup_${DB_stack}_${TIMESTAMP}.tar.gz"

# إنشاء مجلد النسخة الاحتياطية إذا لم يكن موجودًا
mkdir -p "${BACKUP_DIR}"

# التأكد من وجود المجلد الخاص بالـ filestore
if [ ! -d "${FILESTORE_PATH}" ]; then
    echo "Error: Filestore path does not exist: ${FILESTORE_PATH}"
    exit 1
fi

# إنشاء نسخة احتياطية لقاعدة البيانات
echo "Creating database backup..."
docker exec -i ${DB_CONTAINER} pg_dump -U ${DB_USER} -F c -b -v ${DB_NAME} > "${DB_BACKUP}"
if [ $? -eq 0 ]; then
    echo "Database backup saved at: ${DB_BACKUP}"
else
    echo "Failed to create database backup. Exiting."
    exit 1
fi

# نسخ الملفات المرتبطة (filestore)
echo "Creating filestore backup..."
cp -r ${FILESTORE_PATH} "${FILESTORE_BACKUP}"
if [ $? -eq 0 ]; then
    echo "Filestore backup saved at: ${FILESTORE_BACKUP}"
else
    echo "Failed to create filestore backup. Exiting."
    exit 1
fi

# ضغط النسخة الاحتياطية الشاملة
echo "Creating full backup archive..."
tar -czvf "${FULL_BACKUP}" -C "${BACKUP_DIR}" "db_backup.backup" "filestore"
if [ $? -eq 0 ]; then
    echo "Full backup archive created at: ${FULL_BACKUP}"
else
    echo "Failed to create full backup archive. Exiting."
    exit 1
fi

# التأكد من وجود الملفات قبل محاولة الحذف
if [ -f "${DB_BACKUP}" ]; then
    rm -f "${DB_BACKUP}"
    echo "Deleted database backup: ${DB_BACKUP}"
else
    echo "Database backup file not found: ${DB_BACKUP}"
fi

if [ -d "${FILESTORE_BACKUP}" ]; then
    rm -rf "${FILESTORE_BACKUP}"
    echo "Deleted filestore backup directory: ${FILESTORE_BACKUP}"
else
    echo "Filestore backup directory not found: ${FILESTORE_BACKUP}"
fi

echo "Backup process completed successfully!"
