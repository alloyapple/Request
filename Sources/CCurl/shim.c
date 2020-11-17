#include "shim.h"

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char* value) {
    return curl_easy_setopt(handle, option, value);
}