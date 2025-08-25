# Blog Server

### Локальный запуск

1. Клонируйте репозиторий:

```bash
git clone <repository>
cd test_devops
```

2. Запустите приложение:

```bash
docker-compose up -d
```

3. Приложение будет доступно по адресу: http://localhost:8080

4. API документация: http://localhost:8080/docs

### Остановка

```bash
docker-compose down
```

## API Endpoints

### GET /posts

Получить список всех публикаций

**Response:**

```json
[
  {
    "id": 1,
    "title": "Hello world",
    "content": "My first post!"
  }
]
```

### POST /posts

Создать новую публикацию

**Request:**

```json
{
  "title": "Another post",
  "content": "Content"
}
```

**Response:**

```json
{
  "id": 2,
  "title": "Another post",
  "content": "Content"
}
```

## Технологии

- **Backend**: Python 3.11, FastAPI
- **БД**: PostgreSQL 15
- **Контейнеризация**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **ORM**: SQLAlchemy 2.0
- **Валидация данных**: Pydantic

## Проверка работоспособности (Smoke Test)

1. **Проверка доступности сервиса:**

```bash
curl http://localhost:8080/
```

2. **Создание поста:**

```bash
curl -X POST http://localhost:8080/posts \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Post", "content": "Test content"}'
```

3. **Получение списка постов:**

```bash
curl http://localhost:8080/posts
```

## Автоматический деплой

Приложение автоматически разворачивается на сервере при пуше в основную ветку через GitHub Actions.

### Необходимые GitHub Secrets:

- **`HOST`** - IP адрес или домен сервера
- **`USERNAME`** - имя пользователя для SSH подключения
- **`SSH_KEY`** - приватный SSH ключ
- **`PORT`** - SSH порт

### Настройка:

1. В репозитории GitHub: **Settings** → **Secrets and variables** → **Actions**
2. Добавить все необходимые секреты
3. Настроить сервер с Docker Engine и SSH доступом
4. При пуше в `main`/`master` ветку автоматически запустится деплой
