README

ViewController contains a tab bar and a tableview. Books are displayed in BookshelfViewCells, with two book in each cell. The cell could be further polished to include the cover picture of the book. Clicking the book leads to BookDetailsViewController which displays the detail information of the book. An open animation and the customized segue makes the transition smooth. The input textfield will be pushed up when the user is typing his name, so that he sees what he’s typing.

The App user AFNetworking lib to manage internet connection. InternetConnetion call its delegate functions after each request is sent. The error handling is not specify yet, but can be added. Reachability class is used to detect the current network status.

The database is stored in a NSDictionary. Each time the booklist updates, the new information is stored in NSUserDefault. When internet is not available, the tableview in ViewController will read the local data.