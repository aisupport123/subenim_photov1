#!/bin/bash
set -e
source /venv/main/bin/activate

WORKSPACE=${WORKSPACE:-/workspace}
COMFYUI_DIR="${WORKSPACE}/ComfyUI"

echo "=== DURDOM запускает PHOTO GENERATOR V1 ==="

APT_PACKAGES=()           # если нужно — добавь sudo apt install ...
PIP_PACKAGES=()           # глобальные pip пакеты, если сверх requirements

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
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/Starnodes2024/ComfyUI_StarNodes"
    "https://github.com/DesertPixelAi/ComfyUI-Desert-Pixel-Nodes"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/PozzettiAndrea/ComfyUI-DepthAnythingV3"
    "https://github.com/PGCRT/CRT-Nodes"
)

# ЗАГРУЗКА ФАЙЛОВ НУЖНЫХ
CLIP_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
)

CKPT_MODELS=(
    "https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V16.0_FP32.safetensors"
)

FUN_MODELS=(
    "https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union-2.1.safetensors"
)

TEXT_ENCODERS=(
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
)

UNET_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
)

LORAS=(
    "https://huggingface.co/vilone60/bbox/resolve/main/lenovo_flux_klein9b.safetensors"
)

DIFFUSION_MODELS=(
    "https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors"
)

BBOX_0=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/face_yolov8s.pt"
)

BBOX_1=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/femaleBodyDetection_yolo26.pt"
)

BBOX_2=(
    "https://huggingface.co/vilone60/bbox/resolve/main/female-breast-v4.7.pt"
)

BBOX_3=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/nipples_yolov8s.pt"
)

BBOX_4=(
    "https://huggingface.co/vilone60/bbox/resolve/main/vagina-v4.1.pt"
)

BBOX_5=(
    "https://huggingface.co/gazsuv/xmode/resolve/main/assdetailer.pt"
)
SAM_PTH=(
    "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth"
)

BBOX_6=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyeful_v2-Paired.pt"
)

BBOX_7=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyes.pt"
)

BBOX_8=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/FacesV1.pt"
)

BBOX_9=(
    "https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/hand_yolov8s.pt"
)

BBOX_10=(
    "https://huggingface.co/AunyMoons/loras-pack/blob/main/foot-yolov8l.pt"
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
    echo "# DURDOM PHOTO GENERATOR V1 2025-2026        #"
    echo "# BY RUSLAN & MAPICH                         #"
    echo "##############################################"
    echo ""

    provisioning_get_apt_packages
    provisioning_clone_comfyui
    provisioning_install_base_reqs
    provisioning_get_nodes
    provisioning_get_pip_packages

    provisioning_get_files "${COMFYUI_DIR}/models/clip"               "${CLIP_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/text_encoders"     "${TEXT_ENCODERS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/unet"               "${UNET_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/vae"                "${VAE_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ckpt"               "${CKPT_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/model_patches"      "${FUN_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/diffusion_models"   "${DIFFUSION_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/loras"              "${LORAS[@]}"

    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_0[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_1[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_2[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_3[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_4[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_5[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_6[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_7[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_8[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_9[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_10[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/sams"   "${SAM_PTH[@]}"
    
    provisioning_get_files "${COMFYUI_DIR}/models/upscale_models"     "${UPSCALER_MODELS[@]}"

    echo ""
    echo "DURDOM настроил → Starting ComfyUI..."
    echo ""
}

function provisioning_clone_comfyui() {
    if [[ ! -d "${COMFYUI_DIR}" ]]; then
        echo "DURDOM клонирует ComfyUI..."
        git clone https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_DIR}"
    fi
    cd "${COMFYUI_DIR}"
}

function provisioning_install_base_reqs() {
    if [[ -f requirements.txt ]]; then
        echo "DURDOM установливает base requirements..."
        pip install --no-cache-dir -r requirements.txt
    fi
}

function provisioning_get_apt_packages() {
    if [[ ${#APT_PACKAGES[@]} -gt 0 ]]; then
        echo "DURDOM устанавливает apt packages..."
        sudo apt update && sudo apt install -y "${APT_PACKAGES[@]}"
    fi
}

function provisioning_get_pip_packages() {
    if [[ ${#PIP_PACKAGES[@]} -gt 0 ]]; then
        echo "DURDOM устанавливает extra pip packages..."
        pip install --no-cache-dir "${PIP_PACKAGES[@]}"
    fi
}

function provisioning_get_nodes() {
    mkdir -p "${COMFYUI_DIR}/custom_nodes"
    cd "${COMFYUI_DIR}/custom_nodes"

    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="./${dir}"

        if [[ -d "$path" ]]; then
            echo "Updating node: $dir"
            (cd "$path" && git pull --ff-only 2>/dev/null || { git fetch && git reset --hard origin/main; })
        else
            echo "Cloning node: $dir"
            git clone "$repo" "$path" --recursive || echo " [!] Clone failed: $repo"
        fi

        requirements="${path}/requirements.txt"
        if [[ -f "$requirements" ]]; then
            echo "Installing deps for $dir..."
            pip install --no-cache-dir -r "$requirements" || echo " [!] pip requirements failed for $dir"
        fi
    done
}

function provisioning_get_files() {
    if [[ $# -lt 2 ]]; then return; fi
    local dir="$1"
    shift
    local files=("$@")

    mkdir -p "$dir"
    echo "Скачивание ${#files[@]} file(s) → $dir..."

    for url in "${files[@]}"; do
        echo "→ $url"
        local auth_header=""
        if [[ -n "$HF_TOKEN" && "$url" =~ huggingface\.co ]]; then
            auth_header="--header=Authorization: Bearer $HF_TOKEN"
        elif [[ -n "$CIVITAI_TOKEN" && "$url" =~ civitai\.com ]]; then
            auth_header="--header=Authorization: Bearer $CIVITAI_TOKEN"
        fi

        wget $auth_header -nc --content-disposition --show-progress -e dotbytes=4M -P "$dir" "$url" || echo " [!] Download failed: $url"
        echo ""
    done
}

# Запуск provisioning если не отключен
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi

# Запуск ComfyUI
echo "=== DURDOM запускает ComfyUI ==="
cd "${COMFYUI_DIR}"
python main.py --listen 0.0.0.0 --port 8188
