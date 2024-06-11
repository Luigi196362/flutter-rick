const String getLinksQuery = """
query getLink{
  characters{
    id
    name 
    image
    genre
    species
    status
    postedBy{
      username
    }
    votes{
      id
    }
  }
}
""";

const String createUserMutation = """
mutation createUser(\$email: String!, \$password: String!, \$username: String!){
  createUser(email: \$email, password: \$password, username: \$username){
    user{
      email
      username
      password
    }
  }
}
""";

const String createLinkMutation = """
mutation createLink(\$name: String!,  \$image: String!, \$genre: String!, \$species: String!, \$status: String!){
  createCharacter(name: \$name,  image: \$image, genre:\$genre,  species:\$species,  status:\$status) {
    id
    name
    image
    genre
    species
    status
  }
}
""";

const String tokenAuthMutation = """
mutation tokenAuth(\$username: String!, \$password: String!){
  tokenAuth(username: \$username, password: \$password){
    token
  }
}
""";

const String createVoteMutation = """
mutation createVote(\$linkId: Int!){
  createVote(characterId: \$linkId){
    user{
      username
    }
  }
}
""";
