class ProductListViewModelTest: XCTestCase {
    func testFetchWWithSuccess() {
        let view = MockView()
        let repository = MockRepository(.sucess([]))

        let vm = ProductListViewModel()
        vm.set(view: view)
        vm.set(repository: repository)

        vm.fetchListOfProducts()
        XCTAssertTrue(view.showLoadingWasCalled)
        XCTAssertTrue(view.hideLoadingWasCalled)
        XCTAssertTrue(view.reloadTableWasCalled)
    }

    func testFetchWithError() {
        let view = MockView()
        let repository = MockRepository(.error)

        let vm = ProductListViewModel()
        vm.set(view: view)
        vm.set(repository: repository)

        vm.fetchListOfProducts()
        XCTAssertTrue(view.showLoadingWasCalled)
        XCTAssertTrue(view.hideLoadingWasCalled)
        XCTAssertTrue(view.erroWasCalled)
        XCTAssertEquals(view.erroWasCalledWithMessage, "Deu ruim")
    }

    func testCellGenerate() {
        let view = MockView()
        let repository = MockRepository(.sucess([
                Product.create(), 
                Feedback.create(), 
                Advertisement.create()
            ]))

        let generator = MockTableGenerator()

        let vm = ProductListViewModel()
        vm.set(view: view)
        vm.set(repository: repository)
        vm.set(generator: generator)

        vm.fetchListOfProducts()

        XCTAssertEquals(vm.numberOfRows(), 3)
        XCTAssertTrue(generator.productCell.defineWasCalled)
        XCTAssertEquals(generator.productCell.defineWasCalledWith.url, "https........")
    }
}

class MockView: ProductListViewProtocol {
    var showLoadingWasCalled = false
    var hideLoadingWasCalled = false
    var reloadTableWasCalled = false

    var errorWasCalled = false
    var erroWasCalledWithMessage = ""

    func show(title: String, detail: String) {} 
    func reloadTable() {
        self.reloadTableWasCalled = true
    }

    func showLoading() {
        self.showLoadingWasCalled = true
    }
    func hideLoading() {
        self.hideLoadingWasCalled = true
    }
    func error(message: String) {
        self.errorWasCalled = true
        self.erroWasCalledWithMessage = message
    }

    func to() -> UIView { return UIView() }
 }

class MockRepository: RepositoryProtocol {
    enum RepositoryResult {
        case success([Item])
        case error
    }

    init(result: RepositoryResult) {
        self.result = result
    }

    func list(success: ([Item]) -> Void, failure: (Error) -> Void) {
        switch result {
        case .success(let itens):
            success(itens)
        case .error:
            error(Error.unknown)
        }
    }
}

class MockTableGenerator: TableViewCellGenerator {
    var productCell: ProductCellProtocol = MockProductCell()
    var feedbackCell: FeedbackViewProtocol = MockFeedbackCell()
    var adCell: AdvertisementViewProtocol = MockAdvertisementCell()

    func create<T: UITableViewCell, K>(type: T.Type, _ builder: @escaping (K) -> Void) -> UITableViewCell {
        if type == ProductCellTableView.self {
            builder(productCell)
        }

        if type == FeedbackCell.self {
            builder(feedbackCell)
        }

        if type == AdvertisementCell.self {
            builder(adCell)
        }

        return UITableViewCell()
    }

    class MockProductCell: ProductCellProtocol {
        var defineWasCalled = false
        var defineWasCalledWith: (image: String, name: String, price: String)

        func define(image: String, name: String, price: String) {
            self.defineWasCalled = true
            self.defineWasCalledWith = (image: image, name: name, price: price)
        }
    }  
}