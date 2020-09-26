# BlockChain_Ehereum
[이더리움 투표 Dapp 개발 튜토리얼](https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial)  

## 블록체인을 활용한 투표 Application  
**탈중앙화** 투표 어플리케이션으로 블록체인 상에 배포하여 네트워크에 연결된 누구나 투표에 참여할 수 있다.  
블록체인 상에 배포한 이 app은 모든 트랜잭션 이력이 기록에 남음과 동시에 데이터 조작이 불가능하며, 소스조차 수정이 불가능하기 때문에 사용자들이 믿고 투표할 수 있는 어플리케이션이 될 것이다.  

블록체인은 네트워크와 데이터베이스가 함께 있는 네트워크 종류라고 할 수 있다.  
블록체인은 node라고 불리는 컴퓨터들의 **P2P(peer-to-peer) 네트워크**이며, 모든 데이터와 코드를 블록체인 네트워크 상에서 공유한다.  
따라서 나의 디바이스가 블록체인에 연결되어 있다면, 나는 곧 블록체인 네트워크 상의 노드인 셈이다.  
이렇게 노드가 됨으로써 블록체인 네트워크 상의 모든 컴퓨터 노드들에게 데이터를 전달할 수 있게 된다. 또한, 노드가 되는 순간부터 나 역시 블록체인 사이의 모든 데이터와 코드들의 사본을 갖게 된다.  

블록체인은 중앙 데이터베이스와 달리 모든 트랜잭션 데이터(블록체인 상의 노드들이 서로 공유하고 있음)들의 **블록**이란 기록들의 묶음에 담기게 된다.  
이 블록들은 서로 연결되어 일종의 **공공 장부(public ledger)** 를 형성하게 된다. 이 공공 장부는 블록체인 상의 모든 데이터들을 의미하기도 한다. 이 데이터들은 Hash 암호화로 보호되며 **합의(consensus) 알고리즘**으로 검증(validation)된다.  

블록체인 네트워크 상의 노드들에게 분산되어 있는 모든 데이터 사본들은 서로 똑같아야만 한다. 이 때문에 데이터 조작이 힘들어진다. 전 세계에 퍼져있는 모든 노드들을 조작하는건 매우 어렵기 때문이다.  
이러한 특성이 투표 앱에서 중요한 역할을 한다. 투표자가 투표한 결과가 조작되어서는 안되기 때문이다.  


### 일반유저(투표자) 관점의 블록체인 투표 Dapp  
일반 유저(투표자)들이 우리가 만들고자 하는 앱에서 투표를 하기 위해서는 이더리움의 암호화폐 **이더(Ether)** 가 들어있는 지갑 주소(Wallet address)가 있는 계정(account)이 필요하다.  
투표자들은 투표 앱에 접속 후, 투표권을 행사한 뒤 소정의 트랜잭션 **발생 수수료(Gas)** 를 지불한다. *(블록체인에서 트랜잭션 Read에는 비용이 들지 않지만, 트랜잭션 Write에는 비용이 들게 된다.)*  
투표 트랜잭션이 발생한 즉시, 블록체인 네트워크 상의 일부 노드들이 해당 트랜잭션을 블록에 포함시키며 트랜잭션을 완료시키게 된다. 이들이 바로 **채굴자(Miner)** 이다. 해당 트랜잭션을 완료시킨 채굴자는 투표자가 투표 시 지불했던 수수료(Gas)를 보상으로 받게 된다.  

### 스마트 계약  
우리는 **스마트 계약(Smart Contract)** 코드를 짜게 될 것이다.  
그리고 이더리움 블록체인은 우리가 짠 코드를 **Ethereum Virtual Machine(EVM)** 으로 실행할 수 있게 구성되어 있다.  

스마트 계약은 실제 우리의 어플리케이션이 돌아가는 모든 비지니스 로직이라고 할 수 있다.  
스마트 계약은 블록체인에 데이터를 쓰고 읽는 역할을 하며, 비지니스 로직들을 실행하는 역할도 할 수 있다. 이는 Javascript와 유사한 **Solidity**라고 하는 프로그래밍 언어로 작성된다.  

