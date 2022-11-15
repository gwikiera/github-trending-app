import Combine

public extension Publisher {
    func firstResult() async -> Result<Output, Error> {
        return await withCheckedContinuation { continuation in
            _ = first()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(returning: .failure(error))
                    }
                } receiveValue: { value in
                    continuation.resume(returning: .success(value))
                }
        }
    }
}
