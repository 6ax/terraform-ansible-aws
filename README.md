_С помощью Jenkins Pipeline используя Terraform и Ansible:_
1. Необходимо собрать и развернуть JAVA приложение из github [RED5](https://github.com/Red5/red5-server.git) в AWS используя один "сборочный" и два "продовых" инстанса.
1. Собирать приложение необходимо в docker, используя "maven" в "сборочном" инстансе, запускать приложение нужно в docker-container на "продовых" инстансах.
1. Брать необходимые артифакты для maven необходимо из локального репозитария [NEXUS](https://nexus.6ax.su) работающий в режиме "proxy".
1. Собирать приложение необходимо из Dockerfile используя multi-stage build, получить Dockerfile необходимо из локального SCM.
1. Полученный docker image необходимо передавать через AWS ECR.

_Предварительная подготовка:_
1. Создан пользователь с правами администратора в AWS IAM.
2. Получены и сохранёны aws_access_key_id, aws_secret_access_key для этого пользователя.

_Подготовка хоста с Jenkins (Ubuntu 18.04):_
```
apt install -y jenkins python3 python3-pip
pip3 install boto3 ansible docker --upgrade requests
su jenkins
cd ~
sh-keygen -t rsa -b 4096 -f ~/.ssh/aws_key

cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = my_key_id
aws_secret_access_key = my_access_key
EOF

cat << EOF > ~/.aws/config
[default]
region = us-east-2
output = json
EOF
```
