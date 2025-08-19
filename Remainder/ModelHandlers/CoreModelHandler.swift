import CoreData

class CoreModelHandler
{
    public static func fetchAllData<Entity>(fetchController: NSFetchedResultsController<Entity>?)
    {
        do
        {
            try fetchController?.performFetch()
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
    
    public static func configureFetchController<Entity>(request: NSFetchRequest<Entity>, context: NSManagedObjectContext) -> NSFetchedResultsController<Entity>
    {
        let sort = NSSortDescriptor(key: "listID", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        let fetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        CoreModelHandler.fetchAllData(fetchController: fetchController)
        return fetchController
    }
    
    public static func addNotesToList(notesID: String, listID: String, fetchController: NSFetchedResultsController<ListIem>)
    {
        if let items = fetchController.fetchedObjects
        {
            for item in items
            {
                if item.listID == listID
                {
                    item.notesIDs?.append(notesID)
                    return
                }
            }
        }
    }
    
}
