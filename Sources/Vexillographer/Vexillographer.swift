//
//  Vexillographer.swift
//  Vexil: Vexilographer
//
//  Created by Rob Amos on 14/6/20.
//

#if os(iOS) || os(macOS)

import SwiftUI
import Vexil

/// A SwiftUI View that allows you to easily edit the flag
/// structure in a provided FlagValueSource.
@available(OSX 11.0, iOS 13.0, watchOS 7.0, tvOS 13.0, *)
public struct Vexillographer<RootGroup>: View where RootGroup: FlagContainer {

    // MARK: - Properties

    @ObservedObject var manager: FlagValueManager<RootGroup>


    // MARK: - Initialisation

    /// Initialises a new `Vexillographer` instance with the provided FlagPole and source
    ///
    /// - Parameters;
    ///   - flagPole:           A `FlagPole` instance manages the flag and source hierarchy we want to display
    ///   - source:             An optional `FlagValueSource` for editing the flag values in. If `nil` the flag values are displayed read-only
    ///
    public init (flagPole: FlagPole<RootGroup>, source: FlagValueSource?) {
        self.manager = FlagValueManager(flagPole: flagPole, source: source)
    }


    // MARK: - Body

    #if os(macOS) && compiler(>=5.3.1)

    public var body: some View {
        List(self.manager.allItems(), id: \.id, children: \.childLinks) { item in
            item.unfurledView
        }
            .listStyle(SidebarListStyle())
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: NSApp.toggleKeyWindowSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
    }

    #else

    public var body: some View {
        ForEach(self.manager.allItems(), id: \.id) { item in
            item.unfurledView
        }
            .environmentObject(self.manager)
    }

    #endif
}

#endif
