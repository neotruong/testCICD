import Foundation

enum MString {
    enum Auth {
        static let email = NSLocalizedString("auth.email", comment: "")
        static let password = NSLocalizedString("auth.password", comment: "")
        static let forgot = NSLocalizedString("auth.forgot", comment: "")
        static let login = NSLocalizedString("auth.login", comment: "")
    }
    
    enum Forgot {
        static let description = NSLocalizedString("forgot.des", comment: "")
        static let reset = NSLocalizedString("forgot.reset", comment: "")
    }
    
    enum Home {
        static let takeSurvey = NSLocalizedString("home.takeSurvey", comment: "")
    }

    enum SucessSurvey {
        static let sucessDes = NSLocalizedString("sucessSurvey.thanks", comment: "")
    }

}
