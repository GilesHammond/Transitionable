# Transitionable

## What It Does

SwiftUI makes it easy to animate simple interface updates, but it quickly gets complicated when you want to update custom parameters during animations.

`Animatable` `ViewModifier`s make it possible to smoothly change     a single `VectorArithmetic` conforming parameter. Chained `AnimatablePair`s can handle more, but it's messy.

`Transitionable` allows you to create any changes you want to a set of parameters as an animation proceeds from 0-1.

## How To Use It

Create a `Transitionable` conforming `struct` containing the parameters you want to transition:

```swift
struct FontDescriptor: Transitionable
{
    let style: BlockFontStyle
    let size: CGFloat
    let weight: CGFloat
    let lineSpacing: CGFloat
}
```

Implement `transition(to:, progress:)`, defining how your parameters should change over the course of an animation – `progress` will go from `0` to `1`:

```swift
func transition(_ other: FontDescriptor, progress: CGFloat) -> FontDescriptor {
        let progress = progress * progress
        
        return FontDescriptor(
            style: progress < 0.5 ? style : other.style,
            size: progress.lerp(min: size, max: other.size),
            weight: progress.lerp(min: weight, max: other.weight),
            lineSpacing: progress.lerp(min: lineSpacing, max: other.lineSpacing))
    }
```

Add an `EnvironmentKey` for your parameters:

```swift
private struct FontDescriptorKey: EnvironmentKey {
    static let defaultValue = Style.fontDescriptor(for: defaultState)
}

extension EnvironmentValues {
    var fontDescriptor: FontDescriptor {
        get { self[FontDescriptorKey.self] }
        set { self[FontDescriptorKey.self] = newValue }
    }
}
```

Pass your parameters to child views using the `View` extension:

```swift
MyTextView()
    .environmentTransition(\.fontDescriptor, Style.fontDescriptor(for: someState))
```

Use the parameters as you wish in your `View`:

```swift
struct MyTextView: View
{
    @Environment(\.fontDescriptor) var fontDescriptor: FontDescriptor
    
    var body: some View {
          ...
    }
}
```
