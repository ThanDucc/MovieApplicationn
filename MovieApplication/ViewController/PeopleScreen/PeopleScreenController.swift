//
//  PeopleScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit
import UPCarouselFlowLayout

class PeopleScreenController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchPeople: UITextField!
    @IBOutlet weak var clPeopleAvatar: UICollectionView!
    @IBOutlet weak var clPeopleNameTag: UICollectionView!
    @IBOutlet weak var clPeopleImage: UICollectionView!
    @IBOutlet weak var heightConstraintClPeopleImage: NSLayoutConstraint!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var lbDepartment: UILabel!
    @IBOutlet weak var lbPlaceOfBirth: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    var people: People?
    var detailPeople: Detail?
    var peopleImages: PeopleImages?
    var index = -1
    var reload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchPeople.attributedPlaceholder = NSAttributedString(string: "Search people", attributes: attributes)
        
        let PeopleNib = UINib(nibName: "PeopleCell", bundle: nil)
        clPeopleAvatar.register(PeopleNib, forCellWithReuseIdentifier: "PeopleCell")
        
        let PeopleNameTagNib = UINib(nibName: "PeopleNameTagCell", bundle: nil)
        clPeopleNameTag.register(PeopleNameTagNib, forCellWithReuseIdentifier: "PeopleNameTagCell")
        
        let PeopleImageNib = UINib(nibName: "PeopleImageCell", bundle: nil)
        clPeopleImage.register(PeopleImageNib, forCellWithReuseIdentifier: "PeopleImageCell")
        setupFlowLayoutForClPeopleImage()
        
        imgAccount.image = UIImage(named: "person_fill")?.withTintColor(.label)
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
        detailView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        imgAccount.isUserInteractionEnabled = true
        
        getDataPeople()
        
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "AccountSettingView", bundle: nil)
        let accSettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingView") as! AccountSettingView
        accSettingVC.modalPresentationStyle = .overFullScreen
        accSettingVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(accSettingVC, animated: true)
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    private func getDataPeople() {
        if let urlPeople = URL(string: Constant.urlPeople +  "popular" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPeople) { data, response, error in
              if let jsonData = data {
                  let people = try? JSONDecoder().decode(People.self, from: jsonData)
                  self.updatePeopleCollection(people: people!)
               }
           }.resume()
        }
    }
    
    private func updatePeopleCollection(people: People) {
        DispatchQueue.main.async {
            self.people = people
            self.clPeopleAvatar.delegate = self
            self.clPeopleAvatar.dataSource = self
            self.clPeopleAvatar.reloadData()
        }
    }
    
    private func getDetailPeople(id: Int) {
        if let urlDetail = URL(string: Constant.urlPeople + String(describing: id) + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlDetail) { data, response, error in
              if let jsonData = data {
                  let detail = try? JSONDecoder().decode(Detail.self, from: jsonData)
                  self.updateDetailPeople(detail: detail!)
               }
           }.resume()
        }
    }
    
    private func updateDetailPeople(detail: Detail) {
        DispatchQueue.main.async {
            self.detailPeople = detail
            self.lbBirthday.attributedText = self.attributeText(title: "Birthday: ", text: detail.birthday ?? "No information")
            self.lbDepartment.attributedText = self.attributeText(title: "Department: ", text: detail.knownForDepartment ?? "No information")
            self.lbPlaceOfBirth.attributedText = self.attributeText(title: "Place of birth: ", text: detail.placeOfBirth ?? "No information")
            self.lbDescription.attributedText = self.attributeText(title: "", text: detail.biography ?? "No information")
            
            self.reload = false
            
            self.clPeopleNameTag.delegate = self
            self.clPeopleNameTag.dataSource = self
            self.clPeopleNameTag.reloadData()
        }
    }
    
    private func getImagesPeople(id: Int) {
        if let urlDetail = URL(string: Constant.urlPeople + String(describing: id) + "/images" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlDetail) { data, response, error in
              if let jsonData = data {
                  let peopleImages = try? JSONDecoder().decode(PeopleImages.self, from: jsonData)
                  self.updateImagesPeople(imageList: peopleImages!)
               }
           }.resume()
        }
    }
    
    private func updateImagesPeople(imageList: PeopleImages) {
        DispatchQueue.main.async {
            self.peopleImages = imageList
            self.reload = false
            
            self.clPeopleImage.delegate = self
            self.clPeopleImage.dataSource = self
            self.clPeopleImage.reloadData()
        }
    }

}

