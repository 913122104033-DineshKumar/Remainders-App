import Foundation

@objc protocol NoteDelegate: AnyObject
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String, _ notes: Notes?)
    
    func receiveListData(_ listName: String, _ listObject: ListIem?)
    
    @objc optional func saveChanges()
}
