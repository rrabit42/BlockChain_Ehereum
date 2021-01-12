# 투표기능 추가하기  
이제 우리의 선거 dAPP에 투표 기능을 추가해보자.
## Election.sol 수정  
* 이미 투표한 accounts들을 구분할 수 있는 ```voters```라는 이름의 mapping 변수를 선언한다.  
```
contract Election {
    // ...

    // Store accounts that have voted
    mapping(address => bool) public voters;

    // ...
}
```  

* ```vote``` 함수도 추가해보자.  
```
contract Election {
    // ...

    // Store accounts that have voted
    mapping(address => bool) public voters;

    // ...

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender], "This Voter has already voted!");

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount, "There is no such candidate");

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }
}
```  

```vote```함수의 핵심 기능은 ```candidates``` mapping 변수에서 ```Candidate struct```를 읽어와 후보자의 투표 수를 증가시키는 것이다.  
이 외에도 아래와 같은 특징이 있다.  
> 1. ```vote```함수는 unsigned integer 타입의 후보자 id를 파라미터로 받는다.  
> 2. 외부 account에서 해당 함수를 호출하고자 하기 때문에 **public**으로 선언하였다.  
> 3. 투표를 한 account는 위에서 우리가 선언한 ```voters```라는 mapping 변수에 추가한다. 이를 통해 이미 투표에 참여한 투표자를 걸러낼 수 있게 된다.  
우리는 함수를 호출한 account를 Solidity에서 제공하는 글로벌 변수(global variable) ```msg.sender```를 통해 가져올 수 있다.  
> 4. 본 함수는 ```require```라는 구문으로 특정 조건에 만족하지 않으면 실행을 중지시키고 있다.  
> - 첫번째 require: 투표자가 이전에 투표하지 않았음을 확인하는 부분이다. 함수를 호출한 account인 ```msg.sender```를 ```voters``` mapping에서 읽어옴으로써 확인이 가능하다.  
> - 두번째 require: 파라미터로 넘어온 후보자 ID(candidateId)가 유효한지 확인하는 부분이다. 반드시 0보다 크고 전체 후보자 수보다는 같거나 작아야 한다.  


## 투표 함수 Test하기  
우리가 방금까지 작성한 투표 기능을 테스트하기 위해서 ```election.js``` 테스트 파일에 코드를 추가해보자.  
* ```vote```함수가 후보자의 투표수를 증가시키는지 테스트  
* 투표자가 투표했을 때, ```voters``` mapping 변수에 추가되는지 테스트  
```
it("allows a voter to cast a vote", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      candidateId = 1;
      return electionInstance.vote(candidateId, { from: accounts[0] });
    }).then(function(receipt) {
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

* 다음으로, 우리가 require로 Validation 했던 부분을 테스트  
```
it("throws an exception for invalid candidates", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.vote(99, { from: accounts[1] })
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
      return electionInstance.candidates(1);
    }).then(function(candidate1) {
      var voteCount = candidate1[2];
      assert.equal(voteCount, 1, "candidate 1 did not receive any votes");
      return electionInstance.candidates(2);
    }).then(function(candidate2) {
      var voteCount = candidate2[2];
      assert.equal(voteCount, 0, "candidate 2 did not receive any votes");
    });
  });
```  

* 다음으로, 중복 투표를 방지하는지 확인하는 테스트  
```
it("throws an exception for double voting", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      candidateId = 2;
      electionInstance.vote(candidateId, { from: accounts[1] });
      return electionInstance.candidates(candidateId);
    }).then(function(candidate) {
      var voteCount = candidate[2];
      assert.equal(voteCount, 1, "accepts first vote");
      // Try to vote again
      return electionInstance.vote(candidateId, { from: accounts[1] });
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
      return electionInstance.candidates(1);
    }).then(function(candidate1) {
      var voteCount = candidate1[2];
      assert.equal(voteCount, 1, "candidate 1 did not receive any votes");
      return electionInstance.candidates(2);
    }).then(function(candidate2) {
      var voteCount = candidate2[2];
      assert.equal(voteCount, 1, "candidate 2 did not receive any votes");
    });
  });
