use anyhow::Result;
use tokio::runtime::Runtime;

use iota_sdk::{
    client::secret::stronghold::StrongholdSecretManager as WalletStrongholdSecretManager,
    client::secret::SecretManager as WalletSecretManager,
    client::utils::request_funds_from_faucet,
    client::Client,
    types::block::{address::Bech32Address, output::AliasOutput},
};

use std::{env, path::PathBuf, u32};

use identity_iota::{
    iota::{IotaClientExt, IotaDocument, IotaIdentityClientExt, NetworkName},
    storage::{JwkDocumentExt, JwkMemStore, KeyIdMemstore, Storage},
    verification::{jws::JwsAlgorithm, MethodScope},
};

mod wallet_singleton;

#[derive(Debug, Clone)]
pub struct NetworkInfo {
    pub node_url: String,
    pub faucet_url: String,
}

#[allow(dead_code)]
pub fn get_node_info(network_info: NetworkInfo) -> Result<String> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let node_url = network_info.node_url;

        // Create a client with that node.
        let client = Client::builder()
            .with_node(&node_url)?
            .with_ignore_node_health()
            .finish()
            .await?;

        // Get node info.
        let info = client.get_info().await?.node_info;

        Ok(serde_json::to_string_pretty(&info).unwrap())
        //Ok(info.node_info.base_token.name)
    })
}

#[allow(dead_code)]
pub fn generate_mnemonic() -> String {
    let mnemonic = Client::generate_mnemonic();
    mnemonic.unwrap().to_string()
}

#[derive(Debug, Clone)]
pub struct WalletInfo {
    pub alias: String,
    pub mnemonic: String,
    pub stronghold_password: String,
    pub stronghold_filepath: String,
    pub last_address: String,
}

#[allow(dead_code)]
pub fn create_wallet_account(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    wallet_singleton::create_wallet_account(network_info, wallet_info)
}

#[allow(dead_code)]
pub fn generate_address(wallet_info: WalletInfo) -> Result<String> {
    wallet_singleton::generate_address(wallet_info)
}

#[allow(dead_code)]
pub fn request_funds(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let stronghold_filepath = wallet_info.stronghold_filepath;
        let last_address = wallet_info.last_address;
        env::set_current_dir(&stronghold_filepath).ok();

        let faucet_url = network_info.faucet_url;

        // Convert given address (BECH32 string) to Address struct
        let address = Bech32Address::try_from_str(&last_address)?;

        // Use the function iota_wallet::iota_client::request_funds_from_faucet
        let faucet_response = request_funds_from_faucet(&faucet_url, &address).await?;

        Ok(faucet_response.to_string())
    })
}

#[derive(Debug, Clone)]
pub struct BaseCoinBalance {
    /// Total amount
    pub total: u64,
    /// Balance that can currently be spent
    pub available: u64,
}

#[allow(dead_code)]
pub fn check_balance(wallet_info: WalletInfo) -> Result<BaseCoinBalance> {
    wallet_singleton::check_balance(wallet_info)
}

type MemStorage = Storage<JwkMemStore, KeyIdMemstore>;
#[allow(dead_code)]
pub fn create_decentralized_identifier(
    network_info: NetworkInfo,
    wallet_info: WalletInfo,
) -> Result<String> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let node_url = network_info.node_url;
        let stronghold_password = wallet_info.stronghold_password;
        let stronghold_filepath = wallet_info.stronghold_filepath;
        let last_address = wallet_info.last_address;

        env::set_current_dir(&stronghold_filepath).ok();

        let mut path_buf_snapshot = PathBuf::new();
        path_buf_snapshot.push(&stronghold_filepath);
        path_buf_snapshot.push("wallet.stronghold");
        let path_snapshot = PathBuf::from(path_buf_snapshot);

        // Create a new client to interact with the IOTA ledger.
        let client: Client = Client::builder()
            .with_primary_node(&node_url, None)?
            .finish()
            .await?;

        // Create a new secret manager backed by a Stronghold.
        let secret_manager: WalletSecretManager = WalletSecretManager::Stronghold(
            WalletStrongholdSecretManager::builder()
                .password(stronghold_password)
                .build(path_snapshot)?,
        );

        // Convert given address (BECH32 string) to Address struct
        let address = Bech32Address::try_from_str(&last_address)?;

        // Get the Bech32 human-readable part (HRP) of the network.
        let network_name: NetworkName = client.network_name().await?;

        // Create a new DID document with a placeholder DID.
        // The DID will be derived from the Alias Id of the Alias Output after publishing.
        let mut document: IotaDocument = IotaDocument::new(&network_name);

        // Insert a new Ed25519 verification method in the DID document.
        let storage: MemStorage = MemStorage::new(JwkMemStore::new(), KeyIdMemstore::new());
        document
            .generate_method(
                &storage,
                JwkMemStore::ED25519_KEY_TYPE,
                JwsAlgorithm::EdDSA,
                None,
                MethodScope::VerificationMethod,
            )
            .await?;

        // Insert a new Ed25519 verification method in the DID document.
        let storage: MemStorage = MemStorage::new(JwkMemStore::new(), KeyIdMemstore::new());
        document
            .generate_method(
                &storage,
                JwkMemStore::ED25519_KEY_TYPE,
                JwsAlgorithm::EdDSA,
                None,
                MethodScope::VerificationMethod,
            )
            .await?;

        // Construct an Alias Output containing the DID document, with the wallet address
        // set as both the state controller and governor.
        let alias_output: AliasOutput = client.new_did_output(*address, document, None).await?;

        // Publish the Alias Output and get the published DID document.
        let document: IotaDocument = client
            .publish_did_output(&secret_manager, alias_output)
            .await?;
        Ok(document.to_string())
    })
}

#[allow(dead_code)]
pub fn bin_to_hex(val: String, len: usize) -> String {
    let n: u32 = u32::from_str_radix(&val, 2).unwrap();
    format!("{:01$x}", n, len * 2)
}
