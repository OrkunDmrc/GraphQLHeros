using Microsoft.EntityFrameworkCore;
using GraphQLHeros.Data;
using GraphQLHeros.Interfaces;
using GraphQLHeros.Repositories;
using HotChocolate.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register custom services for the superheroes
builder.Services.AddScoped<ISuperheroRepository, SuperheroRepository>();
builder.Services.AddScoped<ISuperpowerRepository, SuperpowerRepository>();
builder.Services.AddScoped<IMovieRepository, MovieRepository>();
builder.Services.AddGraphQLServer().AddQueryType<Query>().AddMutationType<Mutation>().AddProjections(name: null).AddFiltering().AddSorting();

// Add Application Db Context options

builder.Services.AddDbContext<ApplicationDbContext>(options => {
    options.UseSqlServer(builder.Configuration.GetConnectionString("SqlServer"));
    options.EnableSensitiveDataLogging(true);
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors(builder => builder
                .AllowAnyHeader()
                .AllowAnyMethod()
                 .SetIsOriginAllowed((host) => true)
                 .AllowCredentials());

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.MapGraphQL(path: "/graphql", null).WithOptions(new GraphQLServerOptions
{
    AllowedGetOperations = AllowedGetOperations.QueryAndMutation,
    EnableGetRequests = true,
    Tool = { Enable = true }
});

app.Run();