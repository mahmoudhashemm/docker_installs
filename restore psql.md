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
