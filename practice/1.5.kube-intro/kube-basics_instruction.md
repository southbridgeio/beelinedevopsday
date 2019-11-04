## Все работы проводим из админбокса по адресу sbox.slurm.io

Добавляем свой публичный SSH ключ в Gitlab.
Для этого заходим в gitlab.slurm.io
В правом верхнем углу нажимаем на значок своей учетной записи.
В выпадающем меню нажимаем Settings.
Дальше в левом меню выбираем раздел SSH Keys
И в поле key вставляем свой ПУБЛИЧНЫЙ SSH ключ.

Клюнируем репозиторий Slurm в свой админбокс
```bash
git clone git@gitlab.slurm.io:slurm/slurm.git
```

Переходим в директорию с практическими материалами к первой лекции.
```bash
cd slurm/practice/1.kube-basics-lecture
```

### Pod

Создаем pod
```bash
kubectl apply -f pod.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME      READY     STATUS              RESTARTS   AGE
my-pod    0/1       ContainerCreating   0          2s
```
Через какое то время pod должен перейти в состояние Running
и вывод команды kubectl get po станет таким
```bash
NAME      READY     STATUS    RESTARTS   AGE
my-pod    1/1       Running   0          59s
```
Скейлим приложение
Открываем pod.yaml
```bash
vim pod.yaml
```
И меняем там строкy
```yaml
  name: my-pod
```
на
```yaml
  name: my-pod-1
```
Сохраняем и выходим.
Для vim нужно нажать :wq<Enter>
Далее снова применяем этот манифест
```bash
kubectl apply -f pod.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Далее обновляем версию имаджа в my-pod
Выполняем
```bash
kubectl edit pod my-pod
```
В открывшся в редакторе тексте находим строчку
```yaml
  - image: nginx:1.12
```
И меняем ее на
```yaml
  - image: nginx:1.13
```
Сохраняем и выходим.
Смотрим что получилось
```bash
kubectl describe pod my-pod
```
В выводе команды видим что написано
```bash
    Image:          nginx:1.13
```
Чистим за собой кластер
```bash
kubectl delete pod --all
```

### ReplicaSet

Создаем replicaset
```bash
kubectl apply -f replicaset.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS              RESTARTS   AGE
my-replicaset-pbtdm   0/1       ContainerCreating   0          2s
my-replicaset-z7rwm   0/1       ContainerCreating   0          2s
```
Скейлим replicaset
```bash
kubectl scale replicaset my-replicaset --replicas 3
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS              RESTARTS   AGE
my-replicaset-pbtdm   1/1       Running             0          2m
my-replicaset-szqgz   0/1       ContainerCreating   0          1s
my-replicaset-z7rwm   1/1       Running             0          2m
```
Удаляем один из подов (имя пода у каждого будет индивидуально! Его нужно скопировать из вывода предыдущей команды)
```bash
kubectl delete pod my-replicaset-pbtdm
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS              RESTARTS   AGE
my-replicaset-55qdj   0/1       ContainerCreating   0          1s
my-replicaset-pbtdm   1/1       Running             0          4m
my-replicaset-szqgz   1/1       Running             0          2m
my-replicaset-z7rwm   0/1       Terminating         0          4m
```
Добавляем в репликасет лишний под
Открываем файл pod.yaml
И в него после metadata: на слудующей строке добавляем
```yaml
  labels:
    app: my-app
```
В итоге должно получиться
```yaml
.............
kind: Pod
metadata:
  name: my-pod-1
  labels:
    app: my-app
spec:
.............
```
Создаем pod
```bash
kubectl apply -f pod.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS        RESTARTS   AGE
my-pod-1              0/1       Terminating   0          1s
my-replicaset-55qdj   1/1       Running       0          3m
my-replicaset-pbtdm   1/1       Running       0          8m
my-replicaset-szqgz   1/1       Running       0          6m
```
Далее обновляем версию имаджа в my-replicaset
Выполняем
```bash
kubectl set image replicaset my-replicaset nginx=nginx:1.13
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS        RESTARTS   AGE
my-replicaset-55qdj   1/1       Running       0          3m
my-replicaset-pbtdm   1/1       Running       0          8m
my-replicaset-szqgz   1/1       Running       0          6m
```
И проверяем сам replicaset
```bash
kubectl describe replicaset my-replicaset
```
Видим
```bash
  Containers:
   nginx:
    Image:        nginx:1.13
