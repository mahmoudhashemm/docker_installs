1. تثبيت Git
أولاً، تأكد من تثبيت Git على جهازك:

```
sudo apt update
sudo apt install git
```
2. إعداد Git لأول مرة
إذا كنت تستخدم Git لأول مرة، قم بتعريف اسم المستخدم والبريد الإلكتروني الخاص بك:

```
git config --global user.name "اسمك"
git config --global user.email "بريدك الإلكتروني"
```
3. إنشاء مستودع (Repository) على GitHub
افتح موقع GitHub.
قم بتسجيل الدخول إلى حسابك.
اضغط على زر New Repository لإنشاء مستودع جديد.
اختر اسمًا للمستودع، وقم بتحديد إعداداته (عام/خاص)، ثم اضغط Create Repository.
ستظهر لك صفحة تحتوي على الأوامر التي سنستخدمها لاحقًا.

4. الانتقال إلى الفولدر المراد رفعه
استخدم الأمر التالي للانتقال إلى المجلد الذي تريد رفعه:

```
cd /path/to/your/folder
```
5. تهيئة المستودع المحلي
قم بتهيئة المجلد كمستودع Git:

```
git init
```
6. إضافة الملفات إلى المستودع
لإضافة جميع الملفات داخل المجلد إلى مستودع Git:

```
git add .
```
7. إنشاء أول تعهد (Commit)
قم بإنشاء أول تعهد يحتوي على الملفات التي أضفتها:

```
git commit -m "Initial commit"
```
8. ربط المستودع المحلي بـ GitHub
انسخ الرابط الخاص بالمستودع من صفحة GitHub (عادة يكون بالشكل التالي: https://github.com/username/repository.git) واستخدم الأمر:

```
git remote add origin https://github.com/username/repository.git
```
```
git pull origin main --rebase
git add .
git commit -m "Resolved merge conflicts"
git push -u origin main
```


لرفع الملفات على برانش جديد اسمه ahmed، يمكنك اتباع الخطوات التالية:

انتقل إلى المجلد الخاص بمشروعك، ثم قم بإنشاء برانش جديد اسمه ahmed باستخدام الأمر:

2. التبديل إلى البرانش الجديد
3.  
بعد إنشاء البرانش، قم بالتبديل إليه:


```
git checkout -b ahmed
```
```
git add .
git commit -m "Adding files to branch ahmed"
```
```
git push -u origin ahmed
```
