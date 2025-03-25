module nft_branding::BrandNFT {
    use std::signer;
    use std::string::{Self, String};
    use aptos_token_objects::token;
    use aptos_token_objects::collection;
    use aptos_framework::account;

    /// Struct to represent a brand NFT
    struct BrandNFT has key, store {
        /// Unique identifier for the brand
        brand_name: String,
        /// Description of the brand
        brand_description: String,
        /// Total number of NFTs minted
        total_supply: u64,
        /// Royalty percentage for secondary sales
        royalty_percentage: u64
    }

    /// Create a new brand NFT collection and initialize brand details
    public entry fun create_brand_collection(
        creator: &signer, 
        brand_name: String,
        brand_description: String,
        royalty_percentage: u64
    ) {
        // Ensure royalty is within reasonable limits (0-20%)
        assert!(royalty_percentage <= 20, 1);

        // Create a new collection for the brand
        let collection_name = string::utf8(b"Brand Collection: ");
        string::append(&mut collection_name, brand_name);
        
        collection::create_unlimited_collection(
            creator, 
            string::utf8(b"NFT Branding Collection"), 
            collection_name, 
            option::none()
        );

        // Initialize brand NFT resource
        let brand = BrandNFT {
            brand_name,
            brand_description,
            total_supply: 0,
            royalty_percentage
        };
        move_to(creator, brand);
    }

    /// Mint a new brand NFT within the collection
    public entry fun mint_brand_nft(
        creator: &signer, 
        brand_name: String,
        nft_name: String,
        nft_description: String
    ) acquires BrandNFT {
        // Retrieve the brand details
        let brand = borrow_global_mut<BrandNFT>(signer::address_of(creator));
        
        // Create the NFT
        let token_name = string::utf8(b"Brand NFT: ");
        string::append(&mut token_name, nft_name);
        
        token::create_token_script(
            creator,
            string::utf8(b"Brand Collection: "),
            string::append(brand.brand_name),
            token_name,
            option::none(),
            nft_description
        );

        // Increment total supply
        brand.total_supply = brand.total_supply + 1;
    }
}