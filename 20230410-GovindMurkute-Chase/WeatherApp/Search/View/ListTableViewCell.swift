//
//  ListTableViewCell.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    var location: GeoLocationModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        title.textColor = .darkText
        subtitle.textColor = .darkGray
    }

    func configureLoadingCell() {
        self.title.text = "Loading City.."
        self.subtitle.text = "Loading Country.."
        self.location = nil
    }
    
    func configureCell(for location: GeoLocationModel) {
        self.location = location
        setTexts()
    }

    private func setTexts() {
        title.text = location?.name
        let state = location?.state ?? ""
        let country = location?.country ?? ""
        subtitle.text = state
        if state.isEmpty {
            title.text = country
        } else {
            subtitle.text = state + ", " + country
        }
    }
}
