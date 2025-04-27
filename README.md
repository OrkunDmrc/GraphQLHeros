# GraphQLHeros

GraphQLHeros is a full-stack application that demonstrates CRUD operations using .NET Core for the backend and Flutter for the frontend. It features a GraphQL API and a Flutter-based cross-platform client.

## Features

### Backend (.NET Core)
- GraphQL API with HotChocolate.
- CRUD operations for superheroes, superpowers, and movies.
- Entity Framework Core with MS-SQL database.
- Pre-configured data seeding for superheroes, superpowers, and movies.
- Supports filtering, sorting, and projections in GraphQL queries.

### Frontend (Flutter)
- Cross-platform support for Android, iOS, Windows, macOS, Linux, and Web.
- Integration with `graphql_flutter` for GraphQL queries and mutations.
- Material Design UI.

## Technologies Used

### Backend
- .NET Core
- Entity Framework Core
- HotChocolate GraphQL
- MS-SQL

### Frontend
- Flutter
- Dart
- `graphql_flutter`
- `http`


## Getting Started

### Backend
1. Install [.NET SDK](https://dotnet.microsoft.com/download).
2. Set up a MS-SQL database and update the connection string in `appsettings.json`.
3. Run the following commands:
   ```bash
   cd GraphQLHeros/GraphQLHeros
   dotnet restore
   dotnet ef database update
   dotnet run
4. Access the GraphQL Playground at

   `https://localhost:5001/graphql`.

### Frontend
1. Intall [Flutter](https://docs.flutter.dev/get-started/install)
2. Navigate to the Flutter project directory
   ```bash
   cd GraphQLHeros/GraphQLFlutter/flutter_graphql
3. Install dependencies
   ```bash
   flutter pub get
4. Run the application
   ```bash
   flutter run