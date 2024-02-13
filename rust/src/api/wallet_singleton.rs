use crate::api::{BaseCoinBalance, NetworkInfo, WalletInfo};
use anyhow::{Error, Result};
use iota_sdk::{
    client::constants::SHIMMER_COIN_TYPE,
    client::secret::stronghold::StrongholdSecretManager as WalletStrongholdSecretManager,
    client::secret::SecretManager as WalletSecretManager,
    crypto::keys::bip39::Mnemonic,
    wallet::{ClientOptions, Wallet},
};
use std::env;
use std::fs;
use std::path::PathBuf;
use std::sync::{Mutex, Once};
use tokio::runtime::Runtime;

struct WalletSingleton {
    network_info: NetworkInfo,
    wallet_info: WalletInfo,
    wallet: Option<Wallet>,
}

impl WalletSingleton {
    fn new(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<Self> {
        let mut wallet_singleton = Self {
            network_info,
            wallet_info,
            wallet: None,
        };

        wallet_singleton.create_wallet()?;
        Ok(wallet_singleton)
    }

    fn create_wallet(&mut self) -> Result<String> {
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            let node_url = &self.network_info.node_url;

            let stronghold_password = self.wallet_info.stronghold_password.clone();
            let stronghold_filepath = self.wallet_info.stronghold_filepath.clone();
            let mnemonic_string: String = self.wallet_info.mnemonic.clone();
            let mnemonic = Mnemonic::from(mnemonic_string);

            // Create the needed directory according to the given path
            let mut path_buf = PathBuf::new();
            path_buf.push(&stronghold_filepath);
            let path = PathBuf::from(path_buf);
            fs::create_dir_all(path).ok();

            // THIS NEXT STEP IS CRUCIAL:
            // Point the "current working directory" to the given path
            env::set_current_dir(&stronghold_filepath).ok();

            // Create the Rust file for the stronghold snapshot file
            let mut path_buf_snapshot = PathBuf::new();
            path_buf_snapshot.push(&stronghold_filepath);
            path_buf_snapshot.push("wallet.stronghold");
            let path_snapshot = PathBuf::from(path_buf_snapshot);

            let secret_manager = WalletStrongholdSecretManager::builder()
                .password(stronghold_password)
                .build(path_snapshot)?;

            // Storing the mnemonic is ONLY REQUIRED THE FIRST TIME
            // calling it TWICE THROWS AN ERROR
            secret_manager.store_mnemonic(mnemonic).await?;

            // Create a ClientBuilder (= client_options in wallet.rs)
            // See wallet.rs:
            // -> src/lib.rs
            // -> line "pub use iota_client::ClientBuilder as ClientOptions"
            let client_options = ClientOptions::new().with_node(&node_url)?;

            // Create the account manager with the secret_manager
            // and client_options (= ClientBuilder).
            // The Client itself is created in the AccountManagerBuilder's finish() method.
            // See wallet.rs:
            // -> src/account_manager/builder.rs
            // -> line "let client = client_options.clone().finish()?;"

            self.wallet = Some(
                Wallet::builder()
                    .with_secret_manager(WalletSecretManager::Stronghold(secret_manager))
                    .with_client_options(client_options)
                    .with_coin_type(SHIMMER_COIN_TYPE)
                    .finish()
                    .await?,
            );

            Ok("Wallet Account was created successfully.".into())
        })
    }

    fn create_account(&self, wallet_info: WalletInfo) -> Result<String> {
        let wallet_singleton = self;
        let result = Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = wallet_singleton.wallet {
                let wallet_alias = wallet_info.alias;
                let _account = wallet
                    .create_account()
                    .with_alias((&wallet_alias).to_string())
                    .finish()
                    .await?;
                Ok("Account was created successfully.".into())
            } else {
                Err(Error::msg("No wallet set."))
            }
        });
        result
    }

    fn generate_address(&self, wallet_info: WalletInfo) -> Result<String> {
        let wallet_singleton = self;
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            if let Some(ref wallet) = wallet_singleton.wallet {
                let stronghold_password = wallet_info.stronghold_password;
                let wallet_alias = wallet_info.alias;
                let account = wallet.get_account((&wallet_alias).to_string()).await?;

                wallet.set_stronghold_password(stronghold_password).await?;

                let addresses = account.generate_ed25519_addresses(1, None).await?;
                Ok(addresses[0].address().to_string())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }

    fn check_balance(&self, wallet_info: WalletInfo) -> Result<BaseCoinBalance> {
        let wallet_singleton = self;
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            if let Some(ref wallet) = wallet_singleton.wallet {
                let stronghold_filepath = wallet_info.stronghold_filepath;
                env::set_current_dir(&stronghold_filepath).ok();

                let wallet_alias = wallet_info.alias;
                let account = wallet.get_account((&wallet_alias).to_string()).await?;

                // Sync and get the balance
                let account_balance = account.sync(None).await?;

                let base_coin_balance = BaseCoinBalance {
                    total: account_balance.base_coin().total(),
                    available: account_balance.base_coin().available(),
                };
                //let total = account_balance.base_coin.total;
                //println!("{:?}", account_balance);

                //Ok(total.to_string())
                Ok(base_coin_balance)
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }
}

lazy_static::lazy_static! {
    static ref WALLET_SINGLETON: Mutex<Option<WalletSingleton>> = Mutex::new(None);
    static ref INIT: Once = Once::new();
}

fn create_wallet_singleton_if_needed(network_info: NetworkInfo, wallet_info: WalletInfo) {
    INIT.call_once(|| {
        if let Ok(wallet_singleton) = WalletSingleton::new(network_info, wallet_info) {
            let mut locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
            *locked_wallet_singleton = Some(wallet_singleton);
        } else {
            // Handle the error
            // You can log an error, panic, or choose an appropriate action.
            panic!("Error creating wallet singleton");
        }
    });
}

pub fn create_wallet_account(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    create_wallet_singleton_if_needed(network_info, wallet_info.clone());
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.create_account(wallet_info)
}

pub fn generate_address(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.generate_address(wallet_info)
}

pub fn check_balance(wallet_info: WalletInfo) -> Result<BaseCoinBalance> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.check_balance(wallet_info)
}
