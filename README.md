# Luciq Chat System

A scalable chat system API built with Ruby on Rails that supports multiple applications, chats, and messages with full-text search capabilities.

## Features

- **Multi-application support**: Create and manage multiple chat applications
- **Sequential numbering**: Automatic chat and message numbering per application/chat
- **Full-text search**: Search messages using Elasticsearch
- **Race condition handling**: Redis-based atomic counters for concurrent requests
- **Async processing**: Background jobs for database writes using Sidekiq
- **RESTful API**: Clean REST endpoints with nested resources
- **Containerized**: Complete Docker setup for easy deployment

## Technology Stack

- **Ruby on Rails** 8.1 - API framework
- **MySQL** 8.0 - Primary database
- **Redis** 7 - Counter management and job queue
- **Elasticsearch** 8.13 - Full-text search engine
- **Sidekiq** - Background job processing
- **Docker & Docker Compose** - Containerization

## Prerequisites

- Docker
- Docker Compose

That's it! Everything else runs in containers.

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd luciq_chat_system
   ```

2. **Start the application**
   ```bash
   docker-compose up
   ```

   This single command will:
   - Start MySQL database
   - Start Redis server
   - Start Elasticsearch
   - Run database migrations
   - Start the Rails API server (port 3000)
   - Start Sidekiq workers

3. **Wait for services to be healthy**
   
   The application will wait for all services to pass health checks before starting. You should see:
   ```
   api_1    | => Booting Puma
   api_1    | => Rails 8.1.0 application starting in development
   api_1    | => Run `bin/rails server --help` for more startup options
   api_1    | * Listening on http://0.0.0.0:3000
   ```
   
   **Note:** On first startup, the application will automatically create Elasticsearch indices for message search.

4. **Test the API**
   ```bash
   curl http://localhost:3000/applications
   ```

## API Documentation

Base URL: `http://localhost:3000`

### Postman Collection

A complete Postman collection is available for testing all API endpoints.

**📥 Import Collection:**

1. Download the collection file: [Luciq-Chat-System.postman_collection.json](./.postman/Luciq-Chat-System.postman_collection.json)
2. Open Postman
3. Click **Import** button (top left)
4. Drag and drop the file or click **Upload Files**
5. Select the downloaded JSON file
6. Click **Import**

**✨ Collection Features:**
- All API endpoints with example requests
- Pre-configured variables for seamless testing
- Sample request bodies and parameters
- Organized folder structure by resource type
- Ready-to-use test scenarios

**🔧 Environment Setup:**

After importing, create a new environment in Postman with:
- `chat_app_url`: `http://localhost:3000`
- `application_token`: (auto-populated after creating an application)
- `chat_number`: (auto-populated after creating a chat)

**💡 Usage Tip:** Execute requests in order (Applications → Chats → Messages) for the best testing experience.

---

### Applications

#### Create Application
```http
POST /applications
Content-Type: application/json

{
  "application": {
    "name": "My Chat App"
  }
}
```

**Response:**
```json
{
  "token": "abc123def456",
  "name": "My Chat App",
  "chats_count": 0,
  "created_at": "2025-10-26T10:00:00.000Z",
  "updated_at": "2025-10-26T10:00:00.000Z"
}
```

#### List Applications
```http
GET /applications?page=1&per_page=25
```

**Response:**
```json
{
  "current_page": 1,
  "per_page": 25,
  "total_pages": 1,
  "total_count": 5,
  "applications": [
    {
      "token": "abc123def456",
      "name": "My Chat App",
      "chats_count": 3,
      "created_at": "2025-10-26T10:00:00.000Z",
      "updated_at": "2025-10-26T10:00:00.000Z"
    }
  ]
}
```

#### Get Application
```http
GET /applications/{token}
```

#### Update Application
```http
PATCH /applications/{token}
Content-Type: application/json

{
  "application": {
    "name": "Updated App Name"
  }
}
```

---

### Chats

#### Create Chat
```http
POST /applications/{application_token}/chats
```

**Response:**
```json
{
  "application_token": "abc123def456",
  "chat_number": 1,
  "messages_count": 0
}
```

**Note:** Chat creation is asynchronous. The chat number is returned immediately, but the chat is persisted to the database via a background job.

#### List Chats
```http
GET /applications/{application_token}/chats?page=1&per_page=25
```

