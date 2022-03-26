import Entity from "./entity.contract.cdc"

transaction {
  prepare(account: AuthAccount) {
      let collection <- Entity.createCollection()
         account.save(<-collection, to: /storage/ElementCollection)
    account.link<&Entity.Collection>(
        /public/ElementCollection, 
        target:/storage/ElementCollection)
  }

}