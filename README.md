### Task
[Backend challenge](https://www.dropbox.com/s/p04ekckbzb1yj6q/%28Main%29_Backend_3.pdf?dl=0)

1) Clone repo
```
git clone git@github.com:migalenkom/vending-machine.git
cd vending-machine
```
2) Install gems
```
bundle install
```
3) Prepare DB
```
rake db:create
rake db:migrate
rake db:seed
```
4) run the server
```
rails s
```
5) run tests
```
rspec

```

6) Request examples

create user no auth required
```
curl --location --request POST 'http://localhost:3000/api/v1/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user": {
        "username": "test",
        "password": "test",
        "role": "seller"
    }
}'
```
add deposit

```
 curl -u test:test --location --request PUT 'http://localhost:3000/api/v1/users/deposit' \
--header 'Content-Type: application/json' \
--data-raw '{
    "coin": 100
}'
```

user profile

```
curl -u test:test --location --request GET 'http://localhost:3000/api/v1/users/profile'
```

create product

```
curl -u test:test --location --request POST 'http://localhost:3000/api/v1/products' \
--header 'Content-Type: application/json' \
--data-raw '{
    "product": {
        "name": "Pencil",
        "cost": 5,
        "amount": 100
    }
}'
```

buy product

```
curl -u test:test --location --request POST 'http://localhost:3000/api/v1/products/1/buy' \
--header 'Content-Type: application/json' \
--data-raw '{
    "amount" : 3
}'
```
