## Essential Guideline Project

**Use this project as a guideline not a copy and paste because there's no solution can solve all problems.**
* Try to build your application like you're playing lego, means it should be flexible, easy to add/remove feature. easy to maintain, test,...

---------------------------------------------

## BDD Specs

#### Story: User request to see user feed

##### Narrative #1:
```
As an online customer
I want the app to automatically load my latest user feed
So I can see all the users available.
```

##### Scenarios:
```
Given the customer has connectivity
When the customer request to see their user feed
Then the app should display the latest user feed
    And replace the cache with the new feed
```


##### Narrative #1:
```
As an offline customer
I want the app to automatically load my cached feed
So I still can see all the users available when I don't have connectivity.
```

##### Scenarios:

```
Given the customer does't have connectivity
    And there's a cached version of the feed
When the customer request to see their user feed
Then the app should display the cached user feed
```

```
Given the customer does't have connectivity
    And the cache is empty
When the customer request to see their user feed
Then the app should display an error message
```

## Use Case Specs

#### Load Feed From Remote Use Case

```
Data :
* URL

Primary course (happy path):
- Execute `Load feed from remote` command with above data
- Sytem download data from the URL
- System validate downloaded data
- System create feed item from validated data
- System delivers list of feed item.

No connectivity course (sad path):
- System delivers error message.

Invalid data course (sad path):
- System delivers error message.
```

### Model Specs
#### Feed Item

| Property      | Type                     |
|---------------|---------------------|
| `id`               | `Int`                    |
| `email`         | `String`              |
| `firstName` | `String`              |
| `lastName`   | `String`              |
| `url`             | `URL`                    |

### Payload contract
```
GET /users

200 RESPONSE

{
    "data": [
    {
        "id": 1,
        "email": "george.bluth@reqres.in",
        "first_name": "George",
        "last_name": "Bluth",
        "avatar": "https://reqres.in/img/faces/1-image.jpg"
    },
    {
        "id": 2,
        "email": "janet.weaver@reqres.in",
        "first_name": "Janet",
        "last_name": "Weaver",
        "avatar": "https://reqres.in/img/faces/2-image.jpg"
    },
    {
        "id": 3,
        "email": "emma.wong@reqres.in",
        "first_name": "Emma",
        "last_name": "Wong",
        "avatar": "https://reqres.in/img/faces/3-image.jpg"
    }
        ...
    ]
}
```

---

#### Architucture
![MVP Architucture](../Architecture/mvp.png)
