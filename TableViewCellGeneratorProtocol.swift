protocol TableViewCellGeneratorProtocol {
    func create<T: UITableViewCell, K>(type: T.Type, _ builder: @escaping (K) -> Void) -> UITableViewCell
}

class TableViewCellGenerator: TableViewCellGeneratorProtocol {
    func create<T: UITableViewCell, K>(type: T.Type, _ builder: @escaping (K) -> Void) -> UITableViewCell {
        let cell = type.instantiateFromNib()

        if let cell = cell as? K {
            builder(cell)
        }

        return cell
    }
}