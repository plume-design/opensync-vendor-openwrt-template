#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/err.h>

#include "osp_sec.h"
#include "osp_unit.h"
#include "log.h"

/* Return encryption key to be used with @ref osp_sec_encrypt()
 * and @ref osp_sec_decrypt()
 *
 * @note: This is a rudimentary reference implementation.
 *
 * You are strongly encouraged to override this reference implementation with
 * your own private version of key generation. Otherwise encryption using a key
 * generated via this reference implementation is just a simple obfuscation.
 * */
bool osp_sec_get_key(void *key, int key_len)
{
    char pass[128];

    if (!osp_unit_id_get(pass, sizeof(pass)))
    {
        LOG(ERROR, "Error getting unit ID");
        return false;
    }

    if (PKCS5_PBKDF2_HMAC(pass, strlen(pass), NULL, 0, 5000, EVP_sha256(), key_len, key) != 1)
    {
        LOG(ERROR, "Error deriving encryption key from a password");
        return false;
    }

    return true;
}
