
import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    private var messages: [ModelMessage] = []
    private var messageListener: ListenerRegistration?
    let photoButton = InputBarButtonItem(type: .system)
    private let user: ModelUser
    private let chat: ModelChat
    var image: UIImage = #imageLiteral(resourceName: "camera")
    private var isMicro = false
    
    init(user: ModelUser, chat: ModelChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        title = chat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.8371705486, green: 1, blue: 0.8215421855, alpha: 1)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { (result) in
            switch result {
                
            case .success(var message):
                if let url = message.downloadUrl {
                    StorageServeces.shared.downloadPhoto(url: url) { [weak self](result) in
                        guard let self = self else { return }
                        switch result {
                            
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.createAlert(title: "Ошибка",
                                             message: error.localizedDescription,
                                             completion: nil)
                        }
                    }
                } else {
                    self.insertNewMessage(message: message)
                }
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        })
    }
    
    private func insertNewMessage(message: ModelMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        print(messages.count)
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}

// MARK: - ConfigureMessageInputBar
extension ChatViewController {
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.8371705486, green: 1, blue: 0.8215421855, alpha: 1)
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureSupportButton()
    }
    
    
    
    @objc private func imagePicker() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Фото", style: .default) { _ in
            picker.sourceType = .photoLibrary
            self.present(picker,
                         animated: true,
                         completion: nil)
            
        }
        
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            picker.sourceType = .camera
            self.present(picker,
                         animated: true,
                         completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Назад", style: .destructive, handler: nil)
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    func configureSupportButton() {
        photoButton.setImage(image, for: .normal)
        photoButton.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
        photoButton.tintColor = .gray
        photoButton.setSize(CGSize(width: 30, height: 30), animated: true)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([photoButton],
                                          forStack: .left,
                                          animated: true)
        
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 1
        gesture.allowableMovement = 0
        gesture.addTarget(self, action: #selector(changeToAudio))
        photoButton.addGestureRecognizer(gesture)
    }
    
    @objc private func changeToAudio() {
        if isMicro {
            print("true")
            image = #imageLiteral(resourceName: "audio voice")
            isMicro = false
            
        } else {
            print("false");
            image = #imageLiteral(resourceName: "camera")
            isMicro = true
        }
        
        self.photoButton.setImage(self.image, for: .normal)
        
        
    }
    
    private func sendPhotos(image: UIImage) {
        StorageServeces.shared.uploadPhoto(image: image,
                                           chat: chat) { (result) in
                                            switch result {
                                                
                                            case .success(let url):
                                                var image = ModelMessage(image: image,
                                                                         user: self.user)
                                                
                                                image.downloadUrl = url
                                                FireStoreService.shared.sendMessage(chat: self.chat,
                                                                                    message: image) { (result) in
                                                                                        switch result {
                                                                                            
                                                                                        case .success():
                                                                                            self.messagesCollectionView.scrollToBottom()
                                                                                        case .failure(let error):
                                                                                            self.createAlert(title: "Ошибка",
                                                                                                             message: error.localizedDescription, completion: nil)
                                                                                        }}
                                            case .failure(let error):
                                                self.createAlert(title: "Ошибка",
                                                                 message: error.localizedDescription,
                                                                 completion: nil)
                                            }
        }
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "sendButton"), for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item) % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = ModelMessage(user: user, content: text)
        
        FireStoreService.shared.sendMessage(chat: chat, message: message) { (result) in
            switch result {
            case .success:
                self.messagesCollectionView.scrollToBottom()
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        }
        
        inputBar.inputTextView.text = ""
    }
}

extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}




extension ChatViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        sendPhotos(image: image)
    }
}

