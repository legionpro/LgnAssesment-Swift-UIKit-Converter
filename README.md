# LgnAssesment-Swift-UIKit-Converter
currency converter as a demo app

# Currency Converter

git@github.com:legionpro/LgnAssesment-Swift-UIKit-Converter.git



## Important Notes:

I am going to move forward with this project to develop more improvements and to publish the app on App Store. So, please do not use this project in commercial purposes. For the review only.



## About Requirements:

- The project implemented in Swift. 

- All UI components are Implemented programmatically using UIKit, Combine (without using storyboards or XIB files). 

- Tryed avoid overengineering

- Used Apple's recommended Targets naming practice in project.

- The interface  is user-friendly. It does not require additional user manual.

- UI is developed to avoid user boring activity.

- implemented approach - Just run and use.

- UI Layout is implemented on Auto Layout components. It works on iPad and iPhone;

- All network Errors are Handling, user is friendly way informed about errors.

- Network service component is implemented as a single file - it is just because - I am going to this service as a separate module ( for further using )

- This Git Repository contains a detailed commit history and reflects all development stages.

- Used third-party libraries - Lottie API (needs to be updated before) and  some UIKit Types extensions.

- Implemented small list of countries in separate file (just as for demo) - it can be easily updated.

- Implemented Protocol Oriented Development approach with dependency injection techniques

- Used Apple-recommended (default format tool in xCode 16.2)

- Adding new currency process is very easy

- Developed demo (but real) UnitTest to check data-mapping functionality

- Example of using more complicated JSON structure can be found in my another repo: 

  git@github.com:legionpro/LgnAssesment-Swift-UIKit.git



The API is public and no authentication is required.

URI Syntax: `http://api.evp.lt/currency/commercial/exchange/{fromAmount}-{fromCurrency}/{toCurrency}/latest`Example: http://api.evp.lt/currency/commercial/exchange/340.51-EUR/JPY/latest

