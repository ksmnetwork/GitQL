# GitQL
#### Polkadot binary updater with Github GraphQL API v4, JQ, CURL and without Git

A basic script that will check the latest Polkadot release TAG version commited and it's status as "Latest, Draft, Pre-Release"
if all the conditions are fulfilled it will do a secondary check if a binary file exist, then it will download, backup, restart and wait to see the application status.

Outputs are outputed to the journald for external monitoring, will suggest "Grafana, Loki and Promtail" for free!

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
  
# For Support && Nominations
- Display name. KSMNETWORK && KSMNETWORK-WEST 
- Email w3f@ksm.network
- Riot @gtoocool:matrix.org

- KUSAMA (KSM) Address
- ```H1bSKJxoxzxYRCdGQutVqFGeW7xU3AcN6vyEdZBU7Qb1rsZ```

- PolkaDOT (DOT) Address:
- ```15FxvBFDd3X7H9qcMGqsiuvFYEg4D3mBoTA2LQufreysTHKA```

- https://ksm.network
  
