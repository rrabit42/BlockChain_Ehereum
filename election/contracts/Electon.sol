pragma solidity 0.5.16;

contract Election {
  // Read, Write candidate
  string public candidate;

  // Constructor
  constructor() public{
    candidate = "Candidate 1";
  }
}

// 1. 스마트 계약은 solidty version을 선언하는 pragma solidity 구문으로 시작해야 한다.
// 2. "contract" 키워드로 계약 이름을 정의한다.
// 3. candidate 이름을 저장할 strinㅎ 변수를 정의한다. public으로 설정하게 되면 solidity가 공짜로 해당 변수 내용을 조회할 수 있는 getter 함수를 제공해준다.
// 4. contructor 함수는 스마트 계약이 블록체인에 배포될 때 최초에 한번 실행된다. 우리가 미리 세팅하고자 하는 변수는 migration을 통해 블록체인에 저장된다.