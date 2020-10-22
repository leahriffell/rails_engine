# Rails Engine

## Overview
Rails Engine is an API that serves up business intelligence analytics to an ecommerce application.

Turing mod 3 solo project

## Readme Content
- [Learning Goals](#learning-goals)
- [Getting Started](#getting-started)
- [Endpoints](#endpoints)
- [Testing](#testing)
- [Database Schema](#database-schema)
- [Next Steps](#next-steps)

## Learning Goals
- Expose an API
- Test API exposure
- Use serializers to format JSON responses
- Compose advanced ActiveRecord queries to analyze information stored in SQL databases
- Write SQL statements without the assistance of an ORM

## Getting Started
```
$ git clone git@github.com:leahriffell/rails_engine.git 
  # or clone your own fork
$ cd rails_engine
```

### Prerequisites
- Ruby 2.5.3
- Rails 5.2.4.4

### Installing
#### Install gems and setup your database:
```
bundle install
rails db:create
rails db:migrate
rails db:seed
```
#### Run your own development server:
```
rails s
```
This is only an API (no frontend view). To access the frontend repo, head to https://github.com/leahriffell/rails_driver.

## Testing
- Run with $ bundle exec rspec. All tests should be passing.

## API Endpoints
- All requests sent to `http://localhost:3000/api/v1`

### Items CRUD Endpoints
```
# Get all items
GET http://localhost:3000/api/v1/items

# Create new item
POST http://localhost:3000/api/v1/items

# Show 1 item
GET http://localhost:3000/api/v1/items/:id

# Update existing item
PATCH http://localhost:3000/api/v1/items/:id

# Destroy an item
DELETE http://localhost:3000/api/v1/items/:id
```

### Merchants CRUD Endpoints
```
# Get all merchants
GET http://localhost:3000/api/v1/merchants

# Create new merchants
POST http://localhost:3000/api/v1/merchants

# Show 1 merchants
GET http://localhost:3000/api/v1/merchants/:id

# Update existing merchants
PATCH http://localhost:3000/api/v1/merchants/:id

# Destroy a merchant
DELETE http://localhost:3000/api/v1/merchants/:id
```

### Relationship Endpoints
#### Get all Items that belong to a Merchant
```
GET /api/v1/merchants/:id/items
```

#### Get an Item's Merchant
```
GET /api/v1/items/:id/merchants
```

### Search Endpoints
#### Items
- Can query by: name*, description*, unit_price, merchant_id, created_at, updated_at

- * search is case insensitive and will also fetch partial matches

```
# Search for 1 Item
GET /api/v1/items/find?<attribute>=<value>

# Search for all Items that match criteria
GET /api/v1/items/find_all?<attribute>=<value>
```

#### Merchants
- Can query by: name (search is case insensitive and will also fetch partial matches)
```
# Search for 1 Merchant
GET /api/v1/merchants/find?<attribute>=<value>

# Search for all Merchants that match criteria
GET /api/v1/merchants/find_all?<attribute>=<value>
```

### Business intelligence Endpoints
#### Merchants with Most Revenue
- Returns a variable number of merchants ranked by total revenue
```
GET /api/v1/merchants/most_revenue?quantity=x
# x is the number of merchants to be returned
```

#### Merchants with Most Items Sold
- Returns a variable number of merchants ranked by total number of items sold
```
GET /api/v1/merchants/most_items?quantity=x
# x is the number of merchants to be returned
```

#### Revenue across Date Range
- Return the total revenue across all merchants between the given dates
```
GET /api/v1/revenue?start=<start_date>&end=<end_date>
```

#### Revenue for a Merchant
- Returns the total revenue for a single merchant
```
GET /api/v1/merchants/:id/revenue
```

## Database Schema
<img src="https://user-images.githubusercontent.com/34531014/96935920-550ab080-1482-11eb-8abe-5323ebe0e408.png" width="700">

## Next Steps:
- In ranking endpoints (by revenue, by number of items sold), include merchants that have $0 revenue
  - Return as 0 instead of not displaying in result set
- Add sad path tests
