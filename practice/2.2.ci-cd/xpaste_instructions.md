## Все работы проводим под рутом на master-1

### Если ключ SSH еще не добавлен в Gitlab.

> Добавляем свой публичный SSH ключ в Gitlab.
> Для этого заходим в gitlab.slurm.io
> В правом верхнем углу нажимаем на значок своей учетной записи.
> В выпадающем меню нажимаем Settings.
> Дальше в левом меню выбираем раздел SSH Keys
> И в поле key вставляем свой ПУБЛИЧНЫЙ SSH ключ.

### Форк проекта

> Открываем в браузере репозиторий xpaste. Он находится по адресу
```bash
https://gitlab.slurm.io/semrush/xpaste
```

> Справа на одной линии с названием проекта видим кнопку fork. Нажимаем ее.
> Выбираем в качестве нэймспэйса в следующем окне свой логин.
> И дожидаемся окончания процесса форка.
> Последним шагом клонируем получившийся форк к себе на админбокс.
```bash
git clone git@gitlab.slurm.io:s<номер своего логина>/xpaste.git
```
> и переходим в директорию проекта
```bash
cd xpaste
```

### Подготовка CI

> Копируем файл из репозитория c практиками в директорию xpaste

```bash
cp ~/slurm/practice/11.ci-cd/step_5_deploy/.gitlab-ci.yml .
```
> Открываем скопированный файл и в нем правим
```yaml
  K8S_API_URL: <адрес своего мастера>
```
> Вставляем вывод предыдущей команды
> НИЧЕГО ПОКА НЕ КОММИТИМ И НЕ ПУШИМ!

> Далее подготавливаем namespace и нужные RBAC объекты.
> Для этого запускаем скрипт setup.sh
```bash
~/slurm/practice/11.ci-cd/step_5_deploy/setup.sh s<номер своего логина>-xpaste production
```
> В конце своего выполнения скрипт выдаст нам токен.
> Его нужно скопировать.

> После этого открываем в браузере свой форк xpaste.
```bash
https://gitlab.slurm.io/s<номер своего логина>/xpaste
```
> В левом меню находим Settings, далее CI/CD и далее Variables и нажимаем Expand
> В левое поле вводим имя переменной
```bash
K8S_CI_TOKEN
```
> В правое поле вводим скопированный токен из вывода команды setup.sh
> Protected не включаем!
> И нажимаем Save variables

> Далее в том же левом меню в Settings > Repository находим Deploy tokens и нажимаем Expand.
> В поле Name вводи
```bash
k8s-pull-token
```
> И ставим галочку рядом с read_registry.
> Все остальные поля оставляем пустыми.
> Нажимаем Create deploy token.
> НЕ ЗАКРЫВАЕМ ОКНО БРАУЗЕРА!

> Возвращаемся в консоль на первом мастере
> Создаем image pull secret для того чтобы кубернетис мог пулить имаджи из гитлаба
```bash
kubectl create secret docker-registry xpaste-gitlab-registry --docker-server registry.slurm.io --docker-email 'student@slurm.io' --docker-username '<первая строчка из окна создания токена в gitlab>' --docker-password '<вторая строчка из окна создания токена в gitlab>' --namespace s<номер своего логина>-xpaste-production
```
> Соответсвенно подставляя на место <> нужные параметры.

### Установка PosgreSQL

> Выполняем моманду заменяя <> на нужные значения
```bash
helm install ~/slurm/practice/10.ci-cd/step_5_deploy/postgresql --name postgresql --namespace s<номер своего логина>-xpaste-production --tiller-namespace s<номер своего логина>-xpaste-production --atomic --timeout 120
```

### Создание секрета для приложения

> Выполняем команду
```bash
kubectl create secret generic slurm-xpaste --from-literal secret-key-base=xxxxxxxxxxxxxxxxxxxxxxxxx --from-literal db-user=postgres --from-literal db-password=postgres --namespace s<номер своего логина>-xpaste-production
```
> в secret-key-base xxxxxxxxxxxxx это не плэйсхолдер.
> Можно так и оставить

### Правка чарта и деплой приложения

> Открываем файл из своего репозитория xpaste
```bash
.helm/values.yaml
```
> Находим там строчку
```yaml
  host: xpaste.s<номер своего логина>.slurm.io
```
> и меняем на свой номер логина

> После этого делаем коммит и пуш
```bash
git add .
git commit -m "add CI/CD"
git push
```

> Смотрим в интейрфесе Gitlab на пайплайн
> После успешного завершения открываем в браузере
```bash
xpaste.s<номер своего логина>.slurm.io
```

Должен открыться сайт для шаринга текстовой информации
