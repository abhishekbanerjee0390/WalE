//
//  ViewController.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 05/04/22.
//

import UIKit
import Network

class ViewController: UIViewController {

    let networkMonitor: WALENetworkMonitorProtocol = WALENetworkMonitor()
    override func viewDidLoad() {
        super.viewDidLoad()
//        networkMonitor = WALENetworkMonitor()
        // Do any additional setup after loading the view.
        
        networkMonitor.startMonitoringNetwork { (isConnected: Bool) in
            
        }
    }

    //https://api.nasa.gov/planetary/apod?api_key=K70cd0Wlb9zbPA2jkolcYzNqEblg6H3gYGEY7zHE&date=2022-04-05

}

/*
 {
   "copyright": "Neven Krcmarek",
   "date": "2022-04-05",
   "explanation": "On the upper right, dressed in blue, is the Pleiades.  Also known as the Seven Sisters and M45, the Pleiades is one of the brightest and most easily visible open clusters on the sky. The Pleiades contains over 3,000 stars, is about 400 light years away, and only 13 light years across. Surrounding the stars is a spectacular blue reflection nebula made of fine dust.  A common legend is that one of the brighter stars faded since the cluster was named. On the lower left, shining in red, is the California Nebula.  Named for its shape, the California Nebula is much dimmer and hence harder to see than the Pleiades.  Also known as NGC 1499, this mass of red glowing hydrogen gas is about 1,500 light years away. Although about 25 full moons could fit between them, the featured wide angle, deep field image composite has captured them both.  A careful inspection of the deep image will also reveal the star forming region IC 348 and the molecular cloud LBN 777 (the Baby Eagle Nebula).",
   "hdurl": "https://apod.nasa.gov/apod/image/2204/Calif2Pleiades_Krcmarek_10000.jpg",
   "media_type": "image",
   "service_version": "v1",
   "title": "Seven Sisters versus California",
   "url": "https://apod.nasa.gov/apod/image/2204/Calif2Pleiades_Krcmarek_1080.jpg"
 }
 */

/*
 Acceptance Criteria
 1. Given: The NASA APOD API is up (working) AND the phone is connected to the internet When:
 The user arrives at the APOD page for the first time today Then: The page should display the
 image of Astronomy Picture of the Day along with the title and explanation, for that day
 2. Given: The user has already seen the APOD page once AND the phone is not connected to
 the internet When: The user arrives at the APOD page on the same day Then: The page
 should display the image of Astronomy Picture of the Day along with the title and explanation,
 for that day
 3. Given: The user has not seen the APOD page today AND the phone is not connected to the
 internet When: The user arrives at the APOD page Then: The page should display an error
 "We are not connected to the internet, showing you the last image we have." AND The page
 should display the image of Astronomy Picture of the Day along with the title and explanation,
 that was last seen by the user
 4. Given: The NASA APOD API is up (working) AND the phone is connected to the internet When:
 The APOD image loads fully on the screen Then: The user should be able to see the complete
 image without distortion or clipping
 */

//https://www.raywenderlich.com/8549-self-sizing-table-view-cells
