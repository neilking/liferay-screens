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


class DDLFormUploadDocumentInteractor: ServerOperationInteractor {

	typealias OnProgress = LiferayDDLFormUploadOperation.OnProgress

	let filePrefix: String
	let repositoryId: Int64
	let folderId: Int64
	let document: DDLFieldDocument

	let onProgressClosure: OnProgress?

	var resultResponse: [String:AnyObject]?


	init(screenlet: BaseScreenlet?,
			document: DDLFieldDocument,
			onProgressClosure: OnProgress) {

		let formScreenlet = screenlet as! DDLFormScreenlet

		self.filePrefix = formScreenlet.filePrefix
		self.folderId = formScreenlet.folderId
		self.repositoryId = (formScreenlet.repositoryId != 0)
			? formScreenlet.repositoryId
			: (formScreenlet.groupId != 0)
				? formScreenlet.groupId
				: LiferayServerContext.groupId

		self.document = document
		self.onProgressClosure = onProgressClosure

		super.init(screenlet: screenlet)
	}

	init(filePrefix: String,
			repositoryId: Int64,
			groupId: Int64,
			folderId: Int64,
			document: DDLFieldDocument) {

		self.filePrefix = filePrefix
		self.folderId = folderId
		self.repositoryId = (repositoryId != 0)
			? repositoryId
			: (groupId != 0)
				? groupId
				: LiferayServerContext.groupId

		self.document = document
		self.onProgressClosure = nil

		super.init(screenlet: nil)
	}

	override func createOperation() -> LiferayDDLFormUploadOperation {
		let operation = LiferayDDLFormUploadOperation()

		operation.document = self.document
		operation.filePrefix = self.filePrefix
		operation.folderId = self.folderId
		operation.repositoryId = self.repositoryId
		operation.onUploadedBytes = self.onProgressClosure

		return operation
	}

	override func completedOperation(op: ServerOperation) {
		if let lastErrorValue = op.lastError {
			document.uploadStatus = .Failed(lastErrorValue)
		}
		else if let uploadOp = op as? LiferayDDLFormUploadOperation {
			self.resultResponse = uploadOp.uploadResult
			document.uploadStatus = .Uploaded(uploadOp.uploadResult!)
		}
	}

}
