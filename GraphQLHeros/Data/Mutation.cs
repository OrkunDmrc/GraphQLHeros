using GraphQLHeros.Models;

namespace GraphQLHeros.Data
{
    public class Mutation
    {
        public Movie SaveMovie([Service] ApplicationDbContext context, Movie movie)
        {
            context.Movies.Add(movie);
            context.SaveChanges();
            return movie;
        }
        public Superhero SaveSuperhero([Service] ApplicationDbContext context, Superhero superhero)
        {
            context.Superheroes.Add(superhero);
            context.SaveChanges();
            return superhero;
        }
        public Superpower AddSuperpower([Service] ApplicationDbContext context, Superpower superpower)
        {
            context.Superpowers.Add(superpower);
            context.SaveChanges();
            return superpower;
        }
        public Movie UpdateMovie([Service] ApplicationDbContext context, Movie movie)
        {
            context.Movies.Update(movie);
            context.SaveChanges();
            return movie;
        }
        public Superhero UpdateSuperhero([Service] ApplicationDbContext context, Superhero superhero)
        {
            context.Superheroes.Update(superhero);
            context.SaveChanges();
            return superhero;
        }
        public Superpower UpdateSuperpower([Service] ApplicationDbContext context, Superpower superpower)
        {
            context.Superpowers.Update(superpower);
            context.SaveChanges();
            return superpower;
        }
        public string DeleteMovie([Service] ApplicationDbContext context, Guid id)
        {
            var movie = context.Movies.Find(id);
            if (movie == null)
            {
                return "Invalid Operation";
            }
            context.Movies.Remove(movie);
            context.SaveChanges();
            return "Record Deleted!";
        }
        public string DeleteSuperhero([Service] ApplicationDbContext context, Guid id)
        {
            var superhero = context.Superheroes.Find(id);
            if(superhero == null)
            {
                return "Invalid Operation";
            }
            context.Superheroes.Remove(superhero);
            context.SaveChanges();
            return "Record Deleted!";
        }
        public string DeleteSuperpower([Service] ApplicationDbContext context, Guid id)
        {
            var superhepower= context.Superpowers.Find(id);
            if (superhepower == null)
            {
                return "Invalid Operation";
            }
            context.Superpowers.Remove(superhepower);
            context.SaveChanges();
            return "Record Deleted!";
        }
    }
}