extension PeopleScreenController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clPeopleAvatar:
            return people?.results.count ?? 0
        case clPeopleNameTag:
            if reload {
                return 0
            } else {
                return detailPeople?.alsoKnownAs?.count ?? 0
            }
        case clPeopleImage:
            if reload {
                return 0
            } else {
                return peopleImages?.profiles.count ?? 0
            }
        default:
            return 0
        }
    }
    
    @objc func btnShowDetail(_ sender: UIButton) {
        print("Show")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case clPeopleAvatar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
            let profilePath = people?.results[indexPath.row].profilePath ?? ""
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + profilePath)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgPeopleAvatar.image = image
                    }
                }
            }.resume()
            cell.lbPersonName.text = people?.results[indexPath.row].name
            cell.btnPeopleState.setBackgroundImage(UIImage(named: "add")?.withTintColor(.label), for: .normal)
            return cell
        case clPeopleNameTag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleNameTagCell", for: indexPath) as! PeopleNameTagCell
            cell.lbNameTag.text = detailPeople?.alsoKnownAs?[indexPath.row] ?? ""
            return cell
        case clPeopleImage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleImageCell", for: indexPath) as! PeopleImageCell
            let imageUrl = peopleImages?.profiles[indexPath.row].filePath ?? ""
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + imageUrl)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgPeople.image = image
                    }
                }
            }.resume()
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case clPeopleAvatar:
            return CGSize(width: 86, height: 93)
        case clPeopleNameTag:
            return CGSize(width: 62, height: 30)
        default:
            heightConstraintClPeopleImage.constant = Constant.heightConstraintCollectionPeopleImage
            return CGSize(width: UIScreen.main.bounds.width/1.2, height: Constant.heightConstraintCollectionPeopleImage - 0.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clPeopleAvatar:
            return -16
        case clPeopleNameTag:
            return -24
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clPeopleNameTag:
            return -24
        default:
            return 0
        }
    }
    
    func setupFlowLayoutForClPeopleImage() {
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/1.2, height: clPeopleImage.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 0.25
        flowLayout.spacingMode = .fixed(spacing: 400)
        clPeopleImage.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case clPeopleAvatar:
            let newCell = collectionView.cellForItem(at: indexPath) as! PeopleCell
            newCell.btnPeopleState.setBackgroundImage(UIImage(named: "done")?.withTintColor(.label), for: .normal)
            
            if index >= 0 && index != indexPath.row {
                let oldIndex = IndexPath(item: self.index, section: 0)
                if collectionView.indexPathsForVisibleItems.contains(oldIndex) {
                    let oldCell = collectionView.cellForItem(at: IndexPath(item: self.index, section: 0)) as! PeopleCell
                    oldCell.btnPeopleState.setBackgroundImage(UIImage(named: "add")?.withTintColor(.label), for: .normal)
                } else {
                    collectionView.reloadItems(at: [IndexPath(item: self.index, section: 0)])
                }
            }

            if self.index != indexPath.row {
                self.index = indexPath.row
                
                self.detailView.isHidden = false
                self.lbName.text = "About " + (people?.results[indexPath.row].name)!
                
                reload = true
                self.clPeopleImage.reloadData()
                self.clPeopleNameTag.reloadData()
                
                getImagesPeople(id: (people?.results[indexPath.row].id)!)
                getDetailPeople(id: (people?.results[indexPath.row].id)!)
            }
        default:
            break
        }
    }
    
    private func attributeText(title: String, text: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: (title + text))

        let attributeBold = ((title + text) as NSString).range(of: title)
        let bold: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
        ]
        attributedText.addAttributes(bold, range: attributeBold)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        return attributedText
    }
}
