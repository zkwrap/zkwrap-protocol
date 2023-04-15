import { BsNewspaper } from "react-icons/bs"
import { FaMedium, FaTwitter, FaTelegram, FaDiscord } from "react-icons/fa"


export const socialMedias = [
    { id: 1, Icon: FaMedium, link: '#' },
    { id: 2, Icon: FaTwitter, link: '#' },
    { id: 3, Icon: FaTelegram, link: '#' },
    { id: 4, Icon: FaDiscord, link: '#' },
    { id: 5, Icon: BsNewspaper, link: '#' },
]

export const infoItems = [
    { id: 1, title: "Market Cap", info: "$10M" },
    { id: 2, title: "Price", info: "$10" },
    { id: 3, title: "ZW Token", info: "0xFF191514A9baba76BfD19e3943a4d37E8ec9a111" },
]

export const navlinks = [
    {id: 1, title: "Swap", url: "swap"},
    {id: 2, title: "Pools", url: "pools"},
    {id: 3, title: "Rewards", url: "rewards"},
    {id: 4, title: "Airdrop", url: "airdrop"},
]


// pools data

export const poolsData = {
    tokenPairs: [
        { id: 1, title: "WETH/ZKW", type: "volatile" },
        { id: 2, title: "ZKW/USDC", type: "volatile" },
        { id: 3, title: "ARB/ZKW", type: "volatile" },
        { id: 4, title: "WETH/USDC", type: "volatile" },
        { id: 4, title: "WETH/USDC", type: "volatile" },
        { id: 5, title: "WETH/USDC", type: "volatile" },
        { id: 6, title: "WETH/USDC", type: "volatile" },
        { id: 7, title: "WETH/USDC", type: "volatile" },
    ],
    aprPercentages: [
        { id: 1, percentage: "%1000" },
        { id: 2, percentage: "%1000" },
        { id: 3, percentage: "%1000" },
        { id: 4, percentage: "%1000" },
        { id: 5, percentage: "%1000" },
        { id: 6, percentage: "%1000" },
        { id: 7, percentage: "%1000" },
    ],
    totalPools: [
        { id: 1,  tokenA: "WETH", amountA: "100", tokenB: "ZKW", amountB: "1000" },
        { id: 2,  tokenA: "ZKW", amountA: "100", tokenB: "USDC", amountB: "1000" },
        { id: 3, tokenA: "ARB", amountA: "100", tokenB: "ZKW", amountB: "1000" },
        { id: 4, tokenA: "WETH", amountA: "100", tokenB: "USDC", amountB: "1000"  },
        { id: 5, tokenA: "WETH", amountA: "100", tokenB: "USDC", amountB: "1000"  },
        { id: 6, tokenA: "WETH", amountA: "100", tokenB: "USDC", amountB: "1000"  },
        { id: 7, tokenA: "WETH", amountA: "100", tokenB: "USDC", amountB: "1000"  },
    ]

}


export const zkContract = '0x451d1aF630eD72C6506c969e471c3d81F5932F6B'
