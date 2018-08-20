//
//  Globals.swift
//  DemoVogueAPI
//
//  Created by Bharat Byan on 11/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import Foundation

let internetReachability = Reachability()!  //creating global reachibilty object

let URL_Common = "https://dl.dropboxusercontent.com/"   // main url for network requests

let Action_URL = "s/laqqaoyh5wa51m1/"   // action substring for newtork requests
let Action_Name = "vogueData.json"  // action name or file name for requets

// global variables for switching the custom schemes 
#if DEBUGX
let SERVER_URL = "http://dev.server.com/api/"
let API_TOKEN = "DI2023409jf90ew"

#else
let SERVER_URL = "http://prod.server.com/api/"
let API_TOKEN = "71a629j0f090232"
#endif