```
Проверяем любой под
```bash
kubectl describe pod my-replicaset-55qdj
```
Видим что версия имаджа в поде не изменилась
```bash
  Containers:
   nginx:
    Image:        nginx:1.12
```
Помогаем поду обновиться
```bash
kubectl delete po my-replicaset-55qdj
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                  READY     STATUS              RESTARTS   AGE
my-replicaset-55qdj   0/1       Terminating         0          11m
my-replicaset-cwjlf   0/1       ContainerCreating   0          1s
my-replicaset-pbtdm   1/1       Running             0          16m
my-replicaset-szqgz   1/1       Running             0          14m
```
Проверяем версию имаджа в новом поде
```bash
kubectl describe pod my-replicaset-cwjlf
```
Видим
```bash
    Image:          nginx:1.13
```
Чистим за собой кластер
```bash
kubectl delete replicaset --all
```

### Deployment

Создаем deployment
```bash
kubectl apply -f deployment.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                             READY     STATUS              RESTARTS   AGE
my-deployment-7c768c95c4-47jxz   0/1       ContainerCreating   0          2s
my-deployment-7c768c95c4-lx9bm   0/1       ContainerCreating   0          2s
```
и
```bash
kubectl get replicaset
```
Должны увидеть что то типа такого
```bash
NAME                       DESIRED   CURRENT   READY     AGE
my-deployment-7c768c95c4   2         2         2         1m
```
Далее обновляем версию имаджа в my-deployment
Выполняем
```bash
kubectl set image deployment my-deployment nginx=nginx:1.13
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                             READY     STATUS              RESTARTS   AGE
my-deployment-685879478f-7t6ws   0/1       ContainerCreating   0          1s
my-deployment-685879478f-gw7sq   0/1       ContainerCreating   0          1s
my-deployment-7c768c95c4-47jxz   0/1       Terminating         0          5m
my-deployment-7c768c95c4-lx9bm   1/1       Running             0          5m
```
И через какое то время вывод этой команды станет
```bash
NAME                             READY     STATUS    RESTARTS   AGE
my-deployment-685879478f-7t6ws   1/1       Running   0          33s
my-deployment-685879478f-gw7sq   1/1       Running   0          33s
```
Проверяем что в новых подах новый имадж
```bash
kubectl describe pod my-deployment-685879478f-7t6ws
```
И видим
```bash
    Image:          nginx:1.13
```
Проверяем что стало с репликасетом
```bash
kubectl get replicaset
```
Видим что то типа такого
```bash
NAME                       DESIRED   CURRENT   READY     AGE
my-deployment-685879478f   2         2         2         2m
my-deployment-7c768c95c4   0         0         0         7m
```
Чистим за собой кластер
```bash
kubectl delete deployment --all
```

### Resources and Probes

Создаем deployment с ресурсами и пробами
```bash
kubectl apply -f deployment-with-stuff.yaml
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                             READY     STATUS              RESTARTS   AGE
my-deployment-57fff9c845-2qv5l   0/1       ContainerCreating   0          1s
my-deployment-57fff9c845-h8bbw   0/1       ContainerCreating   0          1s
```
Увеличиваем количество ресурсов для нашего деплоймента
```bash
kubectl patch deployment my-deployment --patch '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","resources":{"requests":{"cpu":"10"},"limits":{"cpu":"10"}}}]}}}}'
```
Смотрим что получилось
```bash
kubectl get pod
```
Должны увидеть что то типа такого
```bash
NAME                             READY     STATUS    RESTARTS   AGE
my-deployment-57fff9c845-h8bbw   1/1       Running   0          8m
my-deployment-845d88fdcf-9bd29   0/1       Pending   0          2s
my-deployment-845d88fdcf-mprfk   0/1       Pending   0          2s
```
Смотрим почему поды не могут создаться
```bash
kubectl describe po my-deployment-845d88fdcf-9bd29
```
Видим в эвентах что то типа
```bash
Events:
  Type     Reason            Age               From               Message
  ----     ------            ----              ----               -------
  Warning  FailedScheduling  41s (x8 over 1m)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
