//
//  EventsViewModelTests.swift
//  HooliganTests
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import XCTest
@testable import Hooligan

class EventsViewModelTests: XCTestCase {
    
    class MockInteractor: EventsBoundary {
    
        var expectation: XCTestExpectation?
        
        func retrieveEvents() async throws -> [EventsResponseModel]? {
            expectation?.fulfill()
            return []
        }
    }
    
    class MockDelegate: EventsViewModelDelegate & UIViewController {
        
        var expectation: XCTestExpectation?
        
        func refreshViewContents() {
            expectation?.fulfill()
        }
    }
    
    func testThatItFetchesEvents() {
        let interactorExpectation = expectation(description: "Fullfill Interactor")
        let delegateExpectation = expectation(description: "Fullfill Delegate")
        let delegate = MockDelegate()
        delegate.expectation = delegateExpectation
        let interactor = MockInteractor()
        interactor.expectation = interactorExpectation
        let viewModel = EventsViewModel(delegate: delegate,
                                        eventsInteractor: interactor)
        viewModel.retrieveRemoteEvents()
        waitForExpectations(timeout: 5)
    }
    
    func testThatCreatesDataModelsFromResponse() {
        
        class MockDelegate: EventsViewModelTests.MockDelegate {
            // avoid retain cycles
            weak var viewModel: EventsViewModel?
            
            override func refreshViewContents() {
                expectation?.fulfill()
                let indexPath1 = IndexPath(row: 0, section: 0)
                let indexPath2 = IndexPath(row: 1, section: 0)
                XCTAssertNotNil(viewModel?.playerDataModel(at: indexPath1))
                XCTAssertNotNil(viewModel?.playerDataModel(at: indexPath2))
            }
        }
        
        class MockInteractor: EventsViewModelTests.MockInteractor {
            
            override func retrieveEvents() async throws -> [EventsResponseModel]? {
                expectation?.fulfill()
                let responseModel1 = EventsResponseModel(id: "1",
                                                         title: "Liverpool v Porto",
                                                         imageURL: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/310176837169_image-header_pDach_1554579780000.jpeg?alt=media&token=1777d26b-d051-4b5f-87a8-7633d3d6dd20",
                                                         subtitle: "UEFA Champions League",
                                                         videoURL: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/promo.mp4?alt=media",
                                                         date: "2022-09-28T01:51:33.681Z")
                let responseModel2 = EventsResponseModel(id: "2",
                                                         title: "Nîmes v Rennes",
                                                         imageURL: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/310381637057_image-header_pDach_1554664873000.jpeg?alt=media&token=53616931-55a8-476e-b1b7-d18fc22a2bf0",
                                                         subtitle: "Ligue 1",
                                                         videoURL: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/promo.mp4?alt=media",
                                                         date: "2022-09-28T02:51:33.681Z")
                return [responseModel1, responseModel2]
            }
        }
        
        let interactorExpectation = expectation(description: "Fullfill Interactor")
        let delegateExpectation = expectation(description: "Fullfill Delegate")
        let delegate = MockDelegate()
        delegate.expectation = delegateExpectation
        let interactor = MockInteractor()
        interactor.expectation = interactorExpectation
        let viewModel = EventsViewModel(delegate: delegate,
                                        eventsInteractor: interactor)
        delegate.viewModel = viewModel
        viewModel.retrieveRemoteEvents()
        waitForExpectations(timeout: 5)
    }
    
    // TODO: - To be continued...
    
    func testThatItSortsResponseModels() {
        
    }
    
    func testThatItFormatsDate() {
        
    }
    
    func testThatItNotifiesViewOnDataReceived() {
        
    }
    
    func testThatItHasDelegate() {
        
    }
    
    func testThatRetrievesDataModelAtIndex() {
        
    }
    
    func testThatReturnsSelectedPlayerURL() {
        
    }
    
    func testThatReturnsRowCount() {
        
    }
    
    // MARK: - Negative
    // TODO: - Test negative like invalid URLS and Invalid date formats to cater for all edge cases...
}
