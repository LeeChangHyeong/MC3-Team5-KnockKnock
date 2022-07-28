//
//  OnboardingViewController.swift
//  KnockKnock
//
//  Created by hurdasol on 2022/07/28.
//

import UIKit

class OnboardingController: UIPageViewController {

    var pages = [UIViewController]()

    // external controls
//    let skipButton = UIButton()
//    let nextButton = UIButton()
    let pageControl = UIPageControl()
    let initialPage = 0
// MARK: - 룸 버튼 생성
    let goToRoomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .init(red: 128/255, green: 159/255, blue: 174/255, alpha: 1)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        
        button.setTitle("방에 입장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToRoomButtonTapped), for: .touchUpInside)
       
        return button
    }()
    
    // animations
//    var skipButtonTopAnchor: NSLayoutConstraint?
//    var nextButtonTopAnchor: NSLayoutConstraint?
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
        
    }
    

    

}

extension OnboardingController {
    
    func setup() {
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
// MARK: - 룸버튼 액션 추가
        goToRoomButton.addTarget(self, action: #selector(goToRoomButtonTapped), for: .touchUpInside)
        let page1 = OnboardingViewController(imageName: "album",
                                             titleText: "앨범",
                                             subtitleText: "사진을 저장하여\n사랑하는 고인과의\n추억을 꺼내보세요")
        let page2 = OnboardingViewController(imageName: "frame",
                                             titleText: "액자",
                                             subtitleText: "고인의 사진을 꽂아서\n고인의 방을 꾸며주세요")
        let page3 = OnboardingViewController(imageName: "memo",
                                             titleText: "다이어리",
                                             subtitleText: "당신의 일상을 사진과 함께\n기록하고 마음을 돌아보세요")
        let page4 = OnboardingViewController(imageName: "letter", titleText: "편지", subtitleText:"마음속에 있던 이야기를\n편지에 자유롭게 기록하고\n하늘에 날려버리세요.")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        //nav?
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .systemGray2
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
// MARK: - 룸버튼 스타일
        goToRoomButton.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.setTitleColor(.systemBlue, for: .normal)
//        skipButton.setTitle("Skip", for: .normal)
//        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)
//
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.setTitleColor(.systemBlue, for: .normal)
//        nextButton.setTitle("Next", for: .normal)
//        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(pageControl)
//        view.addSubview(nextButton)
//        view.addSubview(skipButton)
        // MARK: - 룸 버튼 레이아웃
        view.addSubview(goToRoomButton)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 10),
            
            goToRoomButton.widthAnchor.constraint(equalToConstant: 340),
            goToRoomButton.heightAnchor.constraint(equalToConstant: 54),
            goToRoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToRoomButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
            
            
            
//            skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

//            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
        ])
        
        // for animations
//        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
//        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 10)

//        skipButtonTopAnchor?.isActive = true
//        nextButtonTopAnchor?.isActive = true
        pageControlBottomAnchor?.isActive = true
    }
}

// MARK: - DataSource

extension OnboardingController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return RoomViewController()//pages.first              // wrap first
        }
    }
}

// MARK: - Delegates

extension OnboardingController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
    }
    
    private func animateControlsIfNeeded() {
        let lastPage = pageControl.currentPage == pages.count - 1
        
        if lastPage {
            hideControls()
        } else {
            showControls()
        }

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideControls() {
        pageControlBottomAnchor?.constant = -80
//        skipButtonTopAnchor?.constant = -80
//        nextButtonTopAnchor?.constant = -80
        goToRoomButton.topAnchor.constraint(equalTo: view.bottomAnchor , constant: -130).isActive = true
    }

    private func showControls() {
        pageControlBottomAnchor?.constant = 80
//        skipButtonTopAnchor?.constant = 16
//        nextButtonTopAnchor?.constant = 16
        goToRoomButton.topAnchor.constraint(equalTo: view.bottomAnchor , constant: 80).isActive = true
    }
}

// MARK: - Actions

extension OnboardingController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        animateControlsIfNeeded()
    }
    
    @objc func goToRoomButtonTapped() {
        let roomVC = RoomViewController()
        self.navigationController?.pushViewController(roomVC, animated: true)
    }

//    @objc func skipTapped(_ sender: UIButton) {
//        let lastPageIndex = pages.count - 1
//        pageControl.currentPage = lastPageIndex
//
//        goToSpecificPage(index: lastPageIndex, ofViewControllers: pages)
//        animateControlsIfNeeded()
//    }
//
//    @objc func nextTapped(_ sender: UIButton) {
//        pageControl.currentPage += 1
//        goToNextPage()
//        animateControlsIfNeeded()
//    }
}

// MARK: - Extensions

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
    
}
