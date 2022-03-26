pub contract Entity {
  // 元特征
  pub struct MetaFeature {

    pub let bytes: [UInt8]
    pub let raw: String?

    init(bytes: [UInt8], raw: String?) {
      self.bytes = bytes
      self.raw = raw
    }
  }

  // 元要素
  pub resource Element {

    pub let feature: MetaFeature
    
    init(feature: MetaFeature) {
      self.feature = feature
    }
  }

  // 特征收集器
  pub resource Generator {

    pub let features: {String: MetaFeature}

    init() {
      self.features = {}
    }

    pub fun generate(feature: MetaFeature): @Element? {
      // 只收集唯一的 bytes
      let hex = String.encodeHex(feature.bytes)

      if self.features.containsKey(hex) == false {
        let element <- create Element(feature: feature)
        self.features[hex] = feature
        return <- element
      } else {
        return nil
      }
    }
  }

  init() {
    // 保存到存储空间
    self.account.save(
      <- create Generator(),
      to: /storage/ElementGenerator
    )
    // 链接到公有空间
    self.account.link<&Generator>(
      /public/ElementGenerator, // 共有空间
      target: /storage/ElementGenerator // 目标路径
    )

    self.account.save(
      <- self.createCollection(),
      to: /storage/LocalEntityCollection
    )
    self.account.link<&Collection>(
      /public/LocalEntityCollection,
      target: /storage/LocalEntityCollection
    )
  }

  pub event ElementGenerateSuccess(hex: String)
  pub event ElementGenerateFailure(hex: String)

  // 实现一个新的资源
  pub resource Collection {
    pub var elements: @[Element]

    init() {
      self.elements <- []
    }

    destroy() {
        destroy self.elements
    }
/*
    pub fun getAllElements() {
      var result: [String] = []
      for record in self.elements {
        result.append(record.raw)
       }
    }*/

    pub fun deposit(element: @Element) {

      log(element.feature.raw)  
      let hex = String.encodeHex(element.feature.bytes)
    //  if self.elements.containsKey(String.encodeHex(element.feature.bytes)) {
    //    log("The element already exists in the collection")
    //    emit ElementGenerateFailure(hex: hex.concat(" already exists "))
    //    destroy element
    //  } else {
        log("deposit the element ".concat(element.feature.raw!))
        self.elements.append(<- element)
        emit  ElementGenerateSuccess(hex: hex.concat(" deposit successfully "))
   //   }
    }

    pub fun withdraw(hex: String): @Element? {
      var index = 0
      while index < self.elements.length {
        let currentHex = String.encodeHex(self.elements[index].feature.bytes)

        if currentHex == hex {
          let element <- self.elements.remove(at: index)
          return <- element
        }
        index = index +1
      }
      return nil
    }

    pub fun display():[Entity.MetaFeature] {
      var features: [Entity.MetaFeature] = []
      var index = 0
      while index < self.elements.length {
        features.append(self.elements[index].feature)
        index = index+1
      }
      return features;
    }
    
    pub fun transfer(acc1: AuthAccount, acc2: AuthAccount) {
       
    }

  }


  // 实现一个创建方法
  pub fun createCollection(): @Collection {
    let collection <- create Collection()

    log("create collection from contract")
    return <- collection

  }

}
