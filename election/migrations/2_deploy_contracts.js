// Electon.sol 이라는 스마트 계약 기초 뼈대 코드를 작성했다.
// 이 코드가 블록체인에 배포될 수 있는지 확인하려면 먼저 migration이 필요하다.

var Election = artifacts.require("./Election.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
};

// 1. 먼저 우리가 작성한 계약을 요청하여 "Election" 이라는 변수에 할당한다.
// 2. 그 후, 이 변수를 배포된 계약의 manifest에 추가하여 우리가 migratinos를 실행할 때 우리 계약이 배포되게끔 해준다.