```
Чистим за собой кластер
```bash
kubectl delete deployment --all
```

### Configmap

Создаем configmap
```bash
kubectl apply -f configmap.yaml
```
Создаем deployment с configmapом
```bash
kubectl apply -f deployment-with-configmap.yaml
```
Пробуем проверить, что наш конфиг нжинкса подтянулся
```bash
kubectl port-forward my-deployment-5b47d48b58-l4t67 8080:80 &
curl 127.0.0.1:8080
```
В ответ на curl нам приходит ответ от nginxа с его hostname
```bash
my-deployment-5b47d48b58-l4t67
```
HE! чистим за собой кластер

### Service

Проверяем что лэйблы на наших подах совпадают с тем,
что у нас указано в labelSelector в service.yaml
```bash
kubectl get po --show-labels
```
Видим
```bash
NAME                             READY     STATUS    RESTARTS   AGE       LABELS
my-deployment-5b47d48b58-dr9kk   1/1       Running   0          15s       app=my-app,pod-template-hash=1603804614
my-deployment-5b47d48b58-r95lt   1/1       Running   0          15s       app=my-app,pod-template-hash=1603804614
```
Создаем сервис
```bash
kubectl apply -f service.yaml
```
Проверяем что сервис есть
```bash
kubectl get service
```
Видим
```bash
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
my-service   ClusterIP   10.108.197.224   <none>        80/TCP    2s
```
Смотрим, что сервис действительно удидел наши поды
и собирается проксировать на них трафик
```bash
kubectl get endpoints
```
Видим
```
NAME         ENDPOINTS                     AGE
my-service   172.17.0.6:80,172.17.0.7:80   1m
```
Смотрим, что IP эндпоинтов сервиса, это действительно IP наших подов
```
kubectl get pod -o wide
```
Видим
```bash
NAME                             READY     STATUS    RESTARTS   AGE       IP           NODE
my-deployment-5b47d48b58-dr9kk   1/1       Running   0          3m        172.17.0.7   node-1
my-deployment-5b47d48b58-r95lt   1/1       Running   0          3m        172.17.0.6   node-2
```
Запускаем тестовый под, для проверки сервиса
```bash
kubectl run -t -i --rm --image amouat/network-utils test bash
```
Дальше уже из этого пода выполняем
```bash
curl -i my-service
```
В ответ видим выданный нам nginxом hostname пода
```bash
HTTP/1.1 200 OK
Server: nginx/1.12.2
Date: Sun, 27 Jan 2019 13:36:20 GMT
Content-Type: application/octet-stream
Content-Length: 31
Connection: keep-alive

my-deployment-5b47d48b58-r95lt
```
Выходим из тестового пода
```bash
exit
```
HE! чистим за собой кластер

### Ingress

Меняем имя хоста в ingress.yaml
Открываем файл
```bash
vim ingress.yaml
```
Там меняем строчку
```yaml
    - host: s<номер своего логина>.k8s.slurm.io
```
на свой номер логина

> Если вы вошли в vim и не знаете что делать, то нажимаете :wq<Enter>

Создаем ingress
```bash
kubectl apply -f ingress.yaml
```
Проверяем, что ингресс создался
```bash
kubectl get ingress
```
Видим что то типа
```bash
NAME         HOSTS                     ADDRESS   PORTS     AGE
my-ingress   s000001.k8s.slurm.io             80        1s
```
Проверяем, что наши поды теперь доступны снаружи по имени хоста в ингрессе
```bash
curl -i s<номер своего логина>.k8s.slurm.io
```
В ответ видим выданный нам nginxом hostname пода
```bash
HTTP/1.1 200 OK
Server: nginx/1.12.2
Date: Sun, 27 Jan 2019 13:36:20 GMT
Content-Type: application/octet-stream
Content-Length: 31
Connection: keep-alive

my-deployment-5b47d48b58-r95lt
```
Чистим за собой кластер
```bash
kubectl delete all --all
kubectl delete configmap --all
kubectl delete ingress --all
```
