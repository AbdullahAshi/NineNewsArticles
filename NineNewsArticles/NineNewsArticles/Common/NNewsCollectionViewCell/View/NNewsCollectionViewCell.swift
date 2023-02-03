import UIKit

protocol NNewsCollectionViewCellViewModelProtocol {
    var headLine: String { get }
    var abstract: String { get }
    var signature: String { get }
    var imageUrl: String { get }
}

class NNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "NNewsCollectionViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    var viewModel: NNewsCollectionViewCellViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else {
                assert(false, "viewModel shouldn't be nil")
                return
            }
            setupCell(title: viewModel.headLine, price: viewModel.abstract, signature: viewModel.signature, imageUrl: viewModel.imageUrl)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Thread.executeOnMain {
            self.posterImageView.image = nil
            self.headLineLabel.text = nil
            self.abstractLabel.text = nil
            self.signatureLabel.text = nil
        }
    }
    
    private func setupCell(title: String, price: String, signature: String, imageUrl: String) {
        Thread.executeOnMain {
            self.posterImageView.image(for: imageUrl)
            self.headLineLabel.text = title
            self.abstractLabel.text = price
            self.signatureLabel.text = signature == "" ? "unknown" : signature
        }
    }
    
}

