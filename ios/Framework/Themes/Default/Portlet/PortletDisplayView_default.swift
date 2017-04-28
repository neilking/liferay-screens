/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit
import WebKit


open class PortletDisplayView_default: BaseScreenletView, PortletDisplayViewModel, WKUIDelegate,
	WKScriptMessageHandler {


	//MARK: Public properties

	open var webView: WKWebView?


	//MARK: BaseScreenletView

	override open var progressMessages: [String: ProgressMessages] {
		return [
			BaseScreenlet.DefaultAction : [
					.working : LocalizedString(
						"default", key: "portletdisplay-loading-message", obj: self),
					.failure : LocalizedString(
						"default", key: "portletdisplay-loading-error", obj: self)
			]
		]
	}

	override open func onCreated() {
		super.onCreated()

		webView = WKWebView(frame: self.frame)

		webView?.injectCookies()
		webView?.injectViewportMetaTag()
		webView?.uiDelegate = self

		addWebView()
	}

	override open func createProgressPresenter() -> ProgressPresenter {
		return DefaultProgressPresenter()
	}


	//MARK: PortletDisplayViewModel

	open var portletUrl: URL? {
		didSet {
			if let url = portletUrl {
				webView?.load(URLRequest(url: url))
			}
		}
	}


	public var injectedJsFile: String? {
		didSet {
			if let js = injectedJsFile {
				webView?.loadJs(file: js)
			}
		}
	}

	public var scriptHandler: String? {
		didSet {
			if let script = scriptHandler {
				webView?.configuration.userContentController.add(self, name: script)
			}
		}
	}


	//MARK: WKUIDelegate

	public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		completionHandler()
	}


	//MARK: WKScriptMessageHandler

	public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		(screenlet as? PortletDisplayScreenlet)?.portletDisplayDelegate?.screenlet?(
			screenlet as! PortletDisplayScreenlet, onScriptMessageHandler: message.name,
				onScriptMessageBody: message.body as! String)
	}


	//MARK: Public methods

	open func addWebView() {
		webView?.translatesAutoresizingMaskIntoConstraints = false

		addSubview(webView!)

		let top = NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal,
		                             toItem: self, attribute: .top, multiplier: 1, constant: 0)
		let bottom = NSLayoutConstraint(item: webView!, attribute: .bottom, relatedBy: .equal,
		                                toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
		let leading = NSLayoutConstraint(item: webView!, attribute: .leading, relatedBy: .equal,
		                                 toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let trailing = NSLayoutConstraint(item: webView!, attribute: .trailing, relatedBy: .equal,
		                                  toItem: self, attribute: .trailing, multiplier: 1, constant: 0)

		NSLayoutConstraint.activate([top, bottom, leading, trailing])
	}
}