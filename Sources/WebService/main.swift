import PerfectMongoDB
//import PerfectRequestLogger

enum ErrorsToThrow: Error {
    case nameIsEmpty
}

#if os(Linux)

MySQLConnector.host = "localhost";
MySQLConnector.username = "root";
MySQLConnector.password = "Chason1208";
MySQLConnector.port = 3306;
MySQLConnector.database = "WebService";

RequestLogFile.location="./RequestLog.log";

let server = NetworkServer.init(serverName: "localhost", serverPort: 80);
server.start();

#else

let client = try! MongoClient(uri: "mongodb://localhost")
let db = client.getDatabase(name: "test")
let collection = MongoCollection(
    client: client,
    databaseName: "test",
    collectionName: "testCrashCollection")


defer {
    collection.close()
    db.close()
    client.close()
}

let server = NetworkServer.init(serverName: "localhost", serverPort: 8181);
server.start();
#endif
