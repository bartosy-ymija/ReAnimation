Pod::Spec.new do |s|
  s.name             = 'ReAnimation'
  s.version          = '0.1.0'
  s.summary          = 'ReAnimation is a library for working with animations declaratively via RxSwift framework.'

  s.description      = <<-DESC
This library is intended to cut out unnecessary boilerplate from UIView.animate by encapsulating the animations in declarative constructs which can be plugged into a RxSwift pipeline.

For example, animating the origin along with the scale is as simple as using
```
target.rx.animate(
    ReactiveAnimations.Scale(factorX: 3, factorY: 3, duration: duration)
        .simultaneously(with: ReactiveAnimations.Move(originX: 1, originY: 1, duration: duration))
)
```
                       DESC

  s.homepage         = 'https://github.com/bartosy-ymija/ReAnimation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bartosy-ymija' => 'zmija.bartosz@gmail.com' }
  s.source           = { :git => 'https://github.com/bartosy-ymija/ReAnimation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ReAnimation/**/*'
  s.exclude_files = 'ReAnimation/*.plist'
  s.swift_versions = ['5.0']
  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
end
