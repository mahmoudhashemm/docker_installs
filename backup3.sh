#!/bin/bash

# إعداد القيم الثابتة
BACKUP_DIR="/path/to/backup"  # ضع مسار النسخ الاحتياطي الثابت
DB_CONTAINER="odoo-gemy2_db_1"  # اسم الحاوية الخاصة بقاعدة البيانات
ODOO_CONTAINER="odoo-gemy2"  # اسم الحاوية الخاصة بـ Odoo
DB_NAME="eta1.osloop.org"  # اسم قاعدة البيانات
DB_USER="odoo"  # اسم مستخدم قاعدة البيانات
DB_STACK="odoo-one"  # اسم الـ stack أو الـ environment

# إعداد المتغيرات
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_BACKUP="${BACKUP_DIR}/db_backup_${DB_STACK}_${TIMESTAMP}.backup"
FILESTORE_PATH="/opt/${DB_STACK}/etc/filestore/${DB_NAME}"
FILESTORE_BACKUP="${BACKUP_DIR}/filestore_${TIMESTAMP}"
FULL_BACKUP="${BACKUP_DIR}/odoo_full_backup_${TIMESTAMP}.tar.gz"

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
tar -czvf "${FULL_BACKUP}" -C "${BACKUP_DIR}" "db_backup_${DB_STACK}_${TIMESTAMP}.backup" "filestore_${TIMESTAMP}"
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
