# GitQL
#### Polkadot binary updater with Github GraphQL API v4, JQ, CURL and without Git

A basic script that will check the latest Polkadot release TAG version commited and it's status as "Latest, Draft, Pre-Release"
if all the conditions are fulfilled it will do a secondary check if a binary file exist, then it will download, backup, restart and wait to see the application status.

Outputs are outputed to the journald, will suggest "Grafana, Loki and Promtail".
- [KUSAMA Validator Simple Monitoring](https://github.com/ksmnetwork/kusama-promtail)

Dependencies: 
- CURL apt/yum install -y curl
- JQ apt/yum install -y jq
- GitHUB API TOKEN

Steps:
- Creating a personal access token in GitHUB and add it as environment variable ( GAUTH='Authorization: Bearer <TOKEN>' )
- To match the behavior of the GraphQL Explorer, request the following scopes:
- - public_repo
- Since we are using the first positional parameter to include local file for our query ( --data "@$1" )
- Run it with './gitCron.sh latest.query' 
- - NOTE: for CRON use '/etc/environment' for the environment variables 

Others:
- Same TOKEN and QUERY can be used with Grafana it self by adding GraphQL Plugin and outhorise to 'https://api.github.com/graphql' in the options
- - Grafana Alerting && OnCall compatible
- Ract + Apollo + NextJS for your pocket app.

```
import Head from 'next/head'
import { setContext } from '@apollo/client/link/context';
import { ApolloClient, InMemoryCache, createHttpLink, gql } from "@apollo/client";

export default function Home({repository}) {
  return ( <div> {repository.latestRelease.tagName} </div> )
}

export async function getStaticProps() {
  const httpLink = createHttpLink({ uri: 'https://api.github.com/graphql' });
  const authLink = setContext((_, { headers }) => {
    return { headers: { ...headers, authorization: `Bearer <TOKEN>` } }
  });
  const client = new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache()
  });
  const {data} = await client.query({
    query: gql`
      { 
        repository(owner: "paritytech", name: "polkadot", followRenames: true) {
          latestRelease { tagName }
        }
      }
    `
  });
  const { repository } = data;

  return {
    props: { repository }
  }
}
```
  
# For Support && Nominations
- Display name. KSMNETWORK && KSMNETWORK-WEST 
- Email w3f@ksm.network
- Riot @gtoocool:matrix.org

- KUSAMA (KSM) Address
- ```H1bSKJxoxzxYRCdGQutVqFGeW7xU3AcN6vyEdZBU7Qb1rsZ```

- PolkaDOT (DOT) Address:
- ```15FxvBFDd3X7H9qcMGqsiuvFYEg4D3mBoTA2LQufreysTHKA```

- https://ksm.network
  
