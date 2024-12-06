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
