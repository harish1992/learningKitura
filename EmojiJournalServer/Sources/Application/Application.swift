import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    struct JournalEntry: Codable {
        var id: String?
        var emoji: String
        var date: Date
    }

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        initializeEntryRoutes(app: self)
        router.get("/",handler: helloWorldHandler)
        router.post("/entries",handler: addEntries)

    }
    func helloWorldHandler(request : RouterRequest,
                            response : RouterResponse, next: () -> () ){
        response.headers.setType(MediaType.TopLevelType.text.rawValue)
        response.send("Hello, world!")
        next()
        }
    func addEntries(request: RouterRequest, response:RouterResponse , next: @escaping ()-> ()){
        
        var entry: JournalEntry
        do {
            try entry = request.read(as: JournalEntry.self)
        } catch {
            response.status(.unprocessableEntity)
            if let decodingError = error as? DecodingError {
                response.send("Could not decode received data: " +
                    "\(decodingError.humanReadableDescription)")
            } else {
                response.send("Could not decode received data.")
            }
            return next()
        }
        response.send("Hello ! Worldy\n")
        
        guard let contentHeader = request.headers["Content-Type"], contentHeader.hasPrefix("application/json") else{
            response.status(.unsupportedMediaType)
            response.send(["error":
                "Request Content-Type must be application/json"])
            return next()}
        guard let  hostname=request.headers["host"] else {
            return next()
        }
        response.send(hostname + "\n")
        response.status(.created)
        print(entry)
        
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
