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
    var completedStep: Int?  //Used while only for the registration to check user's last step performed while registration.
    var PWNewUser: Bool? //Used to trigger event to track user is fresh or not used only for the pushwoosh. value will be present in social login api.
    var currentDesignation : String?
    var currentCompany : String?
    
    
    @available(*, deprecated)
    var overallScore = 0
    var isFromExplore = false
    
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
        about = details["userAbout"] as? String
        dob = details["userDOB"] as? String
        age = details["userAge"] as? Int ?? 0
        
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
    }
    
}
