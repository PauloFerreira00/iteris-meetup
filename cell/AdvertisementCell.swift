protocol AdvertisementViewProtocol {
    var viewModel: AdvertisementViewModelProtocol
	func show(image: String)
}

protocol AdvertisementViewModelProtocol {
	func clicked(_ on: AdvertisementViewProtocol)
}

class AdvertisementCell {
    var viewModel: AdvertisementViewModelProtocol
}

extension AdvertisementCell: AdvertisementViewProtocol {
    func show(image: String) {
        image.load(url: image)
    }

    @IBAction
    func onClick() {
        viewModel.clicked(self)
    }
}