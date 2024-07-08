import UIKit

import RxFlow
import Swinject

import Core

public class AppFlow: Flow {
    
    private var window: UIWindow
    private let container: Container
    
    public var root: RxFlow.Presentable {
        return window
    }
    
    public init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .onboardingIsRequired:
                return presentOnboardingView()
//            case .loginIsRequired:
//                return presentLoginView()
            case .tabIsRequired:
                return presentTabView()
            case .testIsRequired:
                return presentTestView()
            default:
                return .none
        }
    }
    
    private func presentOnboardingView() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(container: self.container)
        Flows.use(onboardingFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.onboardingIsRequired)
        ))
    }
    
    private func presentTabView() -> FlowContributors {
        let tabsFlow = TabsFlow(container: self.container)
        Flows.use(tabsFlow, when: .created) { [weak self] root in
            UIView.transition(
                with: self!.window,
                duration: 0.5,
                options: .transitionCrossDissolve
            ) {
                self!.window.rootViewController = root
            }
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: tabsFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.tabIsRequired)
        ))
    }

    
    private func presentTestView() -> FlowContributors {
        let testFlow = TestFlow(container: self.container)
        Flows.use(testFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: testFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.testIsRequired)
        ))
    }
    
}
