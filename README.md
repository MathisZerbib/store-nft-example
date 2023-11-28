# store-nft-example


## Install

```bash
npm install
```

## Add .env file
    ```bash
    cp .env.example .env
    ```


## Add your private key to .env file
    ```bash
    PRIVATE_KEY=YOUR_PRIVATE_KEY
    ```
## Add your NFT Storage API key to .env file
    ```bash
    NFT_STORAGE_API_KEY=YOUR_NFT_STORAGE_API_KEY
    ```



## Usage

1. Upload a new image to /assets folder called MyExampleNFT.png
2. Run the following command to store the image on IPFS and 
<!-- 3. mint it on the blockchain -->
<!-- 3. The script will output the transaction hash and the NFT contract address
1. You can view the NFT on OpenSea by visiting https://testnets.opensea.io/assets/CONTRACT_ADDRESS/TOKEN_ID -->
3. You can view the NFT on IPFS by visiting https://ipfs.io/ipfs/IPFS_HASH
4. You can view the NFT on NFT Storage by visiting https://nft.storage/ipfs/IPFS_HASH
 
```bash
node scripts/store-asset.js
```


