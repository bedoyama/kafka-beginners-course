#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MAIN_CLASS="${1:?Usage: ./kafka-basics/run.sh <fully-qualified-main-class>}"

cd "$ROOT_DIR"
./gradlew :kafka-basics:classes -q

CLASSPATH="kafka-basics/build/classes/java/main"
while IFS= read -r dep; do
  IFS=: read -r group artifact version <<< "$dep"
  jar=$(find "$HOME/.gradle/caches/modules-2/files-2.1/$group/$artifact/$version" \
    -maxdepth 2 -name '*.jar' ! -name '*sources*' ! -name '*javadoc*' 2>/dev/null | head -1)
  if [[ -n "$jar" ]]; then
    CLASSPATH="$CLASSPATH:$jar"
  fi
done < <(./gradlew -q :kafka-basics:dependencies --configuration runtimeClasspath 2>/dev/null \
  | grep -oE '(com|org)\.[a-z0-9\.]+:[a-z0-9\.-]+:[0-9][0-9\.]+' \
  | sort -u)

exec java -cp "$CLASSPATH" "$MAIN_CLASS"