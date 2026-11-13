import SwiftUI

@main
struct CountriesApp: App {
    
    @State var viewModel = CountriesViewModel()
    @AppStorage("hasSeenIntro") var hasSeenIntro : Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenIntro {
                CountryGridView()
                    .environment(viewModel)
            } else {
                IntroView {
                    hasSeenIntro = true
                }
            }
        }
    }
}
