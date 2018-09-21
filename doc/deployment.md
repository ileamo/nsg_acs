1. Подготовить релиз
https://hexdocs.pm/distillery/guides/phoenix_walkthrough.html
```
$ mix deps.get --only prod
$ MIX_ENV=prod mix compile
$ cd assets
$ node node_modules/brunch/bin/brunch build --production
$ cd ..
$ mix phx.digest
$ mix release.init
$ MIX_ENV=prod mix release
```

Одной командой
```
$ cd assets && ./node_modules/brunch/bin/brunch b -p && cd .. && MIX_ENV=prod mix do phx.digest, release --env=prod
```

2. Скопировать
```
$ cp _build/prod/rel/nsg_acs/releases/0.0.1/nsg_acs.tar.gz local_deploy/
```
и распаковать

3. Запуск

```
$ ./bin/nsg_acs migrate
$ ./bin/nsg_acs seed
$ PORT=50017 ./bin/nsg_acs start
```


4. Проблемы с запуском на Ubuntu
  - пароль для psql postgres:postgres
  убедиться что 'psql -U postgress' работает

  - создать базу данных
  create database nsg_acs_prod;

  - не находила ncurses.so.6
  сделал линк на ncurses.so.5 так как в Ubuntu ncurses.so.6 еще не устанавливалась


5. Выпуск следующего релиза

  Поменять номер версии в mix.exs

```
$ cd assets && ./node_modules/brunch/bin/brunch b -p && cd .. && MIX_ENV=prod mix do phx.digest, release --env=prod --upgrade

$ cp _build/prod/rel/nsg_acs/releases/0.0.2/nsg_acs.tar.gz local_deploy/releases/0.0.2/
```

На хосте
```
$ ./bin/nsg_acs upgrade 0.0.2
```

6. Команда для проверки API
```
curl -H "Content-Type: application/json" -X POST -d '{"id":1,"method":"get.conf","params":{"serial_num":"1701000069","nsg_device":"NSG1700"}}' http://10.0.10.155:50017/api
```
