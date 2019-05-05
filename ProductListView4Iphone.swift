protocol ProductListViewProtocol {
    func show(title: String, detail: String)
    func reloadTable()

    func showLoading()
    func hideLoading()
    func error(message: String)

    func to() -> UIView
}

class ProductListView4Iphone: UIView {
    var viewModel: ProductListViewModelProtocol
    // ui view controls outlets
}

extension ProductListView4Iphone: ProductListViewProtocol {
    func show(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailText.text = detail
    }

    func reloadTable() {
        self.tableView.reloadTable()
    }

    func showLoading() {
        self.loadingView.isHidden = false
    }
    
    func hideLoading() {
        self.loadingView.isHidden = true
    }

    func error(message: String) {
        Alert.create(message: message).show()
    }
    
    func to() -> UIView {
        return self
    }
}

extension ProductListView4Iphone: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.create(indexPath.item)
    }
}