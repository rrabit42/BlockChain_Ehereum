// Electon.sol 이라는 스마트 계약 기초 뼈대 코드를 작성했다.
// 이 코드가 블록체인에 배포될 수 있는지 확인하려면 먼저 migration이 필요하다.

var Election = artifacts.require("./Election.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
};