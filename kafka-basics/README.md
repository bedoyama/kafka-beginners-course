# Kafka Basics

Java demos for the Kafka for Beginners course.

## Intro to Kafka

[What is Apache Kafka](https://www.conduktor.io/kafka/what-is-apache-kafka)

## Running from the terminal

Long-running consumers are awkward to stop from IntelliJ when there is no visible exit control. Run them from a terminal instead so you can stop the process with **Ctrl+C** — especially important for `ConsumerDemoWithShutdown`, which demonstrates graceful shutdown.

### Prerequisites

- Kafka is running locally at `127.0.0.1:9092`
- Your commands are run from the **repository root** (the folder that contains `gradlew`)

### Run a demo

Use the helper script and pass the fully qualified main class name:

```bash
./kafka-basics/run.sh io.conduktor.demos.kafka.ConsumerDemoWithShutdown
```

The script compiles the module if needed, builds the classpath, and starts the program.

### Available demos

| Demo | Main class |
|------|------------|
| ProducerDemo | `io.conduktor.demos.kafka.ProducerDemo` |
| ProducerDemoWithCallback | `io.conduktor.demos.kafka.ProducerDemoWithCallback` |
| ProducerDemoKeys | `io.conduktor.demos.kafka.ProducerDemoKeys` |
| ConsumerDemo | `io.conduktor.demos.kafka.ConsumerDemo` |
| ConsumerDemoWithShutdown | `io.conduktor.demos.kafka.ConsumerDemoWithShutdown` |
| ConsumerDemoCooperative | `io.conduktor.demos.kafka.ConsumerDemoCooperative` |
| ConsumerDemoAssignSeek | `io.conduktor.demos.kafka.advanced.ConsumerDemoAssignSeek` |
| ConsumerDemoRebalanceListener | `io.conduktor.demos.kafka.advanced.ConsumerDemoRebalanceListener` |
| ConsumerDemoThreads | `io.conduktor.demos.kafka.advanced.ConsumerDemoThreads` |

Examples:

```bash
# Produce a few messages first
./kafka-basics/run.sh io.conduktor.demos.kafka.ProducerDemo

# Then consume them (stop with Ctrl+C)
./kafka-basics/run.sh io.conduktor.demos.kafka.ConsumerDemoWithShutdown
```

### Stopping a consumer

Press **Ctrl+C** in the terminal. For `ConsumerDemoWithShutdown`, you should see logs like:

```
Detected a shutdown, let's exit by calling consumer.wakeup()...
Consumer is starting to shut down
The consumer is now gracefully shut down
```

### Manual run (without the script)

If you prefer not to use `run.sh`, compile once:

```bash
./gradlew :kafka-basics:classes
```

Then run with `java`, replacing the main class as needed:

```bash
java -cp "kafka-basics/build/classes/java/main:$(./gradlew -q :kafka-basics:dependencies --configuration runtimeClasspath 2>/dev/null | grep -oE '(com|org)\.[a-z0-9\.]+:[a-z0-9\.-]+:[0-9][0-9\.\-]+' | sort -u | while IFS=: read -r g a v; do find "$HOME/.gradle/caches/modules-2/files-2.1/$g/$a/$v" -maxdepth 2 -name '*.jar' ! -name '*sources*' ! -name '*javadoc*' 2>/dev/null | head -1; done | paste -sd: -)" io.conduktor.demos.kafka.ConsumerDemoWithShutdown
```