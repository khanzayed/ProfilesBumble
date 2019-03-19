//
//  UserDataModel.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import Foundation
import UIKit

class UserObject {
    
    var id: Int?
    var email: String?
    var btPin: String?
    var phoneNumber: String?
    
    var about: String?
    var aboutMeAttributedString: NSAttributedString?
    
    var gender: String?
    var age: Int?
    var dob: String?
    var fName: String?
    var lName: String?
    var fullName: String?
    var smallImageUrl: String = ""
    var largeImageUrl: String = ""
    var shareUrl: String?
    var authorizationKey: String?
    var isVerify: Bool?
    var isProfile: Bool?
    var isSliced = false
    var isMobileVerify: Bool?
    var thumbnailImage : UIImage?
    var completedStep: Int?  // Used while only for the registration to check user's last step performed while registration.
    var PWNewUser: Bool? // Used to trigger event to track user is fresh or not used only for the pushwoosh. value will be present in social login api.
    var currentDesignation : String?
    var currentCompany : String?
    
    @available(*, deprecated)
    var overallScore = 0
    var isFromExplore = false
    
    let headerCellHeight: CGFloat = 360
    
    var completeObjectives = [ObjectiveModel]()
    var objectivesCellHeight: CGFloat = 90.0
    
    var aboutMeCellHeight: CGFloat = 0
    
    var industries = [IndustryModel]()
    var industryExpCellHeight: CGFloat = 170
    
    var skillCategories = [SkillsCategoryModel]()
    var skillHeaderCellHeight: CGFloat = 60
    var skillSubHeaderCellHeight: CGFloat = 40
    
    var profileLinks = [ProfileLinkModel]()
    var profileLinksCellHeight: CGFloat = 160
    
    var workDetails = [WorkDetailsModel]()
    var workExpCellHeight: CGFloat = 0
    
    var eduDetails = [EducationDetailsModel]()
    var educationDetailsCellHeight: CGFloat = 0
    
    var achievements = [AchievementsModel]()
    var achievementsCellHeight: CGFloat = 0
    
    let reportCellHeight: CGFloat = 100
    
