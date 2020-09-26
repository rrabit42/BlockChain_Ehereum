# Smoke Test  
구축된 테스트 환경에서 테스트가 가능한지 여부를 판단하기 위해 주요 모듈이나 시스템을 간단하게 테스트하는 것  

## Ganache 구동하기  
이전 장에서 설치한 Ganache를 구동하면 자동으로 Mining 모드로 각각 100개 가상 이더를 가진 10개의 계정이 로컬 블록체인 네트워크에 생성된다.  

## Truffle Box  
> mkdir election  
> cd election  

우리 프로젝트의 디렉토리 *election*을 만들고 이동한다.  

> truffle unbox pet-shop  

우리는 빠르게 dApp 구조를 생성하기 위해 **Truffle Box** 라는 dApp 프로젝트 샘플 모음을 활용할 것이다. 우리는 Truffle Box 중 Pet Shop Box를 사용할 것이다.  

### pet shop box로 생성된 폴더 구조  

* **contracts 디렉토리**  
모든 스마트 계약 소스들이 들어가는 디렉토리. 우리는 이미 프로젝트의 migrations를 담당하는 Migration이라는 계약 코드를 가지게 된다.  

* **migrations 디렉토리**  
migration 파일들이 위치하는 디렉토리. 웹 개발 프레임워크에서 데이터베이스의 상태를 변경할 때 migration이 필요한 것과 유사하다.  
스마트 계약을 블록체인에 배포할 때, 이는 블록체인 상태의 업데이트를 의미하기 때문에 migration이 필요하다.  

* **node_modules 디렉토리**  
해당 프로젝트에 필요한 모든 Node dependencies가 존재하는 디렉토리다.  

* **src 디렉토리**  
Client-side 관련 소스들이 위치하는 디렉토리.  

* **test 디렉토리**  
스마트 계약의 Test Code들이 위치하는 디렉토리.  

* **truffle.js 파일**  
Truffle 프로젝트의 주요 설정 내용이 담겨있는 파일.  


+ 튜토리얼에서 추가한 파일 및 폴더  

* contracts : 스마트 계약 작성 폴더, 우리가 개발하고자 하는 dApp의 모든 비지니스 로직이 담긴다.


### 프로젝트 실행  
스마트 컨트랙트와 계약을 배포할 migration 작성 후,  
> truffle migrate  

스마트 계약을 로컬 이더리움 블록체인 환경에 migrtion.  

> truffle console  

테스트를 위해 console 열어서 확인  
콘솔에 접속한 후, 우리가 배포한 스마트계약의 instance를 가져와 우리가 계약에 설정한 candidate 이름을 읽어올 수 있는지 확인해보자.  

Truffle 콘솔에서 아래 코드 입력  
> Election.deployed().then(function(instance) { app = instance})  

위 코드에서 Election은 우리가 작성한 migration 파일의 변수명.  
deployed() 함수로 배포된 계약의 instance를 가져오고 이를 app이라는 변수에 할당해준다.  

> app.candidate()  

그러면 우리는 candidate 변수를 아래와 같이 가져올 수 있게 된다.  


여기까지 우리는 첫번째 스마트 계약을 작성, 블록체인에 배포, 데이터의 검색까지 해보았다.  
