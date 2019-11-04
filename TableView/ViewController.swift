//
//  ViewController.swift
//  TableView
//
//  Created by Khutjo MAPUTLA on 2019/10/24.
//  Copyright © 2019 Khutjo MAPUTLA. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{

    @IBOutlet var tableview: UITableView!
    
    var names: [ProjectData] = []
    
    @IBAction func press(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_login-a4e0666f73c02f025f590b474b394fd86e1cae20e95261a6e4862c2d0faa1b04")!)
        if (Dataridge.myobj.getisProfileset() == false){dismiss(animated: true, completion: nil)}
        names = getnames()
        // Do any additional setup after loading the view.
    }

    func getnames() -> [ProjectData]{
        let data = Dataridge.myobj.getProfiledat() as! NSArray

            /*   "current_team_id" = 2842022;
            "cursus_ids" =     (
                8
            );
            "final_mark" = 0;*******
            id = 1586542;
            marked = 1;
            "marked_at" = "2019-10-15T16:43:09.253Z";
            occurrence = 0;
            project =     {
                id = 747;
                name = "Day 03";
                "parent_id" = 742;
                slug = "piscine-swift-ios-day-03";****
            };
            status = finished;*******
            "validated?" = 0;******/
//            print(data[0])
        var projects: [ProjectData] = []
        for (tempObject) in data{
            let hold = (tempObject as AnyObject)["project"]
            let holdthis = (hold as AnyObject)["slug"]
            print(holdthis!! as! String)
            print((tempObject as AnyObject)["final_mark"] as? Int ?? 0)
            print((tempObject as AnyObject)["status"] as? String ?? "")
            print((tempObject as AnyObject)["validated?"] as? Int ?? 0)
            print("TSHEE")
            projects.append( ProjectData(ProjectName: holdthis as! String, ProjectMarks: ((tempObject as AnyObject)["final_mark"] as? Int ?? 0)
, Projectstatus: (tempObject as AnyObject)["status"] as? String ?? "", Projectvalidation: ((tempObject as AnyObject)["validated?"] as? Int ?? 0)))
        }

        if (Dataridge.myobj.getIsTokenSet()){
        print("1I GOT IT!!!!!!!!! " + Dataridge.myobj.getToken())
        }
//        let name1 = ProjectData(ProjectName: Dataridge.myobj.getToken(), ProjectMarks: "is", Projectstatus: "thing", Projectvalidation: "1")
//        let name2 = ProjectData(ProjectName: Dataridge.myobj.getToken(), ProjectMarks: "is", Projectstatus: "thing", Projectvalidation: "2")
//        let name3 = ProjectData(ProjectName: Dataridge.myobj.getToken(), ProjectMarks: "is", Projectstatus: "thing", Projectvalidation: "3")
//        let name4 = ProjectData(ProjectName: Dataridge.myobj.getToken(), ProjectMarks: "is", Projectstatus: "thing", Projectvalidation: "4")
        return (projects)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myname = names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Project") as! ProjectCells
        cell.setname(projectData: myname)
        return cell
    }
}

