import Foundation

protocol NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String)
    
    func receiveListData(_ listName: String)
}
