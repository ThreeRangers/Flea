//
//  ParseError.swift
//  Flea
//
//  Created by Dat Nguyen on 23/12/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class ParseError: NSObject {
    static var ErrorDictionary: [Int:String] = [
        1: "We're sorry, but our data provider had a server error. Please try again now and/or later.", //internal server error
        200: "Please provide a username.", //username missing.
        201: "Please provide a password.", //password missing
        99999: "There was an unknown error processing your request to Parse. Please try again. You can also contact us and mention your error code.",
        101: "Username and password do not match",
        202: "This email already taken",
        203: "This email already taken",
        100: "Connection not available"
    ]
}
