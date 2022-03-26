import Entity from "./entity.contract.cdc"

transaction(recipient: Address, string: String) {
    let senderCollectionRef: &Entity.Collection
    let receiverCollectionRef: &Entity.Collection

    prepare(sender: AuthAccount) {
        self.senderCollectionRef = sender.getCapability<&Entity.Collection>(/public/ElementCollection)
            .borrow() ?? panic("sender collection ref error")
        
        self.receiverCollectionRef = sender.getCapability<&Entity.Collection>(/public/ElementCollection)
            .borrow() ?? panic("receiver collection ref error")
    }

    execute {
        let element <- self.senderCollectionRef.withdraw(hex:"Hello world")
        self.receiverCollectionRef.deposit(element: <-element!)
    }

}