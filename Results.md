- [Evaluator contract](https://goerli.etherscan.io/address/0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE) : 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE
- [Reward contract](https://goerli.etherscan.io/address/0x56822085cf7C15219f6dC404Ba24749f08f34173) : 0x56822085cf7C15219f6dC404Ba24749f08f34173


## Ex 1: Deploy an ERC20 contract (2pts)

```
forge script script/DeployMyToken.s.sol:DeploymentScript --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --broadcast --verify -vvvv --ffi
```
Et comme ça notre ERC20 est déployé

Deploy at https://goerli.etherscan.io/address/0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762
Verify with the command : forge verify-contract --watch --chain 5 --constructor-args 0000000000000000000000000000000000000000033b2e3c9fd0803ce8000000 --etherscan-api-key YOURAPIKEY 0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762 src/MyToken.sol:MyToken 

## Ex 2: Mint your ERC20 tokens by calling ex2_mintStudentToken (2pts)

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
que faut-il faire pour obtenir les points de cet exercice ?
Premièrement, il faut que le contrat evaluator est une balance de 0 token (mon token).
Ensuite on va appellé un transferFrom de mon contrat, vers le contrat evaluator. Donc il faut :
- que mon contrat est 10000000 tokens
- que l'on est approve le contrat evaluator a dépensé les tokens de mon contrat, parceque sinon il n'aura pas le droit de faire le transferFrom s'il n'est pas approve.
Enfin, il faut que le contrat evaluator est une balance de 10000000 token à la fin.

Dans mon constructor ce que je fais c'est que je mint un nombre suffisant de tokens au contrat, et que j'approve un nombre suffisant de tokens pour le transferFrom

Ensuite j'appelle la fonction registerStudentToken :
```
cast send --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "registerStudentToken(address)" 0x88e4a57A70844dbbdD6Bc2cF7746645Eb0943762
```

Puis j'appelle l'exo 2 : 
```
cast send --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex2_mintStudentToken()"
```

Let's check the result :
cast call --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)" 0x1F65257306ea309aef96391691e4189fD8102EBc 0
réponse : 0x0000000000000000000000000000000000000000000000000000000000000001 != 0 donc j'ai True donc j'ai bien passé l'exo



## Ex 3: Mint some EvaluatorTokens by calling `ex3_mintEvaluatorToken` (2 pts)
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

le but est de passer ce require : require(studentToken[msg.sender].balanceOf(address(this)) == 30000000);
Cela signifie que la fonction balanceOf de notre contrat, en passant l'adresse du contrat évaluator, renvoie 30000000. Autrement dit le contrat Evaluator a 30000000 token (mon token)

Une façon de réussir cette question est de redéployer un erc20 dans lequel on ajoute un mint de 30000000 tokens dans le constructor, pour l'adresse du contrat évaluateur

Je redéploie mon contrat avec cette modification.

Ensuite j'appelle la fonction registerStudentToken :
```
cast send --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "registerStudentToken(address)" 0x9D9D461948C7f93F42e3A4662CAE4A780CA43704
```

Puis j'appelle l'exo 3 : 
```
cast send --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "ex3_mintEvaluatorToken()"
()"
```

Let's check the result :
cast call --private-key MyPrivateKey --rpc-url https://goerli.infura.io/v3/cb2e30cd9b854c6b99d7ef2617ff9199 --chain 5 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE "exerciceProgression(address,uint256)" 0x1F65257306ea309aef96391691e4189fD8102EBc 1
réponse : 0x0000000000000000000000000000000000000000000000000000000000000001 != 0 donc j'ai True donc j'ai bien passé l'exo



## Ex 4: From your smart contract, you must call uniswap V3 smart contracts in order to swap EvaluatorToken <> RewardToken. Then call `ex4_checkRewardTokenBalance`  (2 pts)

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

Pour réussir cet exercice il faut que notre adresse qui va appelé l'exercice ait 50 ** rewardToken.decimals() rewardToken, et pour cela il est précisé qu'on doit swappé lesEvaluatorToken contre des RewardToken sur uniswapv3








## Ex 5: You must send to the Evaluator smart contract some RewardToken by calling `ex5_checkRewardTokenBalance` (2 pts)

















## Ex 6: Create a liquidity pool on uniswap V3 between your ERC20 tokens and some WETH. You must use Uniswap smart contracts (2 pts)
