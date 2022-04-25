import SwiftUI


/// A Course consists out of pages which have a title and a few PageElements
public struct Page: Equatable {
    
    /// unique identifier
    var id: String
    
    /// displayed in the navigation bar
    let title: String
    
    /// displayed small above the contentTitle, should follow the following convention if it is a lesson: *Lesson <numer>*
    let contentSubTitle: String
    
    /// displayed large in the header of a page
    let contentTitle: String
    
    /// SFSymbols name for a page
    let titleImageName: String
    
    /// value of type PlaygroundView (enumeration defined in Content.swift) that refers to a playgroundView that will be shown on the right
    let playgroundView: PlaygroundViews
    
    /// composition of a page, consists out of PageElements that will be drawn in the view
    let elements: [PageElement]
    
    // conform to equatable
    public static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.id == rhs.id
    }
}

/// common type of all PageElements that will be drawn on the page
/// ensures that ever PageElement has an id and top & bottom spacing
/// Objects of type PageElements shall not be created, instead uses childs like PageText that can be drawn
class PageElement {
    
    var id: UUID
    var topSpacing: Bool
    var bottomSpacing: Bool
    
    init(_ topSpacing: Bool, _ bottomSpacing: Bool) {
        id = UUID()
        self.topSpacing = topSpacing
        self.bottomSpacing = bottomSpacing
    }

}


// MARK: PageElements:

/// body text
class PageText : PageElement {
    var text: String
    
    /// topSpacing and bottomSpacing has deafult values of false if not specified
    init(_ text: String, topSpacing: Bool = false, bottomSpacing: Bool = false) {
        self.text = text
        super.init(topSpacing, bottomSpacing)
    }
}

/// use when the pages topic needs to be divided into smaller subtopics, start a new topice with a PageHeadline
class PageHeadline : PageElement {
    var text: String
    
    /// topSpacing and bottomSpacing has deafult values of false if not specified
    init(_ text: String, topSpacing: Bool = false, bottomSpacing: Bool = false) {
        self.text = text
        super.init(topSpacing, bottomSpacing)
    }
}

/// image, file must be accessible in Assets
class PageImage : PageElement {
    var imageName: String
    
    /// topSpacing and bottomSpacing has deafult values of false if not specified
    init(imageName: String, topSpacing: Bool = false, bottomSpacing: Bool = false) {
        self.imageName = imageName
        super.init(topSpacing, bottomSpacing)
    }
}

/// highlighted task the user needs to complete
/// subtasks are optional
class PageTask : PageElement {
    var text: String
    var subTasks: [String]?
    
    /// topSpacing and bottomSpacing has deafult values of *false* if not specified
    /// subTasks has deafult values of *nil* if not specified
    init(_ text: String, subTasks: [String]? = nil, topSpacing: Bool = false, bottomSpacing: Bool = false) {
        self.text = text
        self.subTasks = subTasks
        super.init(topSpacing, bottomSpacing)
    }
}

/// simple divider that draws a seperating line
class PageDivider : PageElement {
    
    /// topSpacing and bottomSpacing has deafult values of false if not specified
    init(topSpacing: Bool = false, bottomSpacing: Bool = false) {
        super.init(topSpacing, bottomSpacing)
    }
}

/// allows to darw any custom view inside of the content area
/// A custom view must be registered in the eum PageCustomView and the switch case in PageContentView must cover that case for a view to appear
class PageCustomView : PageElement {
    var customView: ContentCustomView
    
    /// topSpacing and bottomSpacing has deafult values of false if not specified
    init(_ customView: ContentCustomView, topSpacing: Bool = false, bottomSpacing: Bool = false) {
        self.customView = customView
        super.init(topSpacing, bottomSpacing)
    }
}
