#!/bin/bash

set -euo pipefail
type curl >/dev/null && type jq >/dev/null || { echo >&2 "JQ or CURL required, aborting!" | systemd-cat -t gitcheck -p emerg; exit 1; }

WHICH=$(which polkadot)
TMP='/tmp/polka'

polkadot_version () { 
  polkadot --version | awk -F\t '{print $2}' | awk -F- '{gsub(/ /,"v"); print $1}'; 
}

read -r TAG LATEST DRAFT PRERELEASE DURL < <(echo $(curl \
    -H "Content-Type: application/json" \
    -H "$GAUTH" \
    -s \
    --retry 2 \
    --retry-delay 3 \
    --retry-connrefused \
    --url "https://api.github.com/graphql" \
    --data "@$1" | jq -r " .[] | \
    .repository.latestRelease.tagName, \
    .repository.latestRelease.isLatest, \
    .repository.latestRelease.isDraft, \
    .repository.latestRelease.isPrerelease, \
    .repository.latestRelease.releaseAssets.nodes[].downloadUrl" \
  ) \
);

if ! [[ "$TAG" == "$(polkadot_version)" ]];
then
  if [[ "$LATEST" = "true" ]];
  then
    if [[ "$DRAFT" == "false" ]];
    then 
      if [[ "$PRERELEASE" == "false" ]];
      then
        if curl --silent --location --head --fail --range 0-0 --output /dev/null --url "$DURL";
        then
          curl --silent --location --retry 2 --retry-delay 10 --retry-connrefused --create-dirs --output $TMP/polkadot --url "$DURL"
          chmod +x "$TMP"/polkadot
          if cp --force "$WHICH" "$TMP"/polkadot."$(polkadot_version)";
          then
            systemctl stop polkadot.service 
            mv --force "$TMP"/polkadot "$WHICH"
            systemctl start polkadot.service
            if [[ "$(polkadot_version)" == "$TAG" ]];
            then
              if [ "$(systemctl is-active --quiet polkadot)" ];
              then
                echo "Polkadot validating on $(polkadot_version)" | systemd-cat -t gitcheck -p info
              else
                echo "Polkadot crash! on $(polkadot_version)" | systemd-cat -t gitcheck -p emerg
              fi
            else
              echo "The update for $(polkadot_version) fail! TAG is $TAG" | systemd-cat -t gitcheck -p emerg
            fi
          else
            echo "The cp commnad fail" | systemd-cat -t gitcheck -p emerg
          fi
        else
          echo "No binary file to get" | systemd-cat -t gitcheck -p emerg
        fi
      else
        echo "Pre-Release: $PRERELEASE" | systemd-cat -t gitcheck -p info
      fi
    else
      echo "Draft: $DRAFT" | systemd-cat -t gitcheck -p info
    fi
  else
    echo "Latest: $LATEST" | systemd-cat -t gitcheck -p info
  fi
else
  echo "R$TAG-L$(polkadot_version)" | systemd-cat -t gitcheck -p info
fi
exit 0
