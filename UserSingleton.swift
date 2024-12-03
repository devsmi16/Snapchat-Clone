import Foundation


class UserSingleton{
    
    static let sharedUserInfo = UserSingleton()
    var mail = ""
    var username = ""
    
    private init(){
        
    }
}
