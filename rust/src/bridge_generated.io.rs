use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_get_node_info(port_: i64, network_info: *mut wire_NetworkInfo) {
    wire_get_node_info_impl(port_, network_info)
}

#[no_mangle]
pub extern "C" fn wire_generate_mnemonic(port_: i64) {
    wire_generate_mnemonic_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_create_wallet_account(
    port_: i64,
    network_info: *mut wire_NetworkInfo,
    wallet_info: *mut wire_WalletInfo,
) {
    wire_create_wallet_account_impl(port_, network_info, wallet_info)
}

#[no_mangle]
pub extern "C" fn wire_generate_address(port_: i64, wallet_info: *mut wire_WalletInfo) {
    wire_generate_address_impl(port_, wallet_info)
}

#[no_mangle]
pub extern "C" fn wire_request_funds(
    port_: i64,
    network_info: *mut wire_NetworkInfo,
    wallet_info: *mut wire_WalletInfo,
) {
    wire_request_funds_impl(port_, network_info, wallet_info)
}

#[no_mangle]
pub extern "C" fn wire_check_balance(port_: i64, wallet_info: *mut wire_WalletInfo) {
    wire_check_balance_impl(port_, wallet_info)
}

#[no_mangle]
pub extern "C" fn wire_create_decentralized_identifier(
    port_: i64,
    network_info: *mut wire_NetworkInfo,
    wallet_info: *mut wire_WalletInfo,
) {
    wire_create_decentralized_identifier_impl(port_, network_info, wallet_info)
}

#[no_mangle]
pub extern "C" fn wire_bin_to_hex(port_: i64, val: *mut wire_uint_8_list, len: usize) {
    wire_bin_to_hex_impl(port_, val, len)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_network_info_0() -> *mut wire_NetworkInfo {
    support::new_leak_box_ptr(wire_NetworkInfo::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_wallet_info_0() -> *mut wire_WalletInfo {
    support::new_leak_box_ptr(wire_WalletInfo::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<NetworkInfo> for *mut wire_NetworkInfo {
    fn wire2api(self) -> NetworkInfo {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<NetworkInfo>::wire2api(*wrap).into()
    }
}
impl Wire2Api<WalletInfo> for *mut wire_WalletInfo {
    fn wire2api(self) -> WalletInfo {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<WalletInfo>::wire2api(*wrap).into()
    }
}
impl Wire2Api<NetworkInfo> for wire_NetworkInfo {
    fn wire2api(self) -> NetworkInfo {
        NetworkInfo {
            node_url: self.node_url.wire2api(),
            faucet_url: self.faucet_url.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

impl Wire2Api<WalletInfo> for wire_WalletInfo {
    fn wire2api(self) -> WalletInfo {
        WalletInfo {
            alias: self.alias.wire2api(),
            mnemonic: self.mnemonic.wire2api(),
            stronghold_password: self.stronghold_password.wire2api(),
            stronghold_filepath: self.stronghold_filepath.wire2api(),
            last_address: self.last_address.wire2api(),
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_NetworkInfo {
    node_url: *mut wire_uint_8_list,
    faucet_url: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_WalletInfo {
    alias: *mut wire_uint_8_list,
    mnemonic: *mut wire_uint_8_list,
    stronghold_password: *mut wire_uint_8_list,
    stronghold_filepath: *mut wire_uint_8_list,
    last_address: *mut wire_uint_8_list,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_NetworkInfo {
    fn new_with_null_ptr() -> Self {
        Self {
            node_url: core::ptr::null_mut(),
            faucet_url: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_NetworkInfo {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_WalletInfo {
    fn new_with_null_ptr() -> Self {
        Self {
            alias: core::ptr::null_mut(),
            mnemonic: core::ptr::null_mut(),
            stronghold_password: core::ptr::null_mut(),
            stronghold_filepath: core::ptr::null_mut(),
            last_address: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_WalletInfo {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