**Response:**
```json
{
  "current_page": 1,
  "per_page": 25,
  "total_pages": 1,
  "total_count": 3,
  "chats": [
    {
      "application_token": "abc123def456",
      "number": 1,
      "messages_count": 5,
      "created_at": "2025-10-26T10:00:00.000Z",
      "updated_at": "2025-10-26T10:00:00.000Z"
    }
  ]
}
```

#### Get Chat
```http
GET /applications/{application_token}/chats/{chat_number}
```

---

### Messages

#### Create Message
```http
POST /applications/{application_token}/chats/{chat_number}/messages?body=Hello%20World
```

**Response:**
```json
{
  "message_number": 1,
  "body": "Hello World",
  "application_token": "abc123def456",
  "chat_number": 1
}
```

**Note:** Message creation is asynchronous. The message number is returned immediately, but the message is persisted to the database via a background job.

#### List Messages
```http
GET /applications/{application_token}/chats/{chat_number}/messages?page=1&per_page=25
```

**Response:**
```json
{
  "current_page": 1,
  "per_page": 25,
  "total_pages": 1,
  "total_count": 5,
  "messages": [
    {
      "number": 1,
      "body": "Hello World",
      "application_token": "abc123def456",
      "chat_number": 1,
      "created_at": "2025-10-26T10:00:00.000Z",
      "updated_at": "2025-10-26T10:00:00.000Z"
    }
  ]
}
```

#### Get Message
```http
GET /applications/{application_token}/chats/{chat_number}/messages/{message_number}
```

#### Update Message
```http
PATCH /applications/{application_token}/chats/{chat_number}/messages/{message_number}
Content-Type: application/json

{
  "message": {
    "body": "Updated message content"
  }
}
```

#### Search Messages
```http
GET /applications/{application_token}/chats/{chat_number}/messages/search?q=hello&page=1&per_page=25
```

**Response:**
```json
{
  "query": "hello",
  "current_page": 1,
  "per_page": 25,
  "total_pages": 1,
  "total_count": 2,
  "messages": [
    {
      "number": 1,
      "body": "Hello World",
      "application_token": "abc123def456",
      "chat_number": 1,
      "created_at": "2025-10-26T10:00:00.000Z",
      "updated_at": "2025-10-26T10:00:00.000Z"
    }
  ]
}
```

**Search Features:**
- Partial word matching (word_start)
- Case-insensitive
- Searches within message body
- Paginated results

---

## Database Schema

### Applications Table
- `token` (string, unique) - Application identifier
- `name` (string) - Application name
- `chats_count` (integer, default: 0) - Counter cache
- `created_at`, `updated_at` (datetime)

**Indexes:**
- Unique index on `token`

### Chats Table
- `application_id` (bigint) - Foreign key
- `number` (integer) - Sequential number within application
- `messages_count` (integer, default: 0) - Counter cache
- `created_at`, `updated_at` (datetime)

**Indexes:**
- Unique composite index on `(application_id, number)`
- Foreign key index on `application_id`

### Messages Table
- `chat_id` (bigint) - Foreign key
- `number` (integer) - Sequential number within chat
- `body` (string) - Message content
- `created_at`, `updated_at` (datetime)

**Indexes:**
- Unique composite index on `(chat_id, number)`
- Foreign key index on `chat_id`


## Environment Variables

The application uses the following environment variables (configured in `docker-compose.yml`):

- `DB_HOST` - MySQL host (default: db)
- `DB_PASSWORD` - MySQL password
- `REDIS_URL` - Redis connection URL
- `ELASTICSEARCH_URL` - Elasticsearch connection URL

## Project Structure

```
app/
├── controllers/         # API endpoints
│   ├── applications_controller.rb
│   ├── chats_controller.rb
│   └── messages_controller.rb
├── models/             # ActiveRecord models
│   ├── application.rb
│   ├── chat.rb
│   └── message.rb
├── services/           # Business logic
│   ├── applications/
│   ├── chats/
│   └── messages/
├── jobs/               # Background jobs
│   ├── chat_creation_job.rb
│   └── message_creation_job.rb
└── dtos/               # Data transfer objects
    ├── application_dto.rb
    ├── chat_dto.rb
    └── message_dto.rb

config/
├── routes.rb           # API routes
├── database.yml        # Database config
└── initializers/
    ├── redis.rb        # Redis config
    ├── sidekiq.rb      # Sidekiq config
    └── searchkick.rb   # Elasticsearch config

db/
└── migrate/            # Database migrations
```
