
import Foundation
import Combine
import MapKit

class EdamamNetworkManager{
    
    static let shared = EdamamNetworkManager()
    
    private init() {
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    let headers = [
        "X-RapidAPI-Key": "c1f3a182camshb8b34476135e4aap1cb869jsn5e45a3d2028d",
        "X-RapidAPI-Host": "edamam-food-and-grocery-database.p.rapidapi.com"
    ]

    let recipeURL = "https://api.edamam.com/api/recipes/v2"
    let recipeAPIKey =  "4ed5ca518b3756cbc0701d7501264aa8" //"e95a4e68efaa40b692aa7e156348e8f"
    let recipeAPIID = "60774aad"//"4f2d15f6"
    
    func getRecipe<T: Decodable>(endpoint: String, query: [String:String], type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in

            guard let self = self,
                  var urlComponents = URLComponents(string: endpoint) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            //https://api.edamam.com/api/recipes/v2?type=public&beta=false&q=crawfish%20etouffee&app_id=60774aad&app_key=4ed5ca518b3756cbc0701d7501264aa8&ingr=5-8&diet=high-protein&cuisineType=American&mealType=Dinner&calories=100-300&imageSize=THUMBNAIL

            urlComponents.queryItems=[URLQueryItem(name:"type", value:"public"),
                                      URLQueryItem(name:"beta", value:"false"),
                                      URLQueryItem(name:"app_key",value:self.recipeAPIKey),
                                      URLQueryItem(name:"app_id", value:"60774aad")]
           
            for (key, value)  in query {
                let item = URLQueryItem(name: key, value:value)
                urlComponents.queryItems?.append(item)
            }
           
            guard let url = urlComponents.url else {
                return promise(.failure(NetworkError.invalidURL))
            }

            //decode date to correct format
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            print(url)
            
            URLSession.shared.dataTaskPublisher(for: url)
            //URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    data.printJSON()
                    return data
                }
                .decode(type: T.self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)

        }
    }

}
