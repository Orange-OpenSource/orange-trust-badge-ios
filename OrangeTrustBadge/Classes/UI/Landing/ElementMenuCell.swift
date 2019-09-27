/*
*
* OrangeTrustBadge
*
* File name:   ElementMenuCell.swift
* Created:     15/12/2015
* Created by:  Romain BIARD
*
* Copyright 2015 Orange
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class ElementMenuCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    
    static let reuseIdentifier = "ElementMenu"
    static let maxDisplayedElement = 4
    
    var representedObject : [TrustBadgeElement]?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var overview: UICollectionView!
    @IBOutlet var customDisclosureIndicator: UIImageView!
    @IBOutlet var contentHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.accessibilityTraits = UIAccessibilityTraits.button
        self.shouldGroupAccessibilityChildren = false
    }
    
    // MARK: - Collection View data source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let objects = representedObject else {
            return UICollectionViewCell()
        }
        let elements = objects.sorted { (e1, e2) -> Bool in
            return e1.statusClosure() == true && e2.statusClosure() == false
        }
        
        let element = elements[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ElementOverViewCell.reuseIdentifier, for: indexPath) as! ElementOverViewCell
        
        let statusKey: String = {
            if element.statusClosure() {
                return "status-enabled"
            } else {
                return "status-disabled"
            }
        }()
        
        if indexPath.row < ElementMenuCell.maxDisplayedElement {
            cell.status.text = TrustBadge.shared.localizedString(statusKey)
            cell.status.textColor = element.statusClosure() ? TrustBadge.shared.config?.highlightColor : .defaultTextColor
            let status = element.statusClosure() ? TrustBadge.shared.localizedString("accessibility-enabled") :  TrustBadge.shared.localizedString("accessibility-disabled")
            cell.accessibilityValue = "\(TrustBadge.shared.localizedString(element.nameKey)) : \(status)"
            cell.icon.image = element.statusClosure() ? TrustBadge.shared.loadImage(element.statusEnabledIconName) : TrustBadge.shared.loadImage(element.statusDisabledIconName)
            cell.accessibilityHint = TrustBadge.shared.localizedString("accessibility-double-tap")
        } else {
            cell.icon.image = TrustBadge.shared.loadImage("more-dots")
            cell.status.text = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let elements = representedObject else{
            return 0
        }
        return min(ElementMenuCell.maxDisplayedElement + 1, elements.count)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

