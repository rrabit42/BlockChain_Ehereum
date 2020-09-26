# 후보자(Candidates) 리스트 불러오기  
## Election.sol 수정  
### 후보자 Modeling  
먼저 선거에 출마할 후보자들을 리스트 형태로 화면에 표시.  
이를 위해 우리는 여러 후보자(candidate)들을 저장하고, 각 후보자마다 여러 특징들을 저장해야 한다.  
각 후보자에게는 후보자 번호(id), 이름(name), 득표수(voteCount)라는 속성을 부여하고자 한다.  

```
struct Candidate {
  unit id;
  string name;
  uint voteCount;
}
```  

후보자 모델링은 [Solidity Struct](https://solidity.readthedocs.io/en/v0.4.21/structure-of-a-contract.html?highlight=struct#structure-struct-types)에서 요구하는 대로 만들어졌다. 위 후보자 struct에서는 id를 unsigned integer type, name을 string type, voteCount를 unsigned integer type으로 구성하였다.  

당연하게도,
struct만 정의한다고 candidate 인스턴스가 생기는 것은 아니다.  
스토리지에 후보자들 정보를 저장하기 위해선 우리가 방금 정의한 후보자 struct의 인스턴스를 저장할 수 있는 변수가 하나 필요하다.  

[Solidity mapping](https://solidity.readthedocs.io/en/v0.4.21/types.html?highlight=mapping#mappings)을 활용하자. Solidity에서 mapping 데이터 타입은 array 혹은 hash 집합체로 key-value 형태로 저장된다.  

```
mapping(unit => Candidate) public candidates;
```  

mapping key 값은 unsigned integer 데이터 타입, value값은 우리가 정의한 Candidate 구조체이다.  
이로서 우리는 후보자들의 id로 후보자를 조회할 수 있게 됐다.  

우리가 만든 후보자 mapping은 contract 하위에 위치한 **state variable(Java에서의 전역변수와 유사)**(반대되는 개념: local variable)이기 때문에 새로운 key-value로 언제든지 블록체인 데이터를 기록할 수 있다.  
또한 public으로 선언했기 때문에 getter function을 자동으로 갖게되어 외부에서 함수 호출만으로 조화가 가능하게 된다.  


### 후보자 Counter 선언  
```
uint public candidatesCount;
```  

counter cache state variable을 선언하여 선거에 참여하는 후보자들의 수를 알 수 있다.  

Solidity에서는 mapping의 사이즈를 알 수 없으며 iterator로 전체 데이터를 조회하는 것이 불가능하다.  
왜냐하면 value값이 정의되지 않은 임의의 key값을 mapping으로 조회해도 default 값을 반환해주기 때문이다.(우리 예제에서는 빈 candidate struct를 반환하게 된다.)  


### 후보자 추가하는 함수  
```
function addCandidate(string memory _name) private {
  candidatesCount++;
  candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
}
```  

addCandidate 함수 내부에서는 후보자 수를 나타내는 candidatesCount를 증가시켜주고, 이 증가된 수를 id로 사용하여 후보자 mapping에 새로운 Candidate struct를 할당한다. name은 파라미터로 받은 값, vote count는 초기값으로 0을 준다.  
이 함수는 contract 내부에서만 호출할 수 있도록 **private**으로 선언되었다다.  


#### EVM의 저장 영역  
위에서 파라미터를 선언할 때 memory라는 키워드를 선언했는데, EVM(Ethereum Virtual Machine)에서는 다음과 같은 저장 영역이 존재한다.  

* 비휘발성(non-volatile)  

1. "storage" : contract state variable이 존재하는 영역. 모든 계약마다 각자의 storage가 있다. storage는 함수 간에 공유되며 호출 시에 다소 비싼 사용료(gas)가 필요하다.(32Byte 당 20,000Gas)  
key(32byte)-value(32byte)를 mapping하기 위한 구조이다.  

* 휘발성(volatile)  

2. "stack" : 작은 지역 변수 저장하는데 사용된다. 사용료가 대부분 무료이며,  비용이 거의 들지 않지만, 제한된 양의 값들만 유지할 수 있다.( 저장 개수가 한정적)  

3. "memory" : 임시 값을 저장하는 영역. (외부) 함수를 호출하거나 메모리 연산을 수행할 때 임시로 사용된다.(외부 함수 호출 시 지워짐)  이더리움에서 메세지 호출이 발생할 때마다 깨끗하게 초기화된 메모리 영역이 컨트랙트에 제공된다. (32Byte 당 1 Gas)  


그 외에도 log, Call data, code 등이 있는 것 같다.  


### 후보자 생성  
```
constructor() public {
  addCandidate("Candidate 1");
  addCandidate("Candidate 2");
}
```  

### migrate  
```
truffle migrate --reset
```  

그럼 결과로 아래와 같이 나오는데 완전히 이해해보고 싶다..  
```


Compiling your contracts...
===========================
> Compiling .\contracts\Electon.sol
> Artifacts written to 경로 비밀~~contracts 폴더얌
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang



Starting migrations...
======================
> Network name:    'development'
> Network id:      5777
> Block gas limit: 6721975 (0x6691b7)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    -16진수배열로 뜬다-
   > Blocks: 0            Seconds: 0
   > contract address:    -16진수배열로 뜬다-
   > block number:        5
   > block timestamp:     1601138137
   > account:             -16진수배열로 뜬다-
   > balance:             99.98768342
   > gas used:            191943 (0x2edc7)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00383886 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00383886 ETH


2_deploy_contracts.js
=====================

   Replacing 'Election'
   --------------------
   > transaction hash:    -16진수배열로 뜬다-
   > Blocks: 0            Seconds: 0
   > contract address:    -16진수배열로 뜬다-
   > block number:        7
   > block timestamp:     1601138137
   > account:             -16진수배열로 뜬다-
   > balance:             99.9811848
   > gas used:            282593 (0x44fe1)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00565186 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00565186 ETH


Summary
=======
> Total deployments:   2
> Final cost:          0.00949072 ETH
```

### 테스트 코드 작성  
Ganache는 미리 실행시켜 놓는다.  

JS 파일 내부에 Truffle에서 번들로 제공하는 Mocha Testing framework와 the Chai assertion library를 활용하여 테스트 코드를 작성해보겠다. 우리가 Truffle Console에서 했던 것처럼 client-side에서 조금 전까지 작성한 스마트 계약을 호출할 때를 시뮬레이션 해보자.  

```
> cd ~/election
> truffle test
```  

```
Using network 'development'.

  Contract: Election
    ✓ initializes with two candidates
    ✓ it initializes the candidates with the correct values (69ms)


  2 passing (166ms)
```  

test가 정상적으로 수행됐음을 알 수 있다.  

### Client-Side Application  

기본적으로 우리가 이전 장에서 설치한 Truffle Pet Shop box에서 딸려온 HTML과 Javascript 파일들을 수정해서 만들 예정이다.  

> index.html  
> app.js  

위 코드들을 짧게 해석해보면  
1. web3 세팅: web3.js는 클라이언트 앱에서 블록체인과 연결되기 위한 javascript 라이브러리다. 우리는 "initWeb3"라는 함수로 web3를 설정해줬다.  
2. contracts 초기화: "initContract"라는 함수 내부에서 배포된 스마트 계약 인스턴스를 가져온다. 그리고 contracts와 소통할 수 있도록 만들어줄 몇몇 변수를 할당한다.  
3. Render 함수: render 함수는 페이지에 스마트 계약에서 가져온 데이터들을 보여줄 수 있는 역할을 해준다. 여기서 우리는 스마트 계약에서 생성한 후보자들을 테이블에 렌더링 해주었다. 또한, 현재 블록체인에 연결되어 있는 사용자 계정을 페이지 하단에 보여주도록 하였다.  

우리의 contracts가 migration이 잘 되어 있는지 확인하고  
```truffle migrate --reset```  

개발 서버를 실행하자.  
```npm run dev```  


### Metamask와 Ganache 연결하기  

하단의 '사용자 정의 RPC'를 클릭한 후, Ganache에 연결할 수 있도록 새로운 RPC URL을 설정해주자.
> http://127.0.0.1:7545  


[출처](https://choi3897.github.io/ethereum/ethereum-dapp-5/#)  