블록체인 상의 스마트 계약 함수(function)들은 웹에서의 Microservice와 유사하다. 공공 장부(public ledger)가 블록체인의 데이터베이스 계층이라면, 스마트 계약(Smart Contract)들은 실시간으로 data에 트랜잭션을 발생시키는 비즈니스 로직이다.  

스마트 계약이라고 불리는 또 다른 이유는, 참여자들이 계약(covenant) 혹은 동의(agreement) 기능을 하기 때문이다. 우리 투표 Dapp을 예로 들면  
1) 나의 투표가 정확하게 카운트 되고  
2) 다른 이들의 투표도 한 번만 카운트 되며  
3) 가장 많은 표를 받은 후보자가 선거에서 승리한다.  

라는 내용을 사용자 간에 서로 합의한 셈이다.  


## 투표 Dapp 구조  
![dapp_diagram](https://user-images.githubusercontent.com/46364778/94341527-ff8ae180-0044-11eb-8184-c841c0e1d8ff.png)  

- 우리는 HTML, CSS, JS로 구성된 전통적인 Front-end Client를 작성할 것이다. 이 Client는 우리가 설치할 Local Ethereum Blockchain에 연결될 것이다.  

- 우리의 투표 Dapp과 관련된 모든 비즈니스 로직들은 Solidity로 작성된 Election이라고 하는 스마트 계약에 작성할 것이다.  

- 이 스마트 계약은 우리가 설치한 Local Ethereum Blockchain에 배포하여 Accounts들이 투표할 수 있도록 할 것이다.  

- 클라이언트 측에서는 후보자(candidate)들의 리스트를 각각 이들의 id, 이름, 득표수와 함께 테이블 형태로 보여줄 것이다.  
- 우리가 지지하는 후보에 투표권을 행사할 수 있는 form을 만들 것이다.  
- 우리가 현재 블록체인에 연결되어 있는 계정 정보를 아래에 보여줄 것이다.  

## 개발 환경 설정  
### Node Package Manager(NPM)  
> apt-get install nodejs  
> node -v  

### Truffle Framework  
> npm install -g truffle  
> truffle --version  

이더리움 블록체인에서 Dapp(decentralized APplicatoin, 탈중앙화 어플리케이션)을 쉽게 만들게 도와주는 프레임워크다.  

Truffle Framework는 Solidity로 스마트 계약을 작성할 수 있는 툴들을 제공해준다.  
그리고 Truffle은 우리가 작성한 스마트 계약의 테스트와 블록체인으로의 배포를 도와준다.  
또한, 폴더 구조를 미리 만들어 client-side application 소스코드의 대략적인 아키텍처도 미리 잡아 준다.  

### Ganache  
[Download Ganache Link](https://www.trufflesuite.com/ganache)  

Local in-memory Blockchain 환경이다.  
Ganache는 10개의 external accounts 주소에 각각 가상의 100 디어(Ether)가 들어있는 로컬 이더리움 블록체인이다.  

### Metamask  
[Metamask extension for Google Chrome](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en)  

Metamask는 블록체인을 사용하기 위한(블록체인 네트워크에 접속하기 위한) 도구 중 하나이다.  
Metamask는 Ganache로 구성한 로컬 이더리움 블록체인 네트워크에 Ganache에서 생성된 개인 계정으로 접속할 수 있도록 해주고,  
우리가 작성한 스마트 계약을 실행해준다.(Transaction 발생 비용 Gas 지불)  

### Solidity  
truffle로 개발하기 떄문에 solc와 같은 Solidity COmpiler를 별도 설치하지 않아도 된다.  
스마트 계약 작성 시에 Solidity 버전을 명시하게 되는데, 원작자는 solidity^0.4.23 버전을 사용했지만 일부 truffle 호환성 때문에 최신거 사용하길!  

### IDE  
Visual Studio Code(vscode)  














