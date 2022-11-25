//
//  Transitionable.swift
//  Created by Giles on 21/11/2022.
//

import SwiftUI

protocol Transitionable: Equatable {
    func transition(to other: Self, progress: CGFloat) -> Self
}

@available(macOS 11.0, iOS 14.0, *)
extension View {
    func environmentTransition<V: Transitionable>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V
    ) -> some View {
        modifier(EnvironmentTransitionTracker(environmentKey: keyPath, newValue: value))
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct EnvironmentTransitionTracker<V: Transitionable>: ViewModifier
{
    let environmentKey: WritableKeyPath<EnvironmentValues, V>
    let newValue: V
    
    @State var oldValue: V?
    @State var previousProgress: CGFloat = 0
    
    func body(content: Content) -> some View {
        content.modifier(EnvironmentTransition(environmentKey: environmentKey,
                                               newValue: newValue,
                                               oldValue: $oldValue,
                                               previousProgress: $previousProgress,
                                               animationProgress: previousProgress + 1))
    }
}

@available(macOS 11.0, iOS 14.0, *)
struct EnvironmentTransition<V: Transitionable>: ViewModifier, Animatable
{
    let environmentKey: WritableKeyPath<EnvironmentValues, V>
    let newValue: V
    
    @Binding var oldValue: V?
    @Binding var previousProgress: CGFloat
    
    var animationProgress: CGFloat
    var animatableData: CGFloat {
        get { animationProgress }
        set { animationProgress = newValue } }
    
    var progress: CGFloat { animationProgress - previousProgress }
    var currentValue: V {
        oldValue == nil ? newValue : oldValue!.transition(to: newValue, progress: progress) }
    
    func body(content: Content) -> some View {
        content
            .environment(environmentKey, currentValue)
            .onChange(of: newValue) { newValue in
                oldValue = currentValue
                previousProgress = animationProgress }
    }
}
