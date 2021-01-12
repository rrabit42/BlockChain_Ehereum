# Events 감지하기
투표가 될 때마다 발생하는 이벤트 트리거를 만들자.  
## Election.sol 수정  
* 이벤트 트리거를 통해 account가 투표를 완료했을 때 클라이언트 쪽을 업데이트하거나 리프레쉬하도록 해보자.  
```
contract Election {
    // ...
    event votedEvent (
        uint indexed _candidateId
    );
    // ...
}
```  

* 그리고 ```vote```함수 내에 방금 만든 ```votedEvent```를 트리거로 넣어준다.  
```
function vote(uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender],"This Voter has already voted!");

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount, "There is no such candidate");

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidatte vote Count
        candidates[_candidateId].voteCount++;

        //triger voted event
        emit votedEvent(_candidateId);
    }
```  

## Test 코드 작성하기  
```
it("allows a voter to cast a vote", function() {
  return Election.deployed().then(function(instance) {
    electionInstance = instance;
    candidateId = 1;
    return electionInstance.vote(candidateId, { from: accounts[0] });
  }).then(function(receipt) {
    assert.equal(receipt.logs.length, 1, "an event was triggered");
    assert.equal(receipt.logs[0].event, "votedEvent", "the event type is correct");
    assert.equal(receipt.logs[0].args._candidateId.toNumber(), candidateId, "the candidate id is correct");
    return electionInstance.voters(accounts[0]);
  }).then(function(voted) {
    assert(voted, "the voter was marked as voted");
    return electionInstance.candidates(candidateId);
  }).then(function(candidate) {
    var voteCount = candidate[2];
    assert.equal(voteCount, 1, "increments the candidate's vote count");
  })
});
```  

## app.js 수정하기  

* 이제 client 쪽 소스를 수정해서 ```voted``` 이벤트를 감지할 수 있도록 해주자.  
* 그리고 이 이벤트의 트리거가 발동되는 즉시 페이지를 새로고침해주자.  
* ```app.js``` 소스에 ```listenForEvents```함수를 추가하면 된다.  
```
// Listen for events emitted from the contract
  listenForEvents: function(){
    App.contracts.Election.deployed().then(function(instance){
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask

      instance.votedEvent({},{
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event){
        console.log("event triggered", event);
        // Reload when a new vote is recorded
        App.render();
      })
    })
  },
```  
위 함수를 해석해보자면:  
* 먼저, contract의 ```votedEvent```함수를 호출해서 voted event를 subscribe한다. 이때 블록체인 상의 모든 이벤트를 확인하겠다는 메타데이터(fromBlock, toBlock)을 함께 넘겨준다.  
* 그 후, 이 이벤트를 ```watch```한다. 이 안에서 ```votedEvent```가 발생했다는 로그를 기록한 후, 페이지 내용을 다시 렌더링 함으로써 새로고침 효과를 준다.  
이를 통해 투표 결과가 반영된 새로운 테이블 내용들을 확인할 수 있을 것이다.  

* 마지막으로, 계약을 initialize할 때마다 이 함수를 부를 수 있도록 init Contract 함수 맨 아래에 다음과 같이 추가해주자.  
```  
initContract: function() {
  $.getJSON("Election.json", function(election) {
    // Instantiate a new truffle contract from the artifact
    App.contracts.Election = TruffleContract(election);
    // Connect provider to interact with contract
    App.contracts.Election.setProvider(App.web3Provider);

    App.listenForEvents();

    return App.render();
  });
}
```

이제 드디어 클라이언트를 통해서 투표하고, 투표 결과를 실시간으로 확인할 수 있게 되었다!  
참고로 event를 trigger하는데 몇 초가 걸릴수도 있다.  
그래도 event가 계속 안보인다면 크롬을 다시 리스타트해보자.  
이는 메타마스크에 존재하는 일부 오류가 원인이기 때문에 크롬을 리스타트해주면 해결되는 경우가 많다.  

이벤트까지 완료됐다면 이제 우리는 이더리움 블록체인에서 동작하는 풀스택 탈중앙화 어플리케이션(dApp)을 성공적으로 만들게 된 것이다.

[출처](https://choi3897.github.io/ethereum/ethereum-dapp-7/#)  


