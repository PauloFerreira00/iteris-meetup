protocol ProductCellViewProtocol {
    func define(image: String, name: String, price: String)
}

class ProductCell: ProductCellViewProtocol {
    func define(image: String, name: String, price: String) {
        self.imageView.load(url: image)
        self.name.text = name
        self.price.text = price
    }
}