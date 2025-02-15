import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {

    // MARK: - Network Client
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
          self.networkClient = networkClient
      }
       
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {

        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMovies")
        }
        return url
    }


    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .success(let data):
                do {
                    let MostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(MostPopularMovies)) }
                catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
