# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApi.Repo.insert!(%TodoApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
  title: "Buy groceries",
  description: "Milk, eggs, bread, cheese, apples, bananas",
  completed: false,
  deadline: ~D[2023-09-25]
})

TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
  title: "Finish homework",
  description: "Math, English, History",
  completed: true,
  deadline: ~D[2023-09-20]
})

TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
  title: "Call mom",
  description: "Wish her happy birthday",
  completed: false,
  deadline: ~D[2023-09-22]
})
