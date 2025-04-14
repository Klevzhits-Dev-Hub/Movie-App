//
//  OnboardingViewController.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 30.03.2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pages = [UIViewController]()
    private var currentIndex = 0
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemIndigo
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageViewController()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupPages() {
        let firstPage = OnboardingPageViewController(
            image: UIImage(named: "onboarding1") ?? UIImage(),
            title: "Откройте мир кино",
            description: "Находите новые фильмы, сохраняйте в избранное и создайте свою персональную коллекцию",
            buttonTitle: "Далее",
            isLastPage: false
        )
        
        let secondPage = OnboardingPageViewController(
            image: UIImage(named: "onboarding2") ?? UIImage(),
            title: "Персональные рекомендации",
            description: "Получайте подборки фильмов на основе ваших предпочтений и просмотров",
            buttonTitle: "Далее",
            isLastPage: false
        )
        
        let thirdPage = OnboardingPageViewController(
            image: UIImage(named: "onboarding3") ?? UIImage(),
            title: "Смотрите где угодно",
            description: "Сохраняйте контент для оффлайн-просмотра и наслаждайтесь без интернета",
            buttonTitle: "Начать",
            isLastPage: true
        )
        
        firstPage.delegate = self
        secondPage.delegate = self
        thirdPage.delegate = self
        
        pages = [firstPage, secondPage, thirdPage]
        pageControl.numberOfPages = pages.count
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemIndigo
        view.addSubview(skipButton)
        view.addSubview(pageControl)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pageViewController.view.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 20),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func skipButtonTapped() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        // Сохраняем информацию о завершении онбординга
        OnboardingManager.shared.setOnboardingComplete()
        
        // Получаем SceneDelegate для перехода на соответствующий экран
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // Закрываем онбординг
            dismiss(animated: true) { [weak sceneDelegate] in
                // Проверяем статус авторизации и переходим на соответствующий экран
                sceneDelegate?.checkAuthentication()
            }
        } else {
            // Если не удалось получить SceneDelegate, просто закрываем онбординг
            dismiss(animated: true)
        }
    }
    
    private func goToNextPage() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            pageViewController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true)
            pageControl.currentPage = currentIndex
        } else {
            completeOnboarding()
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }
}

// MARK: - OnboardingPageViewControllerDelegate
extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func didTapButton() {
        // Проверяем, является ли текущая страница последней
        if currentIndex == pages.count - 1 {
            // Если это последняя страница (кнопка Start), завершаем онбординг
            completeOnboarding()
        } else {
            // Иначе переходим к следующей странице
            goToNextPage()
        }
    }
}
