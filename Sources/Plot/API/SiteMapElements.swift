/**
*  Plot
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Foundation

// MARK: - Root

extension Element where Context == SiteMap.RootContext {
  /// Add a `<urlset>` element within the current context.
  /// - parameter nodes: The element's attributes and child elements.
  public static func urlset(_ nodes: Node<SiteMap.URLSetContext>...) -> Element {
    let attributes: [Attribute<SiteMap.URLSetContext>] = [
      Attribute(
        name: "xmlns",
        value: "http://www.sitemaps.org/schemas/sitemap/0.9"
      ),
      Attribute(
        name: "xmlns:image",
        value: "http://www.google.com/schemas/sitemap-image/1.1"
      ),
    ]

    return Element(
      name: "urlset",
      nodes: attributes.map(\.node) + nodes
    )
  }
}

// MARK: - URLs

extension Node where Context == SiteMap.URLSetContext {
  /// Add a `<url>` element within the current context.
  /// - parameter nodes: The element's child elements.
  public static func url(_ nodes: Node<SiteMap.URLContext>...) -> Node {
    .element(named: "url", nodes: nodes)
  }
}

extension Node where Context == SiteMap.URLContext {
  /// Define the URL's location.
  /// - parameter url: The canonical location URL.
  public static func loc(_ url: URLRepresentable) -> Node {
    .element(named: "loc", text: url.string)
  }

  /// Define the frequency at which the URL's content is expected to change.
  /// - parameter frequency: The frequency to define (see `SiteMapChangeFrequency`).
  public static func changefreq(_ frequency: SiteMapChangeFrequency) -> Node {
    .element(named: "changefreq", text: frequency.rawValue)
  }

  /// Define the priority of indexing this URL.
  /// - parameter priority: A priority value between 0 and 1.
  public static func priority(_ priority: Double) -> Node {
    .element(named: "priority", text: String(priority))
  }

  /// Declare when the URL's content was last modified.
  /// - parameter date: The date the URL's content was last modified.
  /// - parameter timeZone: The time zone of the given `Date` (default: `.current`).
  public static func lastmod(_ date: Date, timeZone: TimeZone = .current) -> Node {
    let formatter = SiteMap.dateFormatter
    // formatter.timeZone = timeZone
    let dateString = formatter.string(from: date)
    return .element(named: "lastmod", text: dateString)
  }
}
