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
$ cp _build/prod/rel/phoenix_distillery/releases/0.0.1/phoenix_distillery.tar.gz local_deploy/
```
и распаковать

3. Запустить
```
$ PORT=50017 ./bin/nsg_acs start
```


4. Проблемы с запуском на Ubuntu
  - пароль для psql postgres:postgres
  убедиться что 'psql -U postgress' работает

  - не находила ncurses.so.6
  сделал линк на ncurses.so.5 так как в Ubuntu ncurses.so.6 еще не устанавливалась
