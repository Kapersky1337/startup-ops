#!/usr/bin/env bash
# ============================================================
# Startup Ops — MCP Bundle Setup Script
# ============================================================
# Configures MCP servers for Claude Code / Claude Desktop.
# This script ONLY writes configuration — it does not install
# any software, download packages, or run arbitrary code.
#
# What it does:
#   1. Asks which integrations you want
#   2. Asks for your API keys
#   3. Writes a config file that Claude reads on startup
#
# Compatible with bash 3.2+ (macOS default).
# ============================================================

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
REGISTRY="$SKILL_DIR/resources/mcp-registry.json"
ENV_FILE="$HOME/.startup-ops.env"
ENV_TMP="$(mktemp /tmp/startup-ops-env.XXXXXX)"

trap "rm -f '$ENV_TMP'" EXIT

# Claude config location
if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_DIR="$HOME/Library/Application Support/Claude"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CONFIG_DIR="$HOME/.config/Claude"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
    CONFIG_DIR="$APPDATA/Claude"
else
    CONFIG_DIR="$HOME/.config/Claude"
fi

CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"
DRY_RUN=false
SELECTED_MCPS=()
INSTALLED_COUNT=0

for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h)
            echo "Usage: bash setup.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run   Preview changes without writing anything"
            echo "  --help      Show this help message"
            echo ""
            echo "This script configures MCP integrations for Claude."
            echo "It writes a config file — it does NOT install software."
            exit 0
            ;;
        *) ;;
    esac
done

