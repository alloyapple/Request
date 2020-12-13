//
// Created by color on 3/31/19.
//

#ifndef CSQLITE3_SHIM_H
#define CSQLITE3_SHIM_H

#include <curl/curl.h>
static long curlauth_any = CURLAUTH_ANY;

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char *value);
CURLcode curl_easy_setopt_long(CURL *handle, CURLoption option, long value);

typedef size_t (*rw_callback)(unsigned char *ptr, size_t size, size_t nmemb, void *userdata);
CURLcode curl_easy_setopt_rw_callback(CURL *handle, CURLoption option, rw_callback callback);

CURLcode curl_easy_setopt_voidp(CURL *handle, CURLoption option, const void *value);
CURLcode curl_easy_setopt_httpheader(CURL *handle, CURLoption option, struct curl_slist *headers);

typedef int32_t (*progress_callback)(void *clientp, double dltotal, double dlnow, double ultotal, double ulnow);
CURLcode curl_easy_setopt_progressfunction(CURL *handle, CURLoption option, progress_callback callback);

CURLcode curl_easy_setopt_mime(CURL *handle, CURLoption option, curl_mime *mimepost);

long curl_easy_status_code(CURL *handle);
char *curl_get_redirect_url(CURL *handle);
char *curl_get_effective_url(CURL *handle);
struct curl_slist *curl_get_cookie(CURL *handle);

#endif //CSQLITE3_SHIM_H