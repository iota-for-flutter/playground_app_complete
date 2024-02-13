#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_NetworkInfo {
  struct wire_uint_8_list *node_url;
  struct wire_uint_8_list *faucet_url;
} wire_NetworkInfo;

typedef struct wire_WalletInfo {
  struct wire_uint_8_list *alias;
  struct wire_uint_8_list *mnemonic;
  struct wire_uint_8_list *stronghold_password;
  struct wire_uint_8_list *stronghold_filepath;
  struct wire_uint_8_list *last_address;
} wire_WalletInfo;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_get_node_info(int64_t port_, struct wire_NetworkInfo *network_info);

void wire_generate_mnemonic(int64_t port_);

void wire_create_wallet_account(int64_t port_,
                                struct wire_NetworkInfo *network_info,
                                struct wire_WalletInfo *wallet_info);

void wire_generate_address(int64_t port_, struct wire_WalletInfo *wallet_info);

void wire_request_funds(int64_t port_,
                        struct wire_NetworkInfo *network_info,
                        struct wire_WalletInfo *wallet_info);

void wire_check_balance(int64_t port_, struct wire_WalletInfo *wallet_info);

void wire_create_decentralized_identifier(int64_t port_,
                                          struct wire_NetworkInfo *network_info,
                                          struct wire_WalletInfo *wallet_info);

void wire_bin_to_hex(int64_t port_, struct wire_uint_8_list *val, uintptr_t len);

struct wire_NetworkInfo *new_box_autoadd_network_info_0(void);

struct wire_WalletInfo *new_box_autoadd_wallet_info_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_get_node_info);
    dummy_var ^= ((int64_t) (void*) wire_generate_mnemonic);
    dummy_var ^= ((int64_t) (void*) wire_create_wallet_account);
    dummy_var ^= ((int64_t) (void*) wire_generate_address);
    dummy_var ^= ((int64_t) (void*) wire_request_funds);
    dummy_var ^= ((int64_t) (void*) wire_check_balance);
    dummy_var ^= ((int64_t) (void*) wire_create_decentralized_identifier);
    dummy_var ^= ((int64_t) (void*) wire_bin_to_hex);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_network_info_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wallet_info_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
