//
//  ProfileView.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    
    func swipingRight(_ alpha: CGFloat, distance: CGFloat)
    
    func swipingLeft(_ alpha: CGFloat, distance: CGFloat)
    
    func stopSwiping()
    
    func didEndRightSwipe(_ userObject: UserObject)
    
    func didEndSwipe(onView view: ProfileView)
    
    func hasStartedScrolling(isScrollingUp: Bool)
    
}

fileprivate enum ProfileCells: Int {
    case HeaderCell = 0
    case ObjectiveCell
    case AboutMeCell
    case IndustryExperienceCell
    case ProfessionalFortesCell
    case SkillHeaderCell
    case SkillSubHeaderCell
    case SkillCell
    case ProfessionalCatalogueCell
    case WorkExperienceCell
    case EducationCell
    case AcheivementCell
    case ReportCell
}

typealias SkillIndex = (Int, Int, Int)

class ProfileView: UIView {
    
    @IBOutlet var profileView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    fileprivate var userImage: UIImageView!
    fileprivate var shareButton: UIButton!
    fileprivate var addToPinBox: UIButton!
    fileprivate var isScrollingUp = false
    fileprivate var isScrollingDown = false
    fileprivate var subHeaderIndexes = [Int]()
    fileprivate var skillIndexes = [SkillIndex]() //  [Int:[Int]]()
    fileprivate var rows = [ProfileCells]()
    
    internal var shouldAnimateMatchingObjectiveTickImage = false // Tutorial purpose
    
    internal var delegate: ProfileViewDelegate?
    internal var userObject: UserObject! {
        didSet {
            self.setupTableView()
        }
    }
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var panGestureTranslation: CGPoint = .zero
    private var alphaBaseValue: CGFloat = UIScreen.main.bounds.width / 4
    
    var divisor : CGFloat!
    var top : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)
        addSubview(profileView)
        profileView.frame = self.bounds
        profileView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ProfileView.panGestureRecognized(_:)))
        self.panGestureRecognizer = panGestureRecognizer
        profileView.addGestureRecognizer(panGestureRecognizer)
        
        divisor = (self.bounds.height / 2) / 0.61
    }
    
    deinit {
        print("Deinit called on ProfileView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
    }
    
    private func reset() {
        self.delegate?.stopSwiping()
        UIView.animate(withDuration: 0.4) {
            self.transform = CGAffineTransform.identity
            self.frame = CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width,
                                height: self.superview!.bounds.height - 5.0)
            self.alpha = 1
        }
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        let xFromCenter = self.center.x - self.superview!.center.x
        self.center = CGPoint(x: self.superview!.center.x + point.x, y: self.center.y)
        
        self.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 { // Right
            self.delegate?.swipingRight(abs(xFromCenter) / self.superview!.center.x, distance: xFromCenter)
        } else {
            self.delegate?.swipingLeft(abs(xFromCenter) / self.superview!.center.x, distance: -xFromCenter)
        }
        
        switch sender.state {
        case .ended:
            if self.center.x < 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4) {
                    self.center = CGPoint(x: self.center.x - UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }
            } else if self.center.x > self.superview!.frame.width - 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.center = CGPoint(x: self.center.x + UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }) { (true) in
                    self.delegate?.didEndRightSwipe(self.userObject)
                    
                }
            } else {
                reset()
            }
        default:
            break
        }
    }
    
}

