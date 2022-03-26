import Entity from "./entity.contract.cdc"
pub fun main(account:Address) {

  let acc = getAccount(account)

  let collectionRef = acc.getCapability<&Entity.Collection>(/public/ElementCollection).borrow()

  if collectionRef != nil {
    for feature in collectionRef!.display() {
      log(feature.raw);
    }
  }

}