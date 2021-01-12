# ReAnimation

[![CI Status](https://img.shields.io/travis/bartosy-ymija/ReAnimation.svg?style=flat)](https://travis-ci.org/bartosy-ymija/ReAnimation)
[![Version](https://img.shields.io/cocoapods/v/ReAnimation.svg?style=flat)](https://cocoapods.org/pods/ReAnimation)
[![License](https://img.shields.io/cocoapods/l/ReAnimation.svg?style=flat)](https://cocoapods.org/pods/ReAnimation)
[![Platform](https://img.shields.io/cocoapods/p/ReAnimation.svg?style=flat)](https://cocoapods.org/pods/ReAnimation)
[![codecov](https://img.shields.io/codecov/c/github/bartosy-ymija/ReAnimation?token=2NMA7NN4BI)](https://codecov.io/gh/bartosy-ymija/ReAnimation)


## Usage

ReAnimation is a library which wraps the UIView.animate in a RxSwift context allowing to declaratively create new animations. For example, following code moves the view by 40 and simultaneously scales it up to 0.5 and back to 1 horizontally:
``` swift
        let duration = 2.0
        view.rx.animate(
            ReactiveAnimations.Move(offsetX: 40, duration: duration)
                .simultaneously(
                    with: ReactiveAnimations.Scale(
                        factorX: 0.5, 
                        duration: duration / 2
                    )
                        .followed(
                            by: ReactiveAnimations.Scale(
                                factorX: 1.0, 
                                duration: duration
                            )
                        )
                )
        )
```

More examples are available in the example app.

## Installation

### CocoaPods

ReAnimation is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ReAnimation'
```

### Carthage
To install the library through [Carthage](https://github.com/Carthage/Carthage) add the following line to your Cartfile:

```
github "bartosy-ymija/ReAnimation"
```

## License

ReAnimation is available under the MIT license. See the LICENSE file for more info.