extension ProfileView: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func setupTableView() {
        rows.append(.HeaderCell)
        profileTableView.register(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderTableViewCell")

        rows.append(.ObjectiveCell)
        profileTableView.register(UINib(nibName: "ProfileObjectivesTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileObjectivesTableViewCell")

        if userObject.aboutMeCellHeight > 0 {
            rows.append(.AboutMeCell)
            profileTableView.register(UINib(nibName: "ProfileAboutMeTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileAboutMeTableViewCell")
        }

        rows.append(.IndustryExperienceCell)
        profileTableView.register(UINib(nibName: "ProfileIndustryExpTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileIndustryExpTableViewCell")

        if userObject.skillCategories.count > 0 {
            rows.append(.SkillHeaderCell)
            for skillCategory in userObject.skillCategories {
                rows.append(.SkillSubHeaderCell)
                subHeaderIndexes.append(rows.count - 1)

                var indexInSkillCategory = 0
                for _ in skillCategory.skills {
                    rows.append(.SkillCell)
                    skillIndexes.append((subHeaderIndexes.count - 1, indexInSkillCategory, rows.count - 1))
                    indexInSkillCategory += 1
                }
            }

            profileTableView.register(UINib(nibName: "ProfileSkillsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSkillsHeaderTableViewCell")
            profileTableView.register(UINib(nibName: "ProfileSkillsSubHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSkillsSubHeaderTableViewCell")
            profileTableView.register(UINib(nibName: "ProfileSkillTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSkillTableViewCell")
        }

        if userObject.profileLinks.count > 0 {
            rows.append(.ProfessionalCatalogueCell)
            profileTableView.register(UINib(nibName: "ProfileLinksTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileLinksTableViewCell")
        }

        if userObject.workExpCellHeight > 0 {
            rows.append(.WorkExperienceCell)
            profileTableView.register(UINib(nibName: "ProfileWorkExpTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileWorkExpTableViewCell")
        }

        if userObject.educationDetailsCellHeight > 0 {
            rows.append(.EducationCell)
            profileTableView.register(UINib(nibName: "ProfileEducationDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEducationDetailsTableViewCell")
        }

        if userObject.achievementsCellHeight > 0 {
            rows.append(.AcheivementCell)
            profileTableView.register(UINib(nibName: "ProfileAchievementsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileAchievementsTableViewCell")
        }
        
        rows.append(.ReportCell)
        profileTableView.register(UINib(nibName: "ProfileReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileReportTableViewCell")
        
        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch rows[indexPath.row] {
        case .HeaderCell:
            return userObject.headerCellHeight
        case .ObjectiveCell:
            return userObject.objectivesCellHeight
        case .AboutMeCell:
            return userObject.aboutMeCellHeight
        case .IndustryExperienceCell:
            return userObject.industryExpCellHeight
        case .SkillHeaderCell:
            return userObject.skillHeaderCellHeight
        case .SkillSubHeaderCell:
            return userObject.skillSubHeaderCellHeight
        case .SkillCell:
            let index = skillIndexes.firstIndex(where: { (header, skill, row) -> Bool in
                return indexPath.row == row
            })
            if let ind = index {
                let value = skillIndexes[ind]
                let skillCategory = userObject.skillCategories[value.0]
                let skill = skillCategory.skills[value.1]
                return skill.isSelected ? skill.selectedHeight : skill.height
            } else {
                return 0
            }
        case .ProfessionalCatalogueCell:
            return userObject.profileLinksCellHeight
        case .WorkExperienceCell:
            return userObject.workExpCellHeight
        case .EducationCell:
            return userObject.educationDetailsCellHeight
        case .AcheivementCell:
            return userObject.achievementsCellHeight
        case .ReportCell:
            return userObject.reportCellHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .HeaderCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .ObjectiveCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileObjectivesTableViewCell") as! ProfileObjectivesTableViewCell
            cell.configure(withUser: userObject)
            
            if shouldAnimateMatchingObjectiveTickImage, let tickImage = cell.viewWithTag(100) as? UIImageView {
                shouldAnimateMatchingObjectiveTickImage = false
                UIView.animate(withDuration: 0.5, delay: 0, options: .autoreverse, animations: {
                    tickImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (true) in
                    tickImage.transform = CGAffineTransform.identity
                }
            }
            
            return cell
        case .AboutMeCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAboutMeTableViewCell") as! ProfileAboutMeTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .IndustryExperienceCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileIndustryExpTableViewCell") as! ProfileIndustryExpTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .SkillHeaderCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSkillsHeaderTableViewCell") as! ProfileSkillsHeaderTableViewCell
            cell.configure()
            
            return cell
        case .SkillSubHeaderCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSkillsSubHeaderTableViewCell") as! ProfileSkillsSubHeaderTableViewCell
            let index = subHeaderIndexes.firstIndex { (ind) -> Bool in
                return ind == indexPath.row
            }
            
            if index != nil {
                cell.configure(category: userObject.skillCategories[index!])
            }
            
            return cell
        case .SkillCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSkillTableViewCell") as! ProfileSkillTableViewCell
            let index = skillIndexes.firstIndex(where: { (header, skill, row) -> Bool in
                return indexPath.row == row
            })
            if let ind = index {
                let value = skillIndexes[ind]
                let skillCategory = userObject.skillCategories[value.0]
                let skill = skillCategory.skills[value.1]
                cell.configure(withSkill: skill, index: value, isLineHiddden: value.1 == skillCategory.skills.count - 1)
            }
            
            return cell
        case .ProfessionalCatalogueCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLinksTableViewCell") as! ProfileLinksTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .WorkExperienceCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileWorkExpTableViewCell") as! ProfileWorkExpTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .EducationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEducationDetailsTableViewCell") as! ProfileEducationDetailsTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case .AcheivementCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAchievementsTableViewCell") as! ProfileAchievementsTableViewCell
            cell.configure(withUser: userObject)
                
            return cell
        case .ReportCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileReportTableViewCell") as! ProfileReportTableViewCell
            
            return cell
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
                cell!.backgroundColor = UIColor.lightGray
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let skillCell = tableView.cellForRow(at: indexPath) as? ProfileSkillTableViewCell {
            let categoryIndex = skillCell.skillIndex.0
            let category = userObject.skillCategories[categoryIndex]
            let skill = category.skills[skillCell.skillIndex.1]
            
            if skill.endorsement! > 0 {
                skill.isSelected = !skill.isSelected
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

extension ProfileView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: self)
        if isScrollingUp == false, velocity.y < 0 { //up
            isScrollingUp = true
            isScrollingDown = false
            self.delegate?.hasStartedScrolling(isScrollingUp: true)
        } else if isScrollingDown == false, velocity.y > 0 { //down
            isScrollingDown = true
            isScrollingUp = false
            self.delegate?.hasStartedScrolling(isScrollingUp: false)
        }
    }
    
}


extension UIView {
    
    internal func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = false
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath

        self.layer.mask = mask
    }
    
}

