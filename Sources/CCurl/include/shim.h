//
// Created by color on 3/31/19.
//

#ifndef CSQLITE3_SHIM_H
#define CSQLITE3_SHIM_H

#include <curl/curl.h>

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char* value);
CURLcode curl_easy_setopt_long(CURL *handle, CURLoption option, long value);

typedef size_t (*rw_callback)(char *ptr, size_t size, size_t nmemb, void *userdata);
CURLcode curl_easy_setopt_rw_callback(CURL *handle, CURLoption option, rw_callback callback);
CURLcode curl_easy_setopt_voidp(CURL *handle, CURLoption option, const void * value);

long curl_easy_status_code(CURL *handle);

#endif //CSQLITE3_SHIM_H