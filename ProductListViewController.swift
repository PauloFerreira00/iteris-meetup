class ProductListViewController: UIViewController {
    var view: ProductListViewProtocol!
    var viewModel: ProductListViewProtocol! {
        didSet {
            view.set(viewModel: viewModel)
        }
    }

    override func loadView() {
        self.view = view.to()
    }

    func viewWillAppear() {
        viewModel.fetchListOfProducts()
    }

    static func create() -> ProductListViewController {
        let view = UIDevice.isIphone ? ProductListView4Iphone(frame: .zero) : ProductListView4Ipad(frame: .zero)
        let repository = Repository(worker: ApiWorker.shared)
        let generator = TableViewGenerator.shared

        let viewModel = ProductListViewModel()
        viewModel.set(repository: repository)
        viewModel.set(generator: generator)

        let vc = ProductListViewController()
        vc.view = view
        vc.viewModel = viewModel
    }
}