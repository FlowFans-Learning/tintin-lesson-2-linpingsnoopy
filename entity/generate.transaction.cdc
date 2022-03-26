import Entity from "./entity.contract.cdc"

transaction(targetAddress: Address) {

  let message: String
  let element: @Entity.Element?

  prepare(account: AuthAccount) {
    // use get PublicAccount instance by address
    
    let targetGeneratorRef = getAccount(targetAddress)
      .getCapability<&Entity.Generator>(/public/ElementGenerator)
      .borrow()
      ?? panic("Couldn't borrow generator reference.")
    
    self.message = "Hello World"
    let feature = Entity.MetaFeature(
      bytes: self.message.utf8,
      raw: self.message
    )

    // save resource
    self.element <- targetGeneratorRef.generate(feature: feature)
        
    self.collectionRef = account.getCapability<&Entity.Collection>(/public/ElementCollection).borrow()
  }

  execute {

    if self.element == nil {
      log("Element of feature<".concat(self.message).concat("> already exists!"))

    } else {

      if(self.collectionRef == nil) {
        self.collection <- Entity.createCollection()
        //Save it
        account.save(<- self.collection, to: /storage/ElementCollection)
        account.link<&Entity.Collection>(/public/ElementCollection, target: /storage/ElementCollection)


      } 
      self.collection.deposit(element: <- self.element!)
    }

  }

  
}
