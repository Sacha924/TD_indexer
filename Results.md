This repository contains a series of functions designed for an evaluation process. Each function serves a particular exercise outlined in the evaluation.

## Contracts

- **Evaluator Contract**: [0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE](https://goerli.etherscan.io/address/0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE)
- **Reward Contract**: [0x56822085cf7C15219f6dC404Ba24749f08f34173](https://goerli.etherscan.io/address/0x56822085cf7C15219f6dC404Ba24749f08f34173)

## Exercises

<br/>

### Ex 1: Deploy an ERC20 contract (2pts)

```
forge script script/DeployMyToken.s.sol:DeploymentScript --rpc-url YourRPCurl --broadcast --verify -vvvv --ffi
```
Et comme ça notre ERC20 est déployé

Deploy at https://goerli.etherscan.io/address/0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762
Verify with the command : forge verify-contract --watch --chain 5 --constructor-args 0000000000000000000000000000000000000000033b2e3c9fd0803ce8000000 --etherscan-api-key YOURAPIKEY 0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762 src/MyToken.sol:MyToken 

<br/>



### Ex 2: Mint your ERC20 tokens by calling ex2_mintStudentToken (2pts)


<br/>


```ts
function ex2_mintStudentToken() public {
    require(studentToken[msg.sender].balanceOf(address(this)) == 0);

    studentToken[msg.sender].transferFrom(
        address(studentToken[msg.sender]),
        address(this),
        10000000
    );

    require(studentToken[msg.sender].balanceOf(address(this)) == 10000000);
    exerciceProgression[msg.sender][0] = true;
}
```
what must be done to obtain the points for this exercise?
Firstly, the evaluator contract must have a balance of 0 tokens (my token).
Then we'll call a transferFrom from my contract to the evaluator contract. So we need :
- my contract must have 10000000 tokens
- that the evaluator contract is approved to spend the tokens in my contract, otherwise it won't be able to make the transferFrom if it's not approved.
Finally, the evaluator contract must have a balance of 10000000 token at the end.

In my constructor, what I do is mint a sufficient number of tokens to the contract, and approve a sufficient number of tokens for the transferFrom.

Then I call the registerStudentToken function:
```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "registerStudentToken(address)" 0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762
```

Then I call exo 2:
```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex2_mintStudentToken()"
```

Let's check the result :
```
cast call --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)" 0x1F65257306ea309aef96391691e4189fD8102EBc 0
```
réponse : 0x0000000000000000000000000000000000000000000000000000000000000001 != 0 so I've got True so I've passed the exo


<br/>



### Ex 3: Mint some EvaluatorTokens by calling `ex3_mintEvaluatorToken` (2 pts)

<br/>


```ts
function ex3_mintEvaluatorToken() public {
    require(exerciceProgression[msg.sender][0]);

    require(studentToken[msg.sender].balanceOf(address(this)) == 30000000);

    if (!exerciceProgression[msg.sender][1]) {
        exerciceProgression[msg.sender][1] = true;
        distributeToken(msg.sender, 30);
    }
}
```

the aim is to pass this require(studentToken[msg.sender].balanceOf(address(this)) == 30000000);
This means that our contract's balanceOf function, passing the address of the Evaluator contract, returns 30000000. In other words, the Evaluator contract has 30000000 token (my token)

One way to pass this question is to redeploy an erc20 in which we add a mint of 30000000 tokens in the constructor, for the address of the evaluator contract

I redeploy my contract with this modification.

Then I call the registerStudentToken function:
```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "registerStudentToken(address)" 0x9D9D461948C7f93F42e3A4662CAE4A780CA43704
```

Then I call exo 3:
```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex3_mintEvaluatorToken()"
()"
```

Let's check the result :
```
cast call --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)" 0x1F65257306ea309aef96391691e4189fD8102EBc 1
```
réponse : 0x0000000000000000000000000000000000000000000000000000000000000001 != 0 so I've got True so I've passed the exo



<br/>



### Ex 4: From your smart contract, you must call uniswap V3 smart contracts in order to swap EvaluatorToken <> RewardToken. Then call `ex4_checkRewardTokenBalance`  (2 pts)


<br/>


```ts
function ex4_checkRewardTokenBalance() public {
        require(exerciceProgression[msg.sender][1]);

        uint amountToCheck = 5;
        require(
            rewardToken.balanceOf(msg.sender) ==
                10 ** rewardToken.decimals() * amountToCheck, "balance insufficient in reward token"
        );

        if (!exerciceProgression[msg.sender][2]) {
            exerciceProgression[msg.sender][2] = true;
        }
    }
```
To pass this exercise, our address that will call the exercise must have 5 * (10** rewardToken.decimals()) rewardToken, and for this it is specified that we must swap theEvaluatorToken against RewardToken on uniswapv3.

I write my swaprewardtoken function.
Thanks to the previous exercise, I have 30 evaluator token

evaluator token and reward token decimals:
12  (```cast call --rpc-url yourRPCurl --chain 5 0x56822085cf7C15219f6dC404Ba24749f08f34173 "decimals()" ; cast call --rpc-url yourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "decimals()"```)

uint amountInMaximum = 30 * (10 ** decimals()) = 30000000000000
uint amountOut = 5 * (10 ** rewardToken.decimals()) = 5000000000000
```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex4_checkRewardTokenBalance()"
```
```
cast call --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)"  0x1F65257306ea309aef96391691e4189fD8102EBc 2
```
0x0000000000000000000000000000000000000000000000000000000000000001



<br/>


### Ex 7: Deploy an ERC721 (2 pts)


<br/>


```
forge script script/DeployMyERC721.s.sol:DeploymentScript --rpc-url YourRPCurl --broadcast --verify -vvvv --ffi
```
And just like that, our ERC721.s is deployed and automatically verified.


<br/>


### Ex 8: Mint some ERC721's by calling `ex8_mintNFT` (2 pts)


<br/>


```ts
function ex8_mintNFT() public {
        require(!exerciceProgression[msg.sender][4]);
        uint256 tokenIdToMint = 4;
        try studentNft[msg.sender].mint(tokenIdToMint) {
            return;
        } catch Error(string memory errorMessage) {
            require(
                keccak256(abi.encodePacked(errorMessage)) ==
                    keccak256(
                        abi.encodePacked("cannot mint nft without collateral")
                    ), "waiting for exception but did not get one"
            );
            uint256 amountToMint = getFullAmount(10);
            distributeToken(address(this), amountToMint);
            if (
                allowance(address(this), address(studentNft[msg.sender])) == 0
            ) {
                _approve(address(this), address(studentNft[msg.sender]), amountToMint);
            }
            studentNft[msg.sender].mint(tokenIdToMint);
            require(studentNft[msg.sender].balanceOf(address(this)) == 1);
            require(
                studentNft[msg.sender].ownerOf(tokenIdToMint) == address(this)
            );
            if (!exerciceProgression[msg.sender][4]) {
                exerciceProgression[msg.sender][4] = true;
            }
        }
    }
```
so basically, to mint, you first have to authorize me to use your tokens, a certain number given by getFullAmount, but to succeed in this exercise, I just have to set that a token is required, so that if I'm not approved, I set a require that will check if I'm approved and return "cannot mint nft without collateral" if I'm not.
if it is, the mint is performed


```
forge script script/DeployMyERC721.s.sol:DeploymentScript --rpc-url YourRPCurl --broadcast --verify -vvvv --ffi
```

```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "registerStudentNft(address)" 0xe290d86B890a021573313E6446Ce7A5D1FBd2AB8
```


```
cast send --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex3_mintEvaluatorToken()"
()"
```

Let's check the result :
```
cast call --private-key MyPrivateKey --rpc-url YourRPCurl --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)" 0x1F65257306ea309aef96391691e4189fD8102EBc 4
```
réponse : 0x0000000000000000000000000000000000000000000000000000000000000001 != 0 so I've got True so I've passed the exo



<br/>


### Ex 9: Ouch... my Evaluator contract is admin of your ERC721 token. He has full rights and you must call `ex9_burnNft` (1 pts)


<br/>


To succeed in this exercise, we want the Evaluator contract to be able to call the burn function of my nft contract, on a token that doesn't belong to it but to me. To achieve this, we use this function:
setApprovalForAll(0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE, true); ````
by the way, I realized later that I didn't need to create a special function to call this in my contract, it's already accessible from etherscan because my contract inherits from Openzeppelin's ERC721

I think I did the right thing, but I don't understand why I didn't validate this test...


<br/>


### Ex 10: Verify your smart contract on Etherscan and sourcify (1 pts)


<br/>


On etherscan, All my contracts are verified by default by adding the --verify command during deployment.

You can also use :
forge verify-contract --watch --chain 5 --constructor-args ABIencodedConstructorArgs --etherscan-api-key YOURAPIKEY YOURCONTRACTADRESS PATHtoTheFile



<br/>


### Ex 11: Simply call `ex11_unlock_ethers` (2 pts)


<br/>

```
cast send --private-key myPrivateKey --rpc-url YourRPCurl --value 1000000 0x1F65257306ea309aef96391691e4189fD8102EBc 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE 0x1b4759c8c0a5abab93ceb3dc642cb756323b1e3127bd1d8eb615d962573f791d
```
0x1F65257306ea309aef96391691e4189fD8102EBc is the sender's address (--from).
0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE is the recipient's address (the contract you're interacting with).
The hexadecimal string following the recipient's address is the data payload (--data).

to get the data i do cast keccak "esilv-td only"
it gives me 0x1b4759c8c0a5abab93ceb3dc642cb756323b1e3127bd1d8eb615d962573f791d

my try has not been successful