    init(details: [String: Any], fromExplore: Bool = false) {
        
        isFromExplore = fromExplore
        
        id = details["userID"] as? Int ?? 0
        
        if let key = details["authorizationKey"] as? String, !key.isEmpty {
            authorizationKey = key
        }
        PWNewUser = details["PWNewUser"] as? Bool
        email = details["userEmail"] as? String
        btPin = details["blueTiePin"] as? String
        shareUrl = details["shareURL"] as? String
        phoneNumber = details["userMobile"] as? String
        completedStep = details["completedStep"] as? Int ?? -1
        isVerify = (details["isVerify"] as? Int == 1)
        isProfile = (details["isProfile"] as? Int == 1)
        isMobileVerify = (details["isMobileVerified"] as? Int == 1)
        isSliced = (details["isSliced"] as? Int == 1)
        dob = details["userDOB"] as? String
        age = details["userAge"] as? Int ?? 0
        
        if let aboutMe = details["userAbout"] as? String {
            about = aboutMe
            aboutMeAttributedString = aboutMe.getAttributedString(withLineSpacing: 10.0, style: .left, font: UIFont.ProximaNovaSemiBold(fontSize: 24.0))
            aboutMeCellHeight = 185 + aboutMeAttributedString!.height(containerWidth: UIScreen.main.bounds.width - 60) + 100
        } else {
            about = ""
            aboutMeCellHeight = 0
        }
        
        if let value = details["userGender"] as? String, value.count > 0 {
            gender = value
        }
        
        var fullName = ""
        if let firstName = details["userFirstName"] as? String, firstName.count > 0 {
            fName = firstName
            if let lastName = details["userLastName"] as? String, lastName.count > 0 {
                lName = lastName
                
                fullName = "\(firstName) \(lastName)"
            } else {
                fullName = firstName
            }
            self.fullName = fullName
        }
        
        smallImageUrl = details["thumbnailImage"] as? String ?? ""
        largeImageUrl = details["userImage"] as? String ?? ""
        
        if !largeImageUrl.isEmpty, smallImageUrl.isEmpty {
            smallImageUrl = largeImageUrl
        }
        
        if let designationDetails = details["userWorkHistory"] as? [[String: Any]], designationDetails.count > 0 {
            if let designation = designationDetails[0]["userDesignation"] as? String, designation.count > 0 {
                self.currentDesignation = designation.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let company = designationDetails[0]["userCompany"] as? String, company.count > 0 {
                self.currentCompany = company.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if let allObjectives = details["objectives"] as? [[String: Any]], allObjectives.count > 0 {
            completeObjectives = allObjectives.map{ ObjectiveModel(details: $0) }
            objectivesCellHeight += CGFloat(75 * completeObjectives.count)
        }
        
        if let userIndustries = details["userIndustry"] as? [[String: Any]], userIndustries.count > 0 {
            industries = userIndustries.map{ IndustryModel(industryDetails: $0) }
            industryExpCellHeight += CGFloat(50 * userIndustries.count)
        }
        
        if let linksArray = details["userLink"] as? [[String:Any]], linksArray.count > 0 {
            profileLinks = linksArray.map{ ProfileLinkModel(details: $0) }
            profileLinksCellHeight += CGFloat(105 * profileLinks.count)
        }
        
        if let weDetails = details["userWorkHistory"] as? [[String: Any]] {
            workExpCellHeight += 110
            for work in weDetails {
                let obj = WorkDetailsModel(details: work)
                workDetails.append(obj)
                workExpCellHeight += obj.height
            }
        }
        
        if let degreeDetails = details["userDegree"] as? [[String: Any]], degreeDetails.count > 0 {
            educationDetailsCellHeight += 110
            for education in degreeDetails {
                let obj = EducationDetailsModel(details: education)
                eduDetails.append(obj)
                educationDetailsCellHeight += obj.height
            }
        }
        
        if let allAchievements = details["userAchivement"] as? [[String: Any]], allAchievements.count > 0 {
            achievements = allAchievements.map { AchievementsModel(details: $0) }
            achievementsCellHeight = 430
        }
        
        if let skillDetails = details["fortes"] as? [[String: Any]], skillDetails.count > 0 {
            skillCategories = skillDetails.map { SkillsCategoryModel(details: $0) }
        }
    }
    
    private func getAttributedString(text: String, withLineSpacing lineSpacing: CGFloat, style: NSTextAlignment, font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = style
        
        let placeAttr: [NSAttributedString.Key:Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: font]
        
        return NSAttributedString(string: text, attributes: placeAttr)
    }
    
}

struct ObjectiveModel {
    
    var id: Int?
    var name: String?
    var isSelected: Bool = false
    var priority: Int?
    var description: String?
    var isMatching: Bool = false
    
    init(details: [String: Any]) {
        if let objectiveID = details["objectiveID"] as? String {
            id = Int(objectiveID)
        }else if let objectiveID = details["objectiveID"] as? Int {
            id = objectiveID
        }
        
        if let pLevel = details["pLevel"] as? String {
            priority = Int(pLevel)
        }else if let pLevel = details["pLevel"] as? Int {
            priority = pLevel
        }
        name = details["objectiveTitle"] as? String
        isSelected = details["userID"] != nil
        description = details["description"] as? String
        isMatching = details["matched"] as? Bool == true
    }
}

struct IndustryModel {
    
    var id: Int?
    var name: String?
    var userIndustryId: Int?
    
    init(industryDetails: [String: Any]) {
        if let tmpId = industryDetails["industryID"] as? Int {
            id = tmpId
        } else {
            id = Int(industryDetails["industryID"] as? String ?? "")
        }
        name = industryDetails["industryName"] as? String ?? ""
        if let tmpId = industryDetails["userIndustryID"] as? Int {
            userIndustryId = tmpId
        } else {
            userIndustryId = Int(industryDetails["userIndustryID"] as? String ?? "")
        }
    }
}

struct ProfileLinkModel {
    var id: Int?
    var title: String?
    var link: URL?
    
    init(details: [String:Any]) {
        
        if let idString = details["userDocLinkID"] as? String {
            id = Int(idString)
        }
        if let idInt = details["userDocLinkID"] as? Int {
            id = idInt
        }
        
        title = details["title"] as? String
        
        if let urlString1 = details["linkUrl"] as? String, urlString1.count > 0 {
            if urlString1.hasPrefix("http://")
            {
                if let url = URL(string: urlString1) {
                    link = url
                }
            }
            else if urlString1.hasPrefix("https://")
            {
                if let url = URL(string: urlString1) {
                    link = url
                }
            }
            else
            {
                if let url = URL(string: "https://" + urlString1) {
                    link = url
                }
            }
        }
    }
}


struct WorkDetailsModel {
    
    var id: Int?
    var companyName: String?
    var designation: String?
    var isCurrent: Bool = false
    var fromMonth: String?
    var fromYear: String?
    var toMonth: String?
    var toYear: String?
    var isSelfEmployed: Bool = false
    var titleHeight: CGFloat = 20 // Initial - oneliner
    var height: CGFloat = 75
    
    init(details: [String: Any]) {
        if let idString = details["workID"] as? String {  //parsed in both way because php was delivering String and in Node it's Int
            id = Int(idString)!
        }else if let idInt = details["workID"] as? Int {
            id = idInt
        }
        companyName = details["userCompany"] as? String
        designation = details["userDesignation"] as? String ?? details["title"] as? String
        fromMonth = details["workFromMonth"] as? String
        fromYear = details["workFromYear"] as? String
        toMonth = details["workToMonth"] as? String
        toYear = details["workToYear"] as? String
        
        if let employment = details["isSelfEmployed"] as? Int {
            isSelfEmployed = (employment == 1)
        }
        
        if let isCurrentString = details["currentCompany"] as? String {  // parsed in both way because php was delivering String and in Node it's Int
            isCurrent = Int(isCurrentString)! > 0
        } else if let idInt = details["currentCompany"] as? Int {
            isCurrent = idInt > 0
        }
        
        if let designationHeight = designation?.height(constraintedWidth: UIScreen.main.bounds.width - 60, font: UIFont.ProximaNovaSemiBold(fontSize: 14)) {
            titleHeight = max(designationHeight, 20)
        }
        height = 30 + 55 + titleHeight
    }
}

struct EducationDetailsModel {
    
    var id: Int?
    var degreeName: String?
    var collegeName: String?
    var batchMonth: String?
    var batchYear: String?
    var titleHeight: CGFloat = 20 // Initial - oneliner
    var height: CGFloat = 75
    
    init(details: [String: Any]) {
        if let idString = details["educationID"] as? String {  //parsed in both way because php was delivering String and in Node it's Int
            id = Int(idString)!
        }else if let idInt = details["educationID"] as? Int {
            id = idInt
        }
        degreeName = details["userDegree"] as? String ?? details["title"] as? String
        collegeName = details["userUniversity"] as? String
        batchMonth = details["educationMonth"] as? String
        if let yearString = details["educationYear"] as? String {  //parsed in both way because php was delivering String and in Node it's Int
            batchYear = yearString
        }else if let yearInt = details["educationYear"] as? Int {
            batchYear = "\(yearInt)"
        }
    }
}

struct AchievementsModel {
    
    var id: Int?
    var name: String?
    
    init(details: [String: Any]) {
        
        if let idString = details["achivementID"] as? String {
            id = Int(idString)
        }else if let idInt = details["achivementID"] as? Int {
            id = idInt
        }
        name = details["achivementTitle"] as? String
    }
}


class SkillsCategoryModel {
    
    var name: String?
    var colorCode: String?
    var skills = [Skill]()
    var previousSkillsCount = 0 // Explore UI purpose
    
    init(details: [String:Any]) {
        name = details["name"] as? String ?? "Fortes"
        colorCode = details["colorCode"] as? String ?? "000000"
        name = details["name"] as? String ?? "Fortes"
        
        if let skills = details["value"] as? [[String: Any]], details.count > 0 {
            self.skills = skills.map { Skill(details: $0) }
        }
    }
    
}

class Skill {
    
    var skillId: Int?
    var industryId: Int?
    var skillName: String?
    var endorsement: Int?
    var isMainSkill: Int?
    var skillType: Int? = 0
    var height: CGFloat = 50
    var isSelected = false
    var selectedHeight: CGFloat = 50
    
    init(details: [String: Any]) {
        if let id = details["subSkillID"] as? String {
            skillId = Int(id)
        } else if let id = details["subSkillID"] as? Int {
            skillId = id
        }
        endorsement = details["endorsement"] as? Int ?? 0
        skillName = details["skillSets"] as? String ?? ""
        
        if let type = details["type"] as? Int {
            skillType = type
        }
        
        height = skillName!.height(constraintedWidth: UIScreen.main.bounds.width - 80, font: UIFont.ProximaNovaSemiBold(fontSize: 14)) + 30
        selectedHeight = height + 30
    }
    
}
