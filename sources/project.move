module MyModule::NFTBranding {
    use aptos_framework::signer;
    

    /// Struct representing a brand identity.
    struct Brand has store, key {
        owner: address,
        name: vector<u8>,
    }

    /// Function to create a brand identity.
    public fun create_brand(owner: &signer, name: vector<u8>) {
        let brand = Brand {
            owner: signer::address_of(owner),
            name,
        };
        move_to(owner, brand);
    }

    /// Function to assign an NFT-based brand identity to a user.
    public fun assign_brand_identity(owner: address, recipient: &signer) acquires Brand {
        let brand = borrow_global_mut<Brand>(owner);
        assert!(brand.owner == owner, 1);
        brand.owner = signer::address_of(recipient);
    }
}
