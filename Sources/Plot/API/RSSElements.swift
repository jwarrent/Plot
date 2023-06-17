/**
*  Plot
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import Foundation

// MARK: - Top-level

extension Element where Context: RSSRootContext {
  /// Add an `<rss>` element within the current context.
  /// - parameter nodes: The element's attributes and child elements.
  public static func rss<C: RSSFeedContext>(_ nodes: Node<C>...) -> Element {
    Element(name: "rss", closingMode: .standard, nodes: nodes)
  }
}

extension Node where Context: RSSFeedContext {
  /// Add a `<channel>` element within the current context.
  /// - parameter nodes: The element's attributes and child elements.
  public static func channel(_ nodes: Node<Context.ChannelContext>...) -> Node {
    .element(named: "channel", nodes: nodes)
  }
}

// MARK: - Channel

extension Node where Context: RSSChannelContext {
  /// Define the channel's title
  /// - parameter title: The title of the channel.
  public static func title(_ title: String) -> Node {
    .element(named: "title", text: title)
  }

  /// Define the channel's primary language.
  /// - parameter language: The channel's primary language.
  public static func language(_ language: Language) -> Node {
    .element(named: "language", text: language.rawValue)
  }

  /// Declare when the feed was last built/generated.
  /// - parameter date: The date the feed was generated.
  /// - parameter timeZone: The time zone of the given `Date` (default: `.current`).
  public static func lastBuildDate(
    _ date: Date,
    timeZone: TimeZone = .current
  ) -> Node {
    let formatter = RSS.dateFormatter
    formatter.timeZone = timeZone
    let dateString = formatter.string(from: date)
    return .element(named: "lastBuildDate", text: dateString)
  }

  /// Declare the TTL (or "Time to live") time interval for this feed.
  /// - parameter minutes: The number of minutes until the feed expires.
  public static func ttl(_ minutes: Int) -> Node {
    .element(named: "ttl", text: String(minutes))
  }

  /// Associate an Atom feed link with this feed.
  /// - parameter href: The link of the atom feed (usually the same URL as
  ///   the feed's own).
  public static func atomLink(_ href: URLRepresentable) -> Node {
    .selfClosedElement(
      named: "atom:link",
      attributes: [
        .any(name: "href", value: href.string),
        .any(name: "rel", value: "self"),
        .any(name: "type", value: "application/rss+xml"),
      ])
  }

  /// Add an `<item>` element within the current context.
  /// - parameter nodes: The element's child elements.
  public static func item(_ nodes: Node<Context.ItemContext>...) -> Node {
    .element(named: "item", nodes: nodes)
  }
}

// MARK: - Item

extension Node where Context: RSSItemContext {
  /// Add a `<guid>` element within the current context.
  /// - parameter nodes: The element's attributes and child elements.
  public static func guid(_ nodes: Node<RSS.GUIDContext>...) -> Node {
    .element(named: "guid", nodes: nodes)
  }

  /// Assign an HTML string as this item's content.
  /// - parameter html: The HTML to assign.
  public static func content(_ html: String) -> Node {
    .element(
      named: "content:encoded",
      nodes: [Node.raw("<![CDATA[\(html)]]>")])
  }

  /// Assign this item's HTML content using Plot's DSL.
  /// - parameter nodes: The HTML nodes to assign. Will be rendered
  ///   into a string without any indentation.
  public static func content(_ nodes: Node<HTML.BodyContext>...) -> Node {
    .content(nodes.render())
  }
}

extension Node where Context == RSS.ItemContext {
  /// Declare this item's title.
  /// - parameter title: The title to declare.
  public static func title(_ title: String) -> Node {
    .element(named: "title", text: title)
  }
}

// MARK: - Generic content

extension Node where Context: RSSContentContext {
  /// Define a decription for the content.
  /// - parameter text: The content's description text.
  public static func description(_ text: String) -> Node {
    .element(named: "description", text: text)
  }

  /// Define a description for the content as CDATA encoded HTML.
  /// - parameter nodes: The HTML nodes to render as a description.
  public static func description(_ nodes: Node<HTML.BodyContext>...) -> Node {
    .element(named: "description", nodes: [Node.raw("<![CDATA[\(nodes.render())]]>")])
  }

  /// Define the content's canonical URL.
  /// - parameter url: The content's URL.
  public static func link(_ url: URLRepresentable) -> Node {
    .element(named: "link", text: url.string)
  }

  /// Declare which date that the content was published on.
  /// - parameter date: The publishing date.
  /// - parameter timeZone: The time zone of the given `Date` (default: `.current`).
  public static func pubDate(
    _ date: Date,
    timeZone: TimeZone = .current
  ) -> Node {
    let formatter = RSS.dateFormatter
    // formatter.timeZone = timeZone

    let dateString = formatter.string(from: date)
    return .element(named: "pubDate", text: dateString)
  }
}
