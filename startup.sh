#!/bin/bash
set -e
source /venv/main/bin/activate

WORKSPACE=${WORKSPACE:-/workspace}
COMFYUI_DIR="${WORKSPACE}/ComfyUI"

echo "=== subenim запускает PHOTO GENERATOR V1 ==="

APT_PACKAGES=()
PIP_PACKAGES=()

CLIP_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
)

CKPT_MODELS=(
    "https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V16.0_FP16.safetensors"
)

FUN_MODELS=(
    "https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union-2.1.safetensors"
)

UNET_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
)

LORAS=(
    "https://huggingface.co/vilone60/bbox/resolve/main/lenovo_flux_klein9b.safetensors"
    "https://huggingface.co/vilone60/flux_nsfw/resolve/main/Realism%20Lora%20By%20Stable%20Yogi_V3_Lite.safetensors"
    "https://huggingface.co/vilone60/flux_nsfw/resolve/main/realisticAnatomy-by-darkHUB.safetensors"
)

DIFFUSION_MODELS=(
    "https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors"
)


NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/kijai/ComfyUI-WanVideoWrapper"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/chflame163/ComfyUI_LayerStyle"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/ClownsharkBatwing/RES4LYF"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/Smirnov75/ComfyUI-mxToolkit"
    "https://github.com/TheLustriVA/ComfyUI-Image-Size-Tools"
    "https://github.com/ZhiHui6/zhihui_nodes_comfyui"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/crystian/ComfyUI-Crystools"
    "https://github.com/jnxmx/ComfyUI_HuggingFace_Downloader"
    "https://github.com/plugcrypt/CRT-Nodes"
    "https://github.com/EllangoK/ComfyUI-post-processing-nodes"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/Starnodes2024/ComfyUI_StarNodes"
    "https://github.com/DesertPixelAi/ComfyUI-Desert-Pixel-Nodes"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/PozzettiAndrea/ComfyUI-DepthAnythingV3"
    "https://github.com/PGCRT/CRT-Nodes"
)

BBOX_MODELS=(
    "https://huggingface.co/vilone60/bbox23/resolve/main/Eyes.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Face.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Foot.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Hands.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Nipples.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Penis.pt"
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyeful_v2-Paired.pt"
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyes.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Pussy.pt"
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/hand_yolov8s.pt"
    "https://huggingface.co/vilone60/bbox23/resolve/main/Pussy2.pt"
)

SAM_PTH=(
    "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth"
)

UPSCALER_MODELS=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/4xUltrasharp_4xUltrasharpV10.pt"
)

### ─────────────────────────────────────────────
### DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING
### ─────────────────────────────────────────────

function provisioning_start() {
    echo ""
    echo "##############################################"
    echo "# FUCK THIS WORLD                            #"
    echo "# subenim photO v2  2026-2027                #"
    echo "# BY @againstdrugs                           #"
    echo "##############################################"
    echo ""

    provisioning_get_apt_packages
    provisioning_clone_comfyui
    provisioning_install_base_reqs
    provisioning_get_nodes
    provisioning_get_pip_packages

    # Все загрузки файлов параллельно
    provisioning_get_files "${COMFYUI_DIR}/models/clip"               "${CLIP_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/unet"               "${UNET_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/vae"                "${VAE_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/ckpt"               "${CKPT_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/model_patches"      "${FUN_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/diffusion_models"   "${DIFFUSION_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/loras"              "${LORAS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_MODELS[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/sams"               "${SAM_PTH[@]}" &
    provisioning_get_files "${COMFYUI_DIR}/models/upscale_models"     "${UPSCALER_MODELS[@]}" &
    wait

    echo ""
    echo "subenim настроил → Starting ComfyUI..."
    echo ""
}

function provisioning_clone_comfyui() {
    if [[ ! -d "${COMFYUI_DIR}" ]]; then
        echo "subenim клонирует ComfyUI..."
        git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_DIR}"
    fi
    cd "${COMFYUI_DIR}"
}

function provisioning_install_base_reqs() {
    if [[ -f requirements.txt ]]; then
        echo "subenim устанавливает base requirements..."
        pip install --no-cache-dir -q -r requirements.txt
    fi
}

function provisioning_get_apt_packages() {
    if [[ ${#APT_PACKAGES[@]} -gt 0 ]]; then
        echo "subenim устанавливает apt packages..."
        sudo apt update && sudo apt install -y "${APT_PACKAGES[@]}"
    fi
}

function provisioning_get_pip_packages() {
    if [[ ${#PIP_PACKAGES[@]} -gt 0 ]]; then
        echo "subenim устанавливает extra pip packages..."
        pip install --no-cache-dir -q "${PIP_PACKAGES[@]}"
    fi
}

function provisioning_get_nodes() {
    mkdir -p "${COMFYUI_DIR}/custom_nodes"
    cd "${COMFYUI_DIR}/custom_nodes"

    # Клонируем все ноды параллельно
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="./${dir}"

        if [[ -d "$path" ]]; then
            (cd "$path" && git pull --ff-only 2>/dev/null || { git fetch && git reset --hard origin/main; }) &
        else
            git clone --depth=1 "$repo" "$path" --recursive 2>/dev/null || echo " [!] Clone failed: $repo" &
        fi
    done
    wait

    # Ставим pip зависимости параллельно
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="./${dir}"
        requirements="${path}/requirements.txt"
        if [[ -f "$requirements" ]]; then
            pip install --no-cache-dir -q -r "$requirements" &
        fi
    done
    wait
}

function provisioning_get_files() {
    if [[ $# -lt 2 ]]; then return; fi
    local dir="$1"
    shift
    local files=("$@")

    mkdir -p "$dir"

    for url in "${files[@]}"; do
        local auth_header=""
        if [[ -n "$HF_TOKEN" && "$url" =~ huggingface\.co ]]; then
            auth_header="--header=Authorization: Bearer $HF_TOKEN"
        elif [[ -n "$CIVITAI_TOKEN" && "$url" =~ civitai\.com ]]; then
            auth_header="--header=Authorization: Bearer $CIVITAI_TOKEN"
        fi

        wget $auth_header -nc -q --content-disposition -P "$dir" "$url" || echo " [!] Download failed: $url"
    done
}

# Запуск provisioning если не отключен
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi

echo -e "${MAGENTA}"
echo "███████╗██╗   ██╗██████╗ ███████╗███╗   ██╗██╗███╗   ███╗"
echo "██╔════╝██║   ██║██╔══██╗██╔════╝████╗  ██║██║████╗ ████║"
echo "███████╗██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║██╔████╔██║"
echo "╚════██║██║   ██║██╔══██╗██╔══╝  ██║╚██╗██║██║██║╚██╔╝██║"
echo "███████║╚██████╔╝██████╔╝███████╗██║ ╚████║██║██║ ╚═╝ ██║"
echo "╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝"
echo -e "${NC}"
echo -e "${CYAN}[subenim] >> SYSTEM BOOT <<${NC}"

# Запуск ComfyUI
echo "=== subenim запускает ComfyUI ==="
cd "${COMFYUI_DIR}"
python main.py --listen 0.0.0.0 --port 8188
