كيفية إنشاء قاعدة بيانات فارغة:
ادخل إلى حاوية PostgreSQL:

```
docker exec -it اسم_حاوية_قاعدة_البيانات bash
```
افتح واجهة PostgreSQL:

```
psql -U odoo
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
