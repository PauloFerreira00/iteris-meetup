protocol RepositoryProtocol {
    func list(success: ([Item]) -> Void, failure: (Error) -> Void)
}

class Repository {
    var worker: APIWorker
    init(worker: APIWorker) {
        self.worker = worker
    }
}

extension Repository: RepositoryProtocol {
    func list(success: ([Item]) -> Void, failure: (Error) -> Void)
        worker.getInfos() { data, error in 
            if let itens: [Item] = data.decode() {
                success(itens)
                return
            }

            failure(error)
        }
    }
}