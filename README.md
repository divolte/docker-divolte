# Divolte Base image

Base image with [Divolte](http://divolte.io).

## Configuration options

The following environment variables can influence the default configuration:

|env var|default|options|description|
| --- | --- | --- | --- |
| DIVOLTE_HOST |  |  | Hostname the application binds on |
| DIVOLTE_PORT  | 8290 |  | The port the application runs on |
| DIVOLTE_USE_XFORWARDED_FOR | false | true, false | Whether to trust the X-Forwarded-For header HTTP header |
| DIVOLTE_SERVE_STATIC_RESOURCES | true | true, false | Serve the static testing page |
| DIVOLTE_HDFS_ENABLED | false | true, false | Write events in avro format to HDFS |
| DIVOLTE_HDFS_SINK_SYNC_NR_OF_RECORDS | 1000 |  | Max nr of records before file is synced |
| DIVOLTE_HDFS_SINK_SYNC_DURATION | 30 minutes | a duration | Max duration before file is synced |
| DIVOLTE_HDFS_SINK_WORKING_DIR | /tmp/working |  | HDFS working directory path |
| DIVOLTE_HDFS_SINK_PUBLISH_DIR | /tmp/publish |  | HDFS publish directory path |
| DIVOLTE_GFS_ENABLED | false | true, false | Write events in avro format to GFS |
| DIVOLTE_KAFKA_ENABLED | true | true, false | Write events in avro format to Kafka |
| DIVOLTE_KAFKA_BROKER_LIST | localhost:9092 |  | The Kafka bootstrap server list |
| DIVOLTE_KAFKA_CLIENT_ID | divolte.collector |   | The Kafka client id for the producer |
| DIVOLTE_PARTY_COOKIE | \_dvp |   | Name of the party cookie |
| DIVOLTE_PARTY_TIMEOUT | 730 days |   | Validity of the party cookie |
| DIVOLTE_SESSION_COOKIE | \_dvs |   | Name of the session cookie |
| DIVOLTE_SESSION_TIMEOUT | 30 minutes |   | Validity of the session cookie |
| DIVOLTE_COOKIE_DOMAIN | '' |  | The cookie domain for the cookies |
| DIVOLTE_JAVASCRIPT_NAME | divolte.js |   | Name of the js file to include in the web application |
| DIVOLTE_JAVASCRIPT_LOGGING | false | true, false | Enable javascript logging in the console |
| DIVOLTE_JAVASCRIPT_DEBUG | false | true, false | Enable javascript debug logging in the console  |
| DIVOLTE_JAVASCRIPT_AUTO_PAGE_VIEW_EVENT | true | true, false | Generate the default page view event on loading the js library |
| DIVOLTE_KAFKA_TOPIC | divolte |  | The topic where the events are published |

## Running the container
```
docker-compose pull
docker-compose --project-name divolte up
```

## Testing

Testing if the image works can be done by using the Kafka console producer/consumer
since we named the image we need to add an entry to the `/etc/hosts` file to connect the name `divolte-kafka` to the local ip `127.0.0.1`:

```
127.0.0.1       divolte-kafka
```

Now we can use that hostname (the same as the advertised host) to connect the producer and consumer:

```
kafka-console-producer --broker-list divolte-kafka:9092 \
  --topic divolte
```

Sending messages can be done by typeing the following in the console:
```
message1
message2
```

To consume this use the following in a separate terminal window:
```
kafka-console-consumer --bootstrap-server divolte-kafka:9092 \
  --topic divolte \
  --from-beginning

message1
message2
```

## Divolte test page

Open the page `http://localhost:8290` in your browser. A pageview event is sent onload. If you click the button a custom event is sent to divolte.
If you still have the console consumer running you should see the Avro-encoded message passing by. Something like this:

```
?ĖԞW?ĖԞW192.168.0.1,http://localhost:8290/??
                                           ??V0:j4it1gyt:k3Ch09eSqfZLxs9si86U8iw_ANxUimkqV0:j4it1gyt:JqUiAcIiYjNv7rpK4GvjUR0a1bxgA4LjD0:1npO4TIYAVmC6Tb2L4Edpf~32KmcMDGNpageView?Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36
                                                            Chrome
                                                                  ChromeGoogle Inc.Browser59.0.3071.104"Personal computeOS X10.12.5(Apple Computer, Inc.
??ԞW??ԞW192.168.0.1,http://localhost:8290/??
                                           ??V0:j4it1gyt:k3Ch09eSqfZLxs9si86U8iw_ANxUimkqV0:j4it1gyt:JqUiAcIiYjNv7rpK4GvjUR0a1bxgA4LjD0:1npO4TIYAVmC6Tb2L4Edpf~32KmcMDGNbannerClick?Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36
                                                               Chrome
                                                                     ChromeGoogle Inc.Browser59.0.3071.104"Personal computeOS X10.12.5(Apple Computer, Inc.
```

## Kerberos

If you want to have a Kerberized Kafka cluster use the `docker-compose-kerberos` file to spin up the images.
You need to provide the projectname `divolte` for it to work:

```
docker-compose --project-name divolte -f docker-compose-kerberos.yml up
```
