//
// Created by color on 3/31/19.
//

#ifndef CSQLITE3_SHIM_H
#define CSQLITE3_SHIM_H

#include <curl/curl.h>

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char* value);
CURLcode curl_easy_setopt_long(CURL *handle, CURLoption option, long value);

long curl_easy_status_code(CURL *handle);

#endif //CSQLITE3_SHIM_H