```  
위 테스트 시나리오에서는 첫번째로 아직 투표하지 않은 투표자로 최초 투표를 시도한다. 그 뒤로 다시 투표를 시도해본다.  
이제 여기까지 짜여진 테스트 코드로 테스트를 돌려보자.  
> truffle test  


# Client에서 투표하기  
## index.html 수정  
* table 요소 아래에 다음과 같은 코드를 추가한다.  
```
<form onSubmit="App.castVote(); return false;">
  <div class="form-group">
    <label for="candidatesSelect">Select Candidate</label>
    <select class="form-control" id="candidatesSelect">
    </select>
  </div>
  <button type="submit" class="btn btn-primary">Vote</button>
  <hr />
</form>
```  
1. 빈 select 요소를 가지고 있는 form을 만든다. select 요소에는 우리 smart contract에서 제공하는 후보자들을 ```app.js```에서 받아와 채워 넣을 것이다.  
2. form의 ```onSubmit``` 핸들러에는 ```castVote```함수를 호출하도록 하였다. 이 또한 ```app.js```에서 정의할 것이다.

## app.js 수정  

* smart contract로부터 모든 후보자 리스트를 가져와 form의 select 요소에 채워넣는다.  
* 그 후, 이미 투표한 account라면 form을 숨김처리하여 중복투표를 못하게 막는다.  
* app.js의 render 함수를 아래와 같이 작성한다.  
```
render: function() {
  var electionInstance;
  var loader = $("#loader");
  var content = $("#content");

  loader.show();
  content.hide();

  // Load account data
  web3.eth.getCoinbase(function(err, account) {
    if (err === null) {
      App.account = account;
      $("#accountAddress").html("Your Account: " + account);
    }
  });

  // Load contract data
  App.contracts.Election.deployed().then(function(instance) {
    electionInstance = instance;
    return electionInstance.candidatesCount();
  }).then(function(candidatesCount) {
    var candidatesResults = $("#candidatesResults");
    candidatesResults.empty();

    var candidatesSelect = $('#candidatesSelect');
    candidatesSelect.empty();

    for (var i = 1; i <= candidatesCount; i++) {
      electionInstance.candidates(i).then(function(candidate) {
        var id = candidate[0];
        var name = candidate[1];
        var voteCount = candidate[2];

        // Render candidate Result
        var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
        candidatesResults.append(candidateTemplate);

        // Render candidate ballot option
        var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
        candidatesSelect.append(candidateOption);
      });
    }
    return electionInstance.voters(App.account);
  }).then(function(hasVoted) {
    // Do not allow a user to vote
    if(hasVoted) {
      $('form').hide();
    }
    loader.hide();
    content.show();
  }).catch(function(error) {
    console.warn(error);
  });
}
```  

* form이 submit됐을 때 호출될 castVote 함수도 작성  
```
castVote: function() {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.Election.deployed().then(function(instance) {
      return instance.vote(candidateId, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  }
```  

* 먼저 form으로부터 ```candidateId```를 가져온 뒤, smart contract의 ```vote```함수를 호출한다.  
이때 candidateI와 함께 현재 account를 함수의 ```form```의 메타데이터에 넣어서 호출한다.  
이 호출은 비동기이며, 함수 호출을 한 뒤 페이지 내용을 숨기고 로딩 화면을 띄운다.  
투표가 기록되면 반대로 페이지 내용을 다시 유저에게 보여준다.  


# 구동해보기  
* Election.sol의 변경사항을 반영하기 위해 다시 migrate 하고 재실행 해주자.  
> truffle migrate --reset  
> npm run dev  

* 아래와 같은 화면이 뜨면 성공  
<img width="720" alt="1" src="https://user-images.githubusercontent.com/46364778/104346185-78557100-5542-11eb-98bc-dbb843024c2c.png">  


* 기호1번 후보자에게 한번 투표해보자. ```Vote``` 버튼을 누르면 아래와 같은 팝업이 나타남.  
팝업이 나타나지 않으면 Metamask를 클릭해서 보자.  

* ```승인```버튼을 누르면 트랜잭션이 전송되고 투표가 완료된다. Metamask의 히스토리에서 트랜잭션 로그를 확인할 수 있다.

* 그러나 투표를 완료해도 이상하게 loading 화면만 계속 떠있다.  
다음 장에서 이 현상을 해결해줄 수 있도록 투표가 기록되면 페이지를 **리프레쉬**해주는 기능을 추가해보자.  



[출처](https://choi3897.github.io/ethereum/ethereum-dapp-6/#)  


