# 初识 Cadence - 账户、交易、模拟器与本地开发

## 基础题

- Q1 事件添加

修改 `entity.contract.cdc` 合约，添加两个事件，并在合适的地方进行发送。

```text
pub event ElementGenerateSuccess(hex: String)
pub event ElementGenerateFailure(hex: String)
```

- Q2 收藏包

修改 `entity.contract.cdc` 为我们的 `Entity` 合约创建一个 `Collection` 资源，允许保存生成的 `Element` 资源。  
注意：必须在合约中创建资源。

```cadence
// 实现一个新的资源
pub resource Collection {
  pub fun deposit(element: @Element)
}
// 实现一个创建方法
pub fun createCollection(): @Collection
```

新增一个交易 `createCollection.transactions.cdc`，创建 `Collection` 资源并保存到指定的路径。

```cadence
import Entity from "./entity.contract.cdc"

// 为交易的发起者创建一个 Element 收藏包
transaction {}
```

- Q3 收集和展示

修改 `generate.transaction.cdc` 合约，需要实现以下功能：

- 检测交易发起人是否有 `Element` 的 `Collection`，若不存在则创建一个。
- 将生成的 `Element` 保存到交易发起人的收藏包中。
- 若无法生成 `Element`，交易正常结束。

创建 `displayCollection.script.cdc`, 需要实现以下功能：

- 返回特定账户地址收藏包中 `Element` 的列表（以合适的 `Struct` 来进行返回）
- 若没有收藏包，则返回 nil

## 挑战题

根据描述，补充资源定义并编写交易。

补充 `Collection` 资源定义：

- 在 `Collection` 资源中实现 `withdraw` 方法，传入参数 `hex: String`， 返回指定的 `Element`

实现交易：

- 实现 `transfer` 交易，从 A 账户的 `Collection` 中提取 `Element` 转移到 B 账户
