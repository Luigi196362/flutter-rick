import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  'http://34.125.245.194:8000/graphql/',
);

GraphQLClient getGraphQLClient({String? token}) {
  Link link = httpLink;

  if (token != null) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'JWT $token',
    );
    link = authLink.concat(httpLink);
  }

  return GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );
}
