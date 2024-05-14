# Vapor + REST
This project aims to explore & demostrate some of the capabilities of Vapor + Fluent. This is a very simple Sports server that explores the following:

  1) Models, Migrations + Controllers
  2) Relationships: Parent & Sibling
  3) Athentication
  4) Route Protection: Middleware
  5) Fluent: Database Queries

## How to run?

The project has been updated to use async/await and the package has been configure for 'strict concurrency' checking in preparation for Swift 6.0. To set up & run this project, please do the following:

  1) Install Vapor & Docker on your machine
  2) Dowanload the package from this repository
  3) On terminal, cd into the folder where you saved this project and run:
     - vapor xcode
  5) Create a Docker container to host your local database:
     - docker run --name vapor-rest-demo -e POSTGRES_DB=vapor_database \
        -e POSTGRES_USER=vapor_username \
        -e POSTGRES_PASSWORD=vapor_password \
        -p 5432:5432 -d postgres
  6) Set the project schema to the folder where your project lives:
     - Edit Schema > Working Directory > Check “Use custom directory” > [Choose your project’s folder]

## Endpoints

Here are the project's User endpoints: 
1) http://127.0.0.1:8080/api-v1/user
2) http://127.0.0.1:8080/api-v1/user/search?term=
3) http://127.0.0.1:8080/api-v1/user/ATHLETE_ID
4) http://127.0.0.1:8080/api-v1/user/ATHLETE_ID/coach
5) http://127.0.0.1:8080/api-v1/user/ATHLETE_ID/athlete
	
Here are the project's Athlete endpoints:
1) http://127.0.0.1:8080/api-v1/athlete
2) http://127.0.0.1:8080/api-v1/athlete/search?term=
3) http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID
4) http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID/user
5) http://127.0.0.1:8080/api-v1/athlete/ATHLETE_ID/coach

 Here are the project's Drill endpoints:
1) http://127.0.0.1:8080/api-v1/drill
2) http://127.0.0.1:8080/api-v1/drill/search?term=
3) http://127.0.0.1:8080/api-v1/drill/DRILL_ID
4) http://127.0.0.1:8080/api-v1/drill/DRILL_ID/user

 Here are the project's Coach endpoints:
1) http://127.0.0.1:8080/api-v1/coach
2) http://127.0.0.1:8080/api-v1/coach/search?term=
3) http://127.0.0.1:8080/api-v1/coach/COACH_ID
4) http://127.0.0.1:8080/api-v1/coach/COACH_ID/user
5) http://127.0.0.1:8080/api-v1/coach/COACH_ID/athlete/ATHLETE_ID
6) http://127.0.0.1:8080/api-v1/coach/COACH_ID/athlete

 Here are the project's Authentication endpoints:
1) http://127.0.0.1:8080/api-v1/login
2) http://127.0.0.1:8080/api-v1/token
3) http://127.0.0.1:8080/api-v1/authentication
4) http://127.0.0.1:8080/api-v1/token/TOKEN_ID
