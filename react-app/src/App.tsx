// App.tsx
import React, { useState } from 'react';
import Web3 from 'web3';
import { Contract } from 'web3-eth-contract';

declare global {
  interface Window {
    ethereum?: any;
  }
}

const App: React.FC = () => {
  const [amount, setAmount] = useState<string>('');
  const [web3, setWeb3] = useState<Web3 | null>(null);
  const [accounts, setAccounts] = useState<string[] | null>(null);
  const [marketPlaceContract, setMarketPlaceContract] = useState<Contract<any> | null>(null);

  // Remplacer par vos adresses et ABI
  const stablecoinAddress = '0x584962939D444D5A1e08E4b9A4233e430c35F5a7';
  const stablecoinABI: any[] = require("./abi/StableCoin.json").abi;
  const marketPlaceAddress = '0x9FD1eb0eeAE4a855890361F9033026AbD03Ca783';
  const marketPlaceABI: any[] = require("./abi/MarketPlace.json").abi;

  const initializeBlockchain = async () => {
    if (window.ethereum) {
      const web3Instance = new Web3(window.ethereum);
      try {
        await window.ethereum.enable();
        const accounts = await web3Instance.eth.getAccounts();
        const marketPlaceInstance = new web3Instance.eth.Contract(marketPlaceABI, marketPlaceAddress);

        setWeb3(web3Instance);
        setAccounts(accounts);
        setMarketPlaceContract(marketPlaceInstance);
      } catch (error) {
        console.error("Error connecting to Ethereum: ", error);
      }
    } else {
      console.error("Ethereum object not found, install MetaMask.");
    }
  };

  const setAllowance = async () => {
    if (!web3 || !accounts) return;

    const stablecoinContract = new web3.eth.Contract(stablecoinABI, stablecoinAddress);
    await (stablecoinContract.methods.approve as any)(marketPlaceAddress, web3.utils.toWei(amount, 'ether')).send({ from: accounts[0] });

    alert("Allowance set!");
  };

  const executeSwap = async () => {
    if (!web3 || !marketPlaceContract || !accounts) return;
    await (marketPlaceContract.methods.swap as any)(amount).send({ from: accounts[0] });

    alert("Swap executed!");
  };

  return (
    <div>
      {accounts && accounts.length > 0 ? (
        <div>Connected Address: {accounts[0]}</div>
      ) : (
        <button onClick={initializeBlockchain}>Connect to Ethereum</button>
      )}
      <br />
      <input type="number" value={amount} onChange={(e) => setAmount(e.target.value)} />
      <button onClick={setAllowance}>Set Allowance</button>
      <button onClick={executeSwap}>Swap</button>
    </div>
  );
};

export default App;
