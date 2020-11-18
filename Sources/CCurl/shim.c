#include "shim.h"

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char* value) {
    return curl_easy_setopt(handle, option, value);
}

CURLcode curl_easy_setopt_long(CURL *handle, CURLoption option, long value) {
    return curl_easy_setopt(handle, option, value);
}

long curl_easy_status_code(CURL *handle) {
    long response_code = 0;
    curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE, &response_code);
    return response_code;
}

