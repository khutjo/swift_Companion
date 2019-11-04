//
//  ProjectCells.swift
//  TableView
//
//  Created by Khutjo MAPUTLA on 2019/10/24.
//  Copyright © 2019 Khutjo MAPUTLA. All rights reserved.
//

import UIKit

class ProjectCells: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Marks: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Validation: UILabel!
    
    
    func setname(projectData: ProjectData) {
        Name.text = projectData.ProjectName
        Marks.text = String(projectData.ProjectMarks) + "%"
        Status.text = projectData.Projectstatus
        if (projectData.Projectvalidation == 0){
            Validation.text = "not validated"}
        else {
        Validation.text = "validated"}
    }
    

}
