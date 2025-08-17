import CoreData

class NotesModelHandler
{
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    
    public func buildNotesData(notesID: String, notesTitle: String, notesContent: String?)
    {
        let notes = Notes(context: self.context)
        notes.notesID = notesID
        notes.noteTitle = notesTitle
        notes.notes = notesContent
    }
    
}
