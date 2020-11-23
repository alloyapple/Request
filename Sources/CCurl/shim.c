#include "shim.h"

CURLcode curl_easy_setopt_str(CURL *handle, CURLoption option, const char *value)
{
    return curl_easy_setopt(handle, option, value);
}

CURLcode curl_easy_setopt_long(CURL *handle, CURLoption option, long value)
{
    return curl_easy_setopt(handle, option, value);
}

CURLcode curl_easy_setopt_rw_callback(CURL *handle, CURLoption option, rw_callback callback)
{
    return curl_easy_setopt(handle, option, callback);
}

CURLcode curl_easy_setopt_voidp(CURL *handle, CURLoption option, const void *value)
{
    return curl_easy_setopt(handle, option, value);
}

CURLcode curl_easy_setopt_httpheader(CURL *handle, CURLoption option, struct curl_slist *headers)
{
    return curl_easy_setopt(handle, option, headers);
}

CURLcode curl_easy_setopt_mime(CURL *handle, CURLoption option, curl_mime* mimepost) {
    return curl_easy_setopt(handle, option, mimepost);
}

long curl_easy_status_code(CURL *handle)
{
    long response_code = 0;
    curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE, &response_code);
    return response_code;
}

char *curl_get_redirect_url(CURL *handle)
{
    char *location = NULL;
    curl_easy_getinfo(handle, CURLINFO_REDIRECT_URL, &location);
    return location;
}

char *curl_get_effective_url(CURL *handle)
{
    char *location = NULL;
    curl_easy_getinfo(handle, CURLINFO_EFFECTIVE_URL, &location);
    return location;
}
