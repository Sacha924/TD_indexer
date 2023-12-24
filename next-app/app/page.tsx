'use client'

import { useState } from 'react'
import styles from './page.module.css'

export default function Home() {
  const [data, setData] = useState<any>()
  const [id, setId] = useState<String>("")

  function queryData() {
    let url = "https://api.thegraph.com/subgraphs/name/sushiswap/exchange"
    let query = `
      query getPair($_id: ID!) {
          pair(id: $_id) {
            id
            name
            token0 {
              id
              symbol
            }
            token1 {
              id
              symbol
            }
            liquidityPositions(first: 3, orderBy: liquidityTokenBalance, orderDirection: desc) {
              user {
                id
              }
              liquidityTokenBalance
            }
          }
      }`;

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: query,
        variables: { _id: id },
      }),
    })
      .then(response => response.json())
      .then(result => {
        setData(result.data.pair);
      })
      .catch(error => {
      });
  }

  return (
    <div style={{ fontFamily: 'Arial, sans-serif', padding: '20px' }}>
      <h1 style={{ textAlign: 'center' }}>SushiSwap LP Token Dashboard</h1>
      <p style={{ textAlign: 'center', marginBottom: '20px' }}>
        Enter the LP token address to view the top 3 whale positions and their balances.
      </p>
      
      <div style={{ marginBottom: '10px' }}>
        <p>Example LP IDs:</p>
        <ul>
          <li style={{ marginBottom: '5px' }}>0x06da0fd433c1a5d7a4faa01111c044910a184553</li>
          <li style={{ marginBottom: '5px' }}>0x397ff1542f962076d0bfe58ea045ffa2d347aca0</li>
          <li style={{ marginBottom: '5px' }}>0xcb2286d9471cc185281c4f763d34a962ed212962</li>
          <li style={{ marginBottom: '5px' }}>0x201e6a9e75df132a8598720433af35fe8d73e94d</li>
        </ul>
      </div>
      
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', marginBottom: '20px' }}>
        <input
          type="text"
          placeholder="Enter SushiSwap LP ID"
          onChange={(e) => setId(e.target.value)}
          style={{ marginRight: '10px', padding: '10px', border: '1px solid #ddd', borderRadius: '4px' }}
        />
        <button
          type="button"
          onClick={queryData}
          style={{ padding: '10px 20px', border: 'none', borderRadius: '4px', backgroundColor: '#007bff', color: 'white', cursor: 'pointer' }}
        >
          Fetch Data
        </button>
      </div>
      
      {data?.liquidityPositions && (
        <div>
          <h2 style={{ borderBottom: '2px solid #007bff', display: 'inline-block', paddingBottom: '5px' }}>
            {data.name} Top Whales
          </h2>
          <table style={{ width: '100%', marginTop: '20px', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ backgroundColor: '#f2f2f2' }}>
                <th style={{ textAlign: 'left', padding: '8px', border: '1px solid #ddd' }}>User ID</th>
                <th style={{ textAlign: 'left', padding: '8px', border: '1px solid #ddd' }}>Liquidity Token Balance</th>
              </tr>
            </thead>
            <tbody>
              {data.liquidityPositions.map((position: any, index: any) => (
                <tr key={index}>
                  <td style={{ padding: '8px', border: '1px solid #ddd' }}>{position.user.id}</td>
                  <td style={{ padding: '8px', border: '1px solid #ddd' }}>{position.liquidityTokenBalance}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}