# ── Helpers ──────────────────────────────────────────────────
ok()   { echo -e "  ${GREEN}+${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
err()  { echo -e "  ${RED}x${NC} $1"; }
info() { echo -e "  ${DIM}  $1${NC}"; }

set_env_val() { echo "$1=$2" >> "$ENV_TMP"; }
get_env_val() {
    local val
    val=$(grep "^$1=" "$ENV_TMP" 2>/dev/null | tail -1 | cut -d= -f2-)
    echo "$val"
}

# ── Banner ───────────────────────────────────────────────────
print_banner() {
    echo ""
    echo -e "${CYAN}"
    cat << 'BANNER'
   ____  _             _                    ___
  / ___|| |_ __ _ _ __| |_ _   _ _ __     / _ \ _ __  ___
  \___ \| __/ _` | '__| __| | | | '_ \   | | | | '_ \/ __|
   ___) | || (_| | |  | |_| |_| | |_) |  | |_| | |_) \__ \
  |____/ \__\__,_|_|   \__|\__,_| .__/    \___/| .__/|___/
                                 |_|            |_|
BANNER
    echo -e "${NC}"
    echo -e "  ${BOLD}MCP Integration Setup${NC}"
    echo -e "  ${DIM}Connect Claude to the tools your startup uses every day.${NC}"
    echo ""
    echo -e "  ${DIM}────────────────────────────────────────────────────────${NC}"
    echo ""
}

# ── Security Notice ──────────────────────────────────────────
print_security_notice() {
    echo -e "  ${BOLD}Security${NC}"
    echo ""
    echo -e "  This script does ${BOLD}three things only${NC}:"
    echo -e "    1. Asks which tools you want to connect"
    echo -e "    2. Asks for your API keys"
    echo -e "    3. Saves a config file that Claude reads on startup"
    echo ""
    echo -e "  It does ${BOLD}NOT${NC}:"
    echo -e "    ${DIM}- Install any software or packages${NC}"
    echo -e "    ${DIM}- Download anything from the internet${NC}"
    echo -e "    ${DIM}- Run any code besides this script${NC}"
    echo -e "    ${DIM}- Send your keys anywhere (they stay on your machine)${NC}"
    echo ""
    echo -e "  Your API keys are saved locally at:"
    echo -e "    ${DIM}$ENV_FILE (readable only by you)${NC}"
    echo ""
    echo -e "  Your Claude config is saved at:"
    echo -e "    ${DIM}$CONFIG_FILE${NC}"
    echo ""
    echo -e "  ${DIM}Source code: https://github.com/Kapersky1337/startup-ops${NC}"
    echo -e "  ${DIM}────────────────────────────────────────────────────────${NC}"
    echo ""

    read -r -p "  Continue? [Y/n] " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo ""
        echo -e "  ${DIM}No changes made. Run this script again when ready.${NC}"
        echo ""
        exit 0
    fi
}

# ── Step 1: Check Dependencies ──────────────────────────────
check_dependencies() {
    echo ""
    echo -e "  ${BLUE}${BOLD}Step 1 of 4${NC}  ${BOLD}Checking your system${NC}"
    echo ""

    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//')
        MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d. -f1)
        if [[ "$MAJOR_VERSION" -ge 18 ]]; then
            ok "Node.js v$NODE_VERSION"
        else
            err "Node.js $NODE_VERSION is too old (need v18 or newer)"
            echo ""
            echo -e "  ${BOLD}How to fix:${NC}"
            echo "    Go to https://nodejs.org and download the latest version."
            echo "    Or run: brew install node"
            exit 1
        fi
    else
        err "Node.js is not installed"
        echo ""
        echo -e "  ${BOLD}How to fix:${NC}"
        echo "    Go to https://nodejs.org and download the latest version."
        echo "    Or run: brew install node"
        exit 1
    fi

    if command -v npx &> /dev/null; then
        ok "npx available"
    else
        err "npx is not installed (usually comes with Node.js)"
        echo ""
        echo -e "  ${BOLD}How to fix:${NC}"
        echo "    Reinstall Node.js from https://nodejs.org"
        exit 1
    fi

    if command -v jq &> /dev/null; then
        ok "jq available"
    else
        warn "jq is not installed (needed to write your config file)"
        echo ""
        echo -e "  ${BOLD}How to fix:${NC}"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "    Run: brew install jq"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "    Run: sudo apt install jq"
        else
            echo "    Download from: https://jqlang.github.io/jq/download/"
        fi
        exit 1
    fi
}

# ── Step 2: Load Registry and Select MCPs ────────────────────
load_registry() {
    if [[ ! -f "$REGISTRY" ]]; then
        err "Could not find the integration list."
        echo ""
        echo -e "  ${BOLD}How to fix:${NC}"
        echo "    Re-clone the repo: git clone https://github.com/Kapersky1337/startup-ops.git"
        exit 1
    fi
    MCP_KEYS=()
    while IFS= read -r key; do
        MCP_KEYS+=("$key")
    done < <(jq -r '.mcpServers | keys[]' "$REGISTRY")
    ok "Found ${#MCP_KEYS[@]} integrations"
}

select_mcps() {
    echo ""
    echo -e "  ${BLUE}${BOLD}Step 2 of 4${NC}  ${BOLD}Choose your integrations${NC}"
    echo ""
    echo -e "  ${DIM}All integrations are selected by default.${NC}"
    echo -e "  ${DIM}Type a number to toggle it on/off (e.g. \"3 7\").${NC}"
    echo -e "  ${DIM}Press Enter when you're happy with the selection.${NC}"
    echo ""

    local selections=()
    local i
    for i in "${!MCP_KEYS[@]}"; do
        selections+=("1")
    done

    while true; do
        local idx=0
        for key in "${MCP_KEYS[@]}"; do
            local name
            name=$(jq -r ".mcpServers.\"$key\".name" "$REGISTRY")
            local desc
            desc=$(jq -r ".mcpServers.\"$key\".description" "$REGISTRY")
            local needs_key
            needs_key=$(jq -r ".mcpServers.\"$key\".env | length" "$REGISTRY")

            local display_num=$((idx + 1))
            local key_note=""
            if [[ "$needs_key" == "0" ]]; then
                key_note="${GREEN}(no key needed)${NC}"
            fi

            if [[ "${selections[$idx]}" == "1" ]]; then
                echo -e "  ${GREEN}[x]${NC} ${BOLD}${display_num}.${NC} $name ${DIM}-- $desc${NC} $key_note"
            else
                echo -e "  ${DIM}[ ]${NC} ${BOLD}${display_num}.${NC} $name ${DIM}-- $desc${NC} $key_note"
            fi
            ((idx++))
        done

        echo ""
        read -r -p "  Toggle numbers, [a]ll, [n]one, or Enter to continue: " input

        if [[ -z "$input" ]]; then
            break
        elif [[ "$input" == "a" ]]; then
            for i in "${!MCP_KEYS[@]}"; do selections[$i]="1"; done
            echo -e "\n  All selected.\n"
        elif [[ "$input" == "n" ]]; then
            for i in "${!MCP_KEYS[@]}"; do selections[$i]="0"; done
            echo -e "\n  All deselected.\n"
        else
            for num in $input; do
                if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#MCP_KEYS[@]} )); then
                    local arr_idx=$((num - 1))
                    if [[ "${selections[$arr_idx]}" == "1" ]]; then
                        selections[$arr_idx]="0"
                    else
                        selections[$arr_idx]="1"
                    fi
                fi
            done
            echo ""
        fi
    done

    for i in "${!MCP_KEYS[@]}"; do
        if [[ "${selections[$i]}" == "1" ]]; then
            SELECTED_MCPS+=("${MCP_KEYS[$i]}")
        fi
    done

    echo ""
    ok "Selected ${#SELECTED_MCPS[@]} of ${#MCP_KEYS[@]} integrations"
}

# ── Step 3: Collect API Keys ─────────────────────────────────
load_env_file() {
    if [[ -f "$ENV_FILE" ]]; then
        set -a
        source "$ENV_FILE" 2>/dev/null || true
        set +a
        return 0
    fi
    return 1
}

collect_api_keys() {
    echo ""
    echo -e "  ${BLUE}${BOLD}Step 3 of 4${NC}  ${BOLD}Enter your API keys${NC}"
    echo ""
    echo -e "  ${DIM}Your keys are stored locally and never sent anywhere.${NC}"
    echo -e "  ${DIM}Press Enter to skip any key you don't have yet.${NC}"
    echo ""

    if load_env_file; then
        ok "Found previously saved keys"
    fi

    for mcp_key in "${SELECTED_MCPS[@]}"; do
        local name
        name=$(jq -r ".mcpServers.\"$mcp_key\".name" "$REGISTRY")
        local env_keys
        env_keys=$(jq -r ".mcpServers.\"$mcp_key\".env | keys[]" "$REGISTRY" 2>/dev/null || true)

        if [[ -z "$env_keys" ]]; then
            ok "$name -- ready (no key needed)"
            continue
        fi

        echo ""
        echo -e "  ${BOLD}$name${NC}"

        for env_key in $env_keys; do
            local required
            required=$(jq -r ".mcpServers.\"$mcp_key\".env.\"$env_key\".required" "$REGISTRY")
            local description
            description=$(jq -r ".mcpServers.\"$mcp_key\".env.\"$env_key\".description" "$REGISTRY")
            local help_url
            help_url=$(jq -r ".mcpServers.\"$mcp_key\".env.\"$env_key\".helpUrl" "$REGISTRY")

            local current_value=""
            eval "current_value=\"\${$env_key:-}\""

            if [[ -n "$current_value" ]]; then
                local masked="${current_value:0:4}...${current_value:(-4)}"
                ok "$env_key: using saved value ($masked)"
                set_env_val "$env_key" "$current_value"
                continue
            fi

            if [[ "$required" == "true" ]]; then
                echo -e "    $description"
            else
                echo -e "    $description ${DIM}(optional, press Enter to skip)${NC}"
            fi
            echo -e "    ${DIM}Get yours at: $help_url${NC}"

            read -r -p "    $env_key: " value

            if [[ -n "$value" ]]; then
                set_env_val "$env_key" "$value"
                ok "Saved"
            elif [[ "$required" == "true" ]]; then
                warn "Skipped -- $name won't work until you add this key"
            else
                info "Skipped (optional)"
            fi
        done
    done
}

# ── Step 4: Build Config ─────────────────────────────────────
build_config() {
    echo ""
    echo -e "  ${BLUE}${BOLD}Step 4 of 4${NC}  ${BOLD}Writing your config${NC}"
    echo ""

    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$CONFIG_DIR"
    fi

    local existing_config="{}"
    if [[ -f "$CONFIG_FILE" ]]; then
        existing_config=$(cat "$CONFIG_FILE")
        info "Found existing Claude config -- merging (your other settings are safe)"
    fi

    if ! echo "$existing_config" | jq -e '.mcpServers' &>/dev/null; then
        existing_config=$(echo "$existing_config" | jq '. + {"mcpServers": {}}')
    fi

    for mcp_key in "${SELECTED_MCPS[@]}"; do
        local name
        name=$(jq -r ".mcpServers.\"$mcp_key\".name" "$REGISTRY")
        local command
        command=$(jq -r ".mcpServers.\"$mcp_key\".command" "$REGISTRY")
        local args
        args=$(jq -c ".mcpServers.\"$mcp_key\".args" "$REGISTRY")

        local env_obj="{}"
        local env_keys
        env_keys=$(jq -r ".mcpServers.\"$mcp_key\".env | keys[]" "$REGISTRY" 2>/dev/null || true)

        for env_key in $env_keys; do
            local value
            value=$(get_env_val "$env_key")
            if [[ -n "$value" ]]; then
                env_obj=$(echo "$env_obj" | jq --arg k "$env_key" --arg v "$value" '. + {($k): $v}')
            fi
        done

        local server_entry
        if [[ "$env_obj" == "{}" ]]; then
            server_entry=$(jq -n --arg cmd "$command" --argjson args "$args" \
                '{command: $cmd, args: $args}')
        else
            server_entry=$(jq -n --arg cmd "$command" --argjson args "$args" --argjson env "$env_obj" \
                '{command: $cmd, args: $args, env: $env}')
        fi

        if echo "$existing_config" | jq -e ".mcpServers.\"$mcp_key\"" &>/dev/null; then
            info "$name: updating existing config"
        fi

        existing_config=$(echo "$existing_config" | jq --arg key "$mcp_key" --argjson entry "$server_entry" \
            '.mcpServers[$key] = $entry')

        ok "$name"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    done

    if [[ "$DRY_RUN" == true ]]; then
        echo ""
        echo -e "  ${YELLOW}${BOLD}DRY RUN${NC} -- here's what would be written:"
        echo ""
        echo "$existing_config" | jq '.'
    else
        echo "$existing_config" | jq '.' > "$CONFIG_FILE"
        ok "Config saved"
    fi

    # Save env values
    if [[ "$DRY_RUN" == false && -s "$ENV_TMP" ]]; then
        {
            echo "# Startup Ops -- API Keys"
            echo "# Saved on $(date)"
            echo "# This file is read-only by your user account."
            echo ""
            cat "$ENV_TMP"
        } > "$ENV_FILE"
        chmod 600 "$ENV_FILE"
        ok "Keys saved to $ENV_FILE"
    fi
}

# ── Completion ───────────────────────────────────────────────
print_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'DONE_ART'

    _______________________________________________
   |                                               |
   |              Setup complete.                  |
   |                                               |
   |   _____                                       |
   |  |  _  |                                      |
   |  | |_| |  All systems go.                     |
   |  |_____|  Your integrations are configured.   |
   |                                               |
   |_______________________________________________|

DONE_ART
    echo -e "${NC}"
    echo -e "  ${BOLD}What happened:${NC}"
    echo ""
    echo -e "    ${GREEN}+${NC} Configured ${BOLD}$INSTALLED_COUNT${NC} integrations"
    echo -e "    ${GREEN}+${NC} Config file:  ${DIM}$CONFIG_FILE${NC}"
    if [[ -f "$ENV_FILE" ]]; then
        echo -e "    ${GREEN}+${NC} Keys saved:   ${DIM}$ENV_FILE${NC}"
    fi
    echo ""
    echo -e "  ${BOLD}What to do next:${NC}"
    echo ""
    echo "    1. Restart Claude (close and reopen it)"
    echo "    2. Try asking Claude something like:"
    echo ""
    echo -e "       ${DIM}\"Show me my open Linear issues\"${NC}"
    echo -e "       ${DIM}\"Summarize yesterday's meeting from Granola\"${NC}"
    echo -e "       ${DIM}\"Search Slack for messages about the launch\"${NC}"
    echo ""
    echo -e "  ${BOLD}To change your setup later:${NC}"
    echo ""
    echo -e "    Just run this script again."
    echo ""
    echo -e "  ${DIM}────────────────────────────────────────────────────────${NC}"
    echo ""
}

# ── Main ─────────────────────────────────────────────────────
main() {
    print_banner

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "  ${YELLOW}${BOLD}DRY RUN${NC} -- preview only, no files will be changed."
        echo ""
    fi

    print_security_notice
    check_dependencies
    load_registry
    select_mcps

    if [[ ${#SELECTED_MCPS[@]} -eq 0 ]]; then
        echo ""
        echo -e "  ${DIM}No integrations selected. Run this script again when ready.${NC}"
        echo ""
        exit 0
    fi

    collect_api_keys
    build_config
    print_completion
}

main "$@"
