#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Alexa Remote Control"

REFRESH_TOKEN=$(bashio::config 'refresh_token')

if [ -z "$REFRESH_TOKEN" ]; then
    bashio::log.error "No refresh token provided"
    exit 1
fi

LANGUAGE=$(bashio::config 'language')
if [ -z "$LANGUAGE" ]; then
    bashio::log.error "No language provided"
    exit 1
fi

TTS_LOCALE=$(bashio::config 'tts_locale')
if [ -z "$TTS_LOCALE" ]; then
    bashio::log.error "No TTS locale provided"
    exit 1
fi

AMAZON_DOMAIN=$(bashio::config 'amazon_domain')
if [ -z "$AMAZON_DOMAIN" ]; then
    bashio::log.error "No Amazon domain provided"
    exit 1
fi

ALEXA_DOMAIN=$(bashio::config 'alexa_domain')
if [ -z "$ALEXA_DOMAIN" ]; then
    bashio::log.error "No Alexa domain provided"
    exit 1
fi

readonly CONTROL_SCRIPT_DIR="/data/alexa-remote-control"

if [ ! -d "$CONTROL_SCRIPT_DIR" ]; then
    bashio::log.info "Alexa Remote Control directory not found, cloning from GitHub"
    git clone 'https://github.com/thorsten-gehrig/alexa-remote-control' "$CONTROL_SCRIPT_DIR"
    bashio::log.info "Cloning finished"
fi

readonly CONTROL_SCRIPT_NAME='alexa_remote_control.sh'
readonly CONTROL_SCRIPT_PATH="$CONTROL_SCRIPT_DIR/$CONTROL_SCRIPT_NAME"

export REFRESH_TOKEN
export LANGUAGE
export TTS_LOCALE
export AMAZON="$AMAZON_DOMAIN"
export ALEXA="$ALEXA_DOMAIN"

bashio::log.info "Arguments: " "$@"

"$CONTROL_SCRIPT_PATH" "$@"

bashio::log.info "Alexa Remote Control finished"
