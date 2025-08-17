import CoreData

class CoreModelHandler
{
    public static func fetchAllData<Entity>(fetchController: NSFetchedResultsController<Entity>)
    {
        do
        {
            try fetchController.performFetch()
        } catch
        {
            print("Data is not being fetched")
        }
    }
    
    public static func saveChanges(
        context: NSManagedObjectContext,
        perform action: () -> ()
    )
    {
        action()
        
        do
        {
            try context.save()
        } catch
        {
            print("Data is not added")
        }
    }
    
}
