# docker_installs
This script will help install any, or all, of Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE.

## Reason for Making this Script
I got tired of running individual commands all the time, so I created some scripts to make this very easy. 

## Using this script

1. Clone the repo ( `git clone https://github.com/mahmoudhashemm/docker_installs.git` ), or copy / paste the code from the `install_docker_nproxyman.sh` file into a file on your server. 
2. Change the permissions of the .sh file to make it executable with.

`chmod +x <your-new-file>.sh`

3. Run the installer with

`./<your-new-file>.sh`

## Prompts from the script:
First, you'll be prompted to select the number for your OS / Distro.  Currently I support CentOS 7 and 8, Debian 10 and 11, Ubuntu 18.04, 20.04, 22.04, Arch Linux. 

To clear all unused Docker images, you can use the following command:

bash
Copy code
``` bash
docker image prune -a

```
* لديك Container يعمل باسم odoo_17_container وأردت حفظه كـ Image جديدة:
  
``` bash
docker ps

```

لنفرض أن الـ Container ID هو a1b2c3d4e5.


قم بإنشاء الـ Image:
``` bash
docker commit a1b2c3d4e5 odoo_backup:v1

```

رفعها علي دوكر هب


1. التأكد من تسجيل الدخول إلى Docker Hub:

قم بتسجيل الدخول إلى Docker Hub باستخدام الأمر التالي:

``` bash
docker login

```

2. إعادة تسمية الـ Image لتكون متوافقة مع Docker Hub:

يجب أن تحتوي الـ Image على التنسيق التالي:


``` bash
username/repository_name:tag
```

username: اسم المستخدم الخاص بك على Docker Hub.
repository_name: اسم المستودع (repository) الذي ستقوم بإنشائه على Docker Hub.
tag: الإصدار (يمكنك استخدام أي تسمية مثل latest أو رقم إصدار مثل v1).
لإعادة تسمية الـ Image، استخدم الأمر:

``` bash
docker tag local_image_name username/repository_name:tag

```

مثال 

``` bash
docker tag odoo_backup:v1 myusername/odoo_backup:v1
```

3. رفع الـ Image إلى Docker Hub:

استخدم الأمر التالي لرفع الـ Image:

``` bash
docker push username/repository_name:tag
مثال 
docker push myusername/odoo_backup:v1

```
![image](https://github.com/user-attachments/assets/5f95e8d0-4b31-4177-8029-f49a7dcbf2e6)
![image](https://github.com/user-attachments/assets/ce8c9f7c-3820-4387-a8e4-1329f40f6ec6)
![image](https://github.com/user-attachments/assets/2456c15c-1b4a-4ddf-92d5-20c5d51cb080)


ssh-keygen -t ed25519 -C "your_email@example.com"


git clone --depth 1 --branch main git@github.com:mahmoudhashemm/odoo17pro

Copy this script and run it on your terminal ./odoo-bin -w a -s -c ../odoo.conf --stop-after-init

./odoo-bin -w a -s -c /etc/odoo/odoo.conf --stop-after-init

docker-compose up -d

sudo apt install build-essential python3-dev libldap2-dev libsasl2-dev libssl-dev

pip3 install -r https://raw.githubusercontent.com/odoo/odoo/refs/heads/18.0/requirements.txt


/تعديل اسم فولدر علي جيت هاب


نسخ المستودع إلى جهازك المحلي: افتح الطرفية (Terminal) أو واجهة Git Bash، واستخدم الأمر التالي لاستنساخ المستودع:

```
git clone <repository-url>
```
استبدل <repository-url> برابط المستودع الخاص بك.

الدخول إلى المجلد المستنسخ:

```
cd <repository-folder>
```
تغيير اسم الفولدر:

قم بتغيير اسم الفولدر باستخدام الأمر التالي (أو مباشرة من مدير الملفات على جهازك):
```
mv old-folder-name new-folder-name
```
استبدل old-folder-name باسم الفولدر الحالي وnew-folder-name بالاسم الجديد.
تحديث Git بالتغيير: بعد تغيير اسم الفولدر، عليك تحديث التغييرات في المستودع:

```
git add -A
git commit -m "Renamed folder from old-folder-name to new-folder-name"
```
دفع التغييرات إلى GitHub: ادفع التغييرات إلى المستودع البعيد:

```



git push
```

![image](https://github.com/user-attachments/assets/d6eb7da0-c1ea-47f1-8d0e-3b91ea97c9ba)

لعمل الانجنكس مانيوال 

```
# odoo server upstreams
upstream odoo {
  server 127.0.0.1:10019;
}
upstream odoochat {
  server 127.0.0.1:20018;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

# HTTP Server Block (مهم قبل استخراج الشهادة)
server {
  listen 80;
  server_name test20.osloop.site;

  # السماح لـ Certbot بالوصول
  location /.well-known/acme-challenge/ {
    root /var/www/certbot;
  }

  # باقي الطلبات تتحول إلى HTTPS بعدين
  location / {
    return 301 https://$host$request_uri;
  }
}

# HTTPS Server Block (هتشتغل بعد استخراج الشهادة)
server {
  listen 443 ssl;
  server_name test20.osloop.site;

  proxy_read_timeout 720s;
  proxy_connect_timeout 720s;
  proxy_send_timeout 720s;

  # SSL certs – هتشتغل بعد ما تعمل Certbot
  ssl_certificate /etc/letsencrypt/live/test20.osloop.site/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/test20.osloop.site/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  # Logs
  access_log /var/log/nginx/odoo.access.log;
  error_log /var/log/nginx/odoo.error.log;

  # WebSocket for Odoo
  location /websocket {
    proxy_pass http://odoochat;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;
  }

  # Odoo Backend
  location / {
    proxy_pass http://odoo;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_redirect off;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;
  }

  # Gzip
  gzip on;
  gzip_types text/css text/scss text/plain text/xml application/xml application/json application/javascript;
}
```

بعد الانتهاء من الانجنكس على السيرفر الرئيسي امسح السطور ده 
```
location /.well-known/acme-challenge/ {
    root /var/www/certbot;
  }

  # باقي الطلبات تتحول إلى HTTPS بعدين
  location / {
    return 301 https://$host$request_uri;
  }
```



ولا تنسي بردك الامر لتنفيز الشهاده ل سيرفر واحد 
```
sudo certbot --nginx -d test20.osloop.site
```
ليصبح الشكل النهائي 
```
# odoo server upstreams
upstream odoo {
  server 127.0.0.1:10019;
}
upstream odoochat {
  server 127.0.0.1:20018;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

# HTTP Server Block (مهم قبل استخراج الشهادة)
server {
  listen 80;
  server_name test20.osloop.site;
  rewrite ^(.*) https://$host$1 permanent;
  
}

# HTTPS Server Block (هتشتغل بعد استخراج الشهادة)
server {
  listen 443 ssl;
  server_name test20.osloop.site;

  proxy_read_timeout 720s;
  proxy_connect_timeout 720s;
  proxy_send_timeout 720s;

  # SSL certs – هتشتغل بعد ما تعمل Certbot
  ssl_certificate /etc/letsencrypt/live/test20.osloop.site/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/test20.osloop.site/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  # Logs
  access_log /var/log/nginx/odoo.access.log;
  error_log /var/log/nginx/odoo.error.log;

  # WebSocket for Odoo
  location /websocket {
    proxy_pass http://odoochat;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;
  }

  # Odoo Backend
  location / {
    proxy_pass http://odoo;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_redirect off;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;
  }
```
ليصبح الشكل النهائي 

لعمل سيت اب ملف دوكر ولكن باسم مختلف 
```
docker compose -f docker_compose.nginx_proxy_manager.yml up -d
```


install all docker compose file in one time
يتم وضع الملف داخل الملف الى بداخله الحاويات كلها 

```
# داخل المسار الذي يحتوي المجلدات (cd /PATH/TO/PROJECTS)
for dir in */ ; do
  compose_file="$dir/docker-compose.yml"
  [ -f "$compose_file" ] || compose_file="$dir/docker-compose.yaml"
  if [ -f "$compose_file" ]; then
    project="$(basename "$dir")"          # use folder name as project name
    echo "▶️  تشغيل $project"
    docker compose -p "$project" -f "$compose_file" up -d
  else
    echo "⚠️  لا يوجد ملف Compose في $dir ــ تَخطٍّ"
  fi
done

```
copy
```
rsync -avz /home/user/Documents/ myuser@192.168.1.10:/home/myuser/Backup/
```




تمام ✅ كده باين ليه الموضوع كان عامل مشاكل في الأول:

* ملف `/etc/resolv.conf` عندك معمول كـ **symlink** إلى:

  ```
  /run/systemd/resolve/stub-resolv.conf
  ```
* وده معناه إن النظام (Ubuntu 22.04) بيستخدم **systemd-resolved** كـ DNS stub resolver.
* في الحالة دي أي برنامج (أو Docker) لو قرأ `/etc/resolv.conf` هيلاقي `nameserver 127.0.0.53` (loopback) مش DNS خارجي حقيقي.

---

## 🛠 ليه Docker ماكانش بيترجم الأسماء؟

* Docker بياخد نسخة من `/etc/resolv.conf` بتاع الـ host ويحطها جوه كل حاوية جديدة.
* فلما كان يلاقي `127.0.0.53` → الحاويات كانت تحاول تسأل systemd-resolved جوه نفسها، بس هو مش موجود جواها → النتيجة DNS fail.

---

## ✅ الحل اللي عملناه

* لما ضفت في `/etc/docker/daemon.json`:

  ```json
  {
    "dns": ["8.8.8.8", "8.8.4.4"]
  }
  ```
* Docker بقى يتجاهل `127.0.0.53` ويحقن جوه الحاويات DNS خارجي مباشر (Google DNS).
* وده السبب إن الإنترنت في الحاويات اشتغل بعد التعديل.

---

## 📌 ملاحظات مهمة

1. تقدر تتأكد إن الحاويات بتشوف Google DNS كده:

   ```bash
   docker exec -it <container> cat /etc/resolv.conf
   ```

   المفروض تشوف:

   ```
   nameserver 8.8.8.8
   nameserver 8.8.4.4
   ```

2. مش لازم تعدل `/etc/resolv.conf` بتاع الـ host يدوي، لأنه managed by systemd.
   التعديل الصح هو اللي عملته في `daemon.json`.

---

تحب أجهزلك **خطوات Best Practice** (موثقة) لإعداد DNS في Docker على Ubuntu 22.04 عشان تعتمدها في أي سيرفر جديد من الأول من غير ما تلف؟

