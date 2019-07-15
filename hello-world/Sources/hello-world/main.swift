import Kitura

let router = Router()

func helloWorldHandler(request: RouterRequest,
                       response: RouterResponse, next: () -> ()) {
    response.send("Hello, world!")
    next() }

router.get("/testing", handler: helloWorldHandler)
Kitura.addHTTPServer(onPort: 8088, with: router)
Kitura.run()
