# movieApp

I used a hybrid design pattern. project includes Utils, Common, Models, Modules, Managers and Storyboards modules.
I create a MovieAppBaseViewControler to inherited all VC's.
For API endpoint calls, I created a APIManager singelton class.
for CoreData management, I created a CoreDataManager singleton class.
For Collection View's display, I created a Custom collection View layout class in home module.
for pagination of Favorite Movie API Endpoint, I used UICollectionViewDataSourcePrefetching.
I added a dynamic search mechanism to HomeViewController.
I used IBinspectable to make designs easily. 
