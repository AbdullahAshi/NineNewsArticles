# NineNewsArticles
Nine News Code Challenge Project

## Project Architecture
for this sample project and given its small scope **MVVM** is the most suitable, keeping things concise, testable and maintainable. 

MVVM suggests separating the data presentation logic(Views or UI) from the core business logic part of the application. 

The separate code layers of MVVM are (Model-View-ViewModel) :
Model: This layer is responsible for the abstraction of the data sources. Model and ViewModel work together to get and save the data.
View: The purpose of this layer is to inform the ViewModel about the user’s action. This layer observes the ViewModel and does not contain any kind of application logic.
ViewModel: It exposes those data streams which are relevant to the View. Moreover, it serves as a link between the Model and the View. 

## Dependency Manager
[Swift Package Manager](https://www.swift.org/package-manager/) is used to manage dependencies.
SDWebImage dependency is added to cache images.
 
## Unit tests
The exact same folder structure has been followed for unit tests to easily find Class's corresponding tests.

the name of the test function reflects the testing purpose. In addition, expectation description is added to make it more clear.  

## Code Compilation 
SPM takes care of managing and installing dependencies for you, so after the first launch wait for the package to be downloaded and built the run  the project.

**note:** incase of error, in Xcode select File -> Packages -> Reset Package Caches, then try build and run again.  
