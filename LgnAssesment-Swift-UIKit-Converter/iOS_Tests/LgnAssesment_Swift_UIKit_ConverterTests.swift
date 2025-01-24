//
//  LgnAssesment_Swift_UIKit_ConverterTests.swift
//  LgnAssesment-Swift-UIKit-ConverterTests
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import XCTest
@testable import iOS
import Combine

final class LgnAssesment_Swift_UIKit_ConverterTests: XCTestCase {
    var testService: NetworkServiceProtocol = NetworkServiceTest()
    var testModel: CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol = CurrencyListModel(convertingValues: ConvertingValuesTest())
    var listViewModel: (ValuesListDataMapperProtocol & CurrencyListDataModelProtocol)? = nil
    
    override func setUpWithError() throws {
        listViewModel = CurrencyListViewModel(dataModel: testModel, networkService: testService )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testDataMaping() throws {
        listViewModel!.updateCurrencyValuesList()

        let expectation = XCTestExpectation(description: "Open a file asynchronously.")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: { [self] in
            if listViewModel!.dataModel.convertingValues.getCurrencyValue(code:"JPY") == "777" {
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 7)
    }

}

final class NetworkServiceTest: NetworkServiceProtocol {
    @Published var cpub: RequestResponseValue?

    init() {
        cpub = createData()
    }
    func request<T>(_ endpoint: iOS.Endpoint, headers: [String : String]?, parameters: (any Encodable)?) -> AnyPublisher<T, iOS.APIError> where T : Decodable {
        let p = (cpub) as! T
        return Just(p).setFailureType(to: iOS.APIError.self).eraseToAnyPublisher()
    }
    
    func createData() -> RequestResponseValue {
        return RequestResponseValue(amount: "777", currency: "JPY")
    }

}

final class ConvertingValuesTest: ConvertingValuesProtocol & ConvertingMethodsProtocol {
    lazy var list: [ConvertingValuesInfo] = {
        [ConvertingValuesInfo(code: "JPY", value: "0")]
    }()
    
    func addSymbolToPrimaryValue(_ tag: BoardKeysTags) {

    }
    
    func deleteSymbolFromToPrimaryValue() {

    }
    
    func cleanToPrimaryValue() {

    }
        
    func setValueConvertedValue(code: String, value: String) {
        guard let item = list.first(where: {$0.code == code}) else { return }
        item.value = value
    }
    
    func getCurrencyValue(index: Int) -> String {
        guard list.count >= index - 1 else {return "0"}
        return list[index].value
    }
    
    func getCurrencyValue(code: String) -> String {
        guard let item = list.first(where: {$0.code == code}) else { return "" }
        return item.value
    }
}

