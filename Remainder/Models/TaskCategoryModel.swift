import UIKit

struct TaskCategoryModel
{
    let title: String
    var noOfTasks: (() -> Int)?
    let iconName: String
    let iconColor: UIColor?
}
