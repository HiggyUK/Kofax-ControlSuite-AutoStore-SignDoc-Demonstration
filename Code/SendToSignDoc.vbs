Sub SendToSignDocs_OnLoad
	
	Set SignDoc = CreateObject("AutoStoreLibrary.SignDoc")
		
	' Authenticate and Get Token
	
	EKOManager.StatusMessage "Authenticating User to SignDocs"
	
	authToken = ""
	server = "https://[SIGNDOC URL]/cirrus"
	userName = "[USERNAME]"
	accountID = "[ACCOUNT ID]"
	userPassword = "[PASSWORD]"
	
	authToken = SignDoc.GetAuthenticationToken(server, userName, userPassword, accountID)
	
	EKOManager.StatusMessage "Authentication Token: " & authToken

	' Create the Package
	
	EKOManager.StatusMessage "Creating Package"

	PackageID = SignDoc.CreatePackage(PackageName, "PACKAGE", authToken, server)
	
	EKOManager.StatusMessage "Package ID: " & PackageID
	
	' Create the Signer
	
	EKOManager.StatusMessage "Creating Signer"
	
	SignerID = SignDoc.AddSigner(server, authToken, PackageID, SignerName, SignerEmail, "SIGNER")
	
	EKOManager.StatusMessage "Signer ID: " & SignerID
	
	' Add the Document
	
	EKOManager.StatusMessage "Adding Document"
	
	
	Set KnowledgeDocument = KnowledgeObject.GetFirstDocument()	

	FileName = KnowledgeDocument.GetFileName
	FilePath = KnowledgeDocument.FilePath
		
	EKOManager.StatusMessage "FileName: " + FileName
	EKOManager.StatusMessage "FilePath: " + FilePath
		
	KnowledgeDocument.Visible = False

	DocumentID = SignDoc.AddDocument(server, authToken, PackageID, FilePath, FileName, "PDF", "Customer Service Agreement", "Customer Service Agreement", "Please Sign")

	EKOManager.StatusMessage "Document ID: " & DocumentID
	
	' Add the Signature Field
	
	EKOManager.StatusMessage "Adding Signature Field"
	
	'AddSignatureField(ByVal serverAddress, ByVal authToken, ByVal PackageID, ByVal DocumentID, ByVal fieldName, ByVal alternativeName, ByVal SignerID, ByVal RequiredField, ByVal ReadOnlyField, ByVal SignatureDescription, ByVal WidgetIndex, ByVal WidgetPageNumber, ByVal WidgetTop, ByVal WidgetBottom, ByVal WidgetLeft, ByVal WidgetRight)
	
	FieldID = SignDoc.AddSignatureField(server, authToken, PackageID, DocumentID, "Customer Signature", "Customer Signature", SignerID, "true", "false", "Customer Signature Field", 0, 1, 145, 104, 119, 269)
	
	EKOManager.StatusMessage "Field ID: " & FieldID
	' Send Package
	
	EKOManager.StatusMessage "Sending Package"
	
	' SchedulePackage(ByVal serverAddress, ByVal authToken, ByVal PackageID)

	SendPackage = SignDoc.SchedulePackage(server, authToken, PackageID)
	
	If SendPackage = "200" Then
		route = "Success"
	Else
		route = "Failure"
	End If
	
	Set PTopic = KnowledgeContent.GetTopicInterface
	If Not(PTopic Is Nothing) Then
		PTopic.Replace "~USR::%Route%~", route
	End If
	
End Sub

Sub SendToSignDocs_OnUnload

End Sub
