استعاده النسخه
```
docker exec -i my_postgres_container pg_restore -U odoo -d eta12 -v < /opt/eta1_osloop_db.backup

docker exec -i odoo-gemy2_db_1 pg_restore -U odoo -d eta12 -v < /opt/eta1_osloop_db.backup
```

انشاء قاعدة بيانات فاضية
```
docker exec -i odoo-gemy2_db_1 psql -U odoo -d postgres -c "CREATE DATABASE mydatabase;"

docker exec -i my_postgres_container psql -U odoo -d postgres -c "CREATE DATABASE mydatabase;"
```

backup 

الحفظ علي الحاوية
```
docker exec -i odoo-gemy2_db_1 pg_dump -U odoo -F c -b -v -f /opt/eta1_osloop_db0658.backup eta1.osloop.org

docker exec -i my_postgres_container pg_dump -U odoo -F c -b -v -f /opt/eta1_osloop_db0657.backup eta1.osloop.org
```
الحفظ خارج الحاوية علي السيرفر الاساسي

```
docker exec -i my_postgres_container pg_dump -U odoo -F c -b -v eta1.osloop.org > /opt/eta1_osloop_db0658.backup

docker exec -i odoo-gemy2_db_1 pg_dump -U odoo -F c -b -v eta1.osloop.org > /opt/eta1_osloop_db0658.backup
```












كيفية إنشاء قاعدة بيانات فارغة:



ادخل إلى حاوية PostgreSQL:

```
docker exec -it اسم_حاوية_قاعدة_البيانات bash
```
افتح واجهة PostgreSQL:

```
psql -U odoo -d template1

or

psql -U odoo -d postgres
```
أنشئ قاعدة بيانات فارغة:

```
CREATE DATABASE my_database WITH OWNER odoo;
```
استبدل my_database باسم قاعدة البيانات التي تريدها.
تأكد أن odoo هو اسم المستخدم الذي يعمل عليه أودو.
اخرج من واجهة PostgreSQL:

```
\q
```
استعادة النسخة الاحتياطية:
بعد إنشاء القاعدة الفارغة، يمكنك تنفيذ أمر الاستعادة:

```
psql -U odoo my_database < /backup.sql
```
see all database 
```
\l
```
للخروج من الحاوية 
```
exit
```

نسخ ملف من خارج الحاويه لداخل الحاويه 

```
docker cp /home/user/example.txt اسم-الحاوية:/app
```
