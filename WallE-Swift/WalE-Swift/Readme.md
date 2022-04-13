
Github URL For the Repo
https://github.com/abhishekbanerjee0390/WalE

How to run code
1) Prerequisite: XCode installed and properly setup
2) Clone the repo from above git url and switch to branch "AbhishekBanerjee-WalE"
3) Go to clone repo and open WalE-Swift.xcodeproj
4) Run the project on any iOS device



Improvement Areas
1. In my commit (31b9b4af5147c415bc13ac8f6a95ff4e8b1a4695) I have added horizontal scrolling for image, which I missed earlier.
    I am using tableview for the whole screen and collection view inside table view cell for the image to width scrolling.
    Both colletion view and tableview are using automatic dimension.
    Below code can be avoided if we know image size(height and width) before or receiving from the API as its meta data.
            if indexPath.row == 1, let imageData = viewModel?.apod.imageData {
            return UIImage(data: imageData)?.size.height ?? 0
        }
2. For offline support I am using User Defaults because of the time constraint. Core data was a better choice for that.
