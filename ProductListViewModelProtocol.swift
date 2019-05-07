protocol ProductListViewModelProtocol {
    func set(view: ProductListViewProtocol)
    func set(repository: RepositoryProtocol)
    func set(generator: TableViewCellGeneratorProtocol)

    func fetchListOfProducts()

    func numberOfRows() -> Int
    func create(index: Int) -> UITableViewCell
}

class ProductListViewModel {
    var view: ProductListViewProtocol?
    var repository: RepositoryProtocol?
    var generator: TableViewCellGenerator?
    var safari: SafariHelperProtocol?

    var itens: [Itens] = []
    var rows: [UITableViewCell] = []
}

extension ProductListViewModel: ProductListViewModelProtocol {
    func set(view: ProductListViewProtocol) {
        self.view = view
    }

    func set(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func set(generator: TableViewCellGeneratorProtocol) {
        self.generator = generator
    }

    func fetchListOfProducts() {
        view?.showLoading()

        repository.list
            (success: { (itens) in 
                self.itens = itens
                self.rows = generate()

                view?.reloadTable()
                view?.hideLoading()
            }, 
            error: { (error) in 
                view?.hideLoading()
                view?.error(message: "Deu ruim")
            })
    }

    func numberOfRows() -> Int { 
        return rows.count 
    }

    func create(index: Int) -> UITableViewCell {
        return rows[index]
    }

    func generate() -> [UITableViewCell] {
        return itens.map { item in 
            if let item = item as? Product {
                return generator.create(ProductCell.self) { (cell: ProductCellProtocol) in 
                    cell.define(image: item.image, name: item.name, description: item.description)
                }
            }

            if let item = item as? Advertisement {
                return generator.create(AdvertisementCell.self) { (cell: AdvertisementViewProtocol) in 
                    cell.viewModel = self
                    cell.show(data: UIImage(url: item.imageURL))
                }
            }

            if let item = item as? Feedback {
                return generator.create(FeedbackCell.self) { (cell: FeedbackViewProtocol) in 
                    cell.viewModel = self
                    cell.show(data: UIImage(url: item.imageURL))
                }
            }

            return UITableViewCell()
        }
    }
}

extension ProductListViewModel: AdvertisementViewModelProtocol {
    func clicked(_ on: AdvertisementViewProtocol)
        if let ads = itens.first { $0 is Advertisement } {
            safari?.open(url: ads.redirectURL)
        }
    }
}

extension ProductListViewModel: FeedbackFormViewModelProtocol {
    func done(_ on: FeedbackFormViewModelProtocol, selectedOptionIndex: Int) {
        if let ads = itens.first { $0 is Advertisement } {
            repository.registerFeedback(ads.identifier, ads.options[selectedOptionIndex])
        }
    }
}