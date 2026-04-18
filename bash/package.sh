#!/bin/bash
set -euo pipefail

OUT_DIR="/mnt/hgfs/share/meme"
SRC_ROOTFS="/source/rootfs"
ZIMAGE="/tftpboot/zImage"

# 创建输出目录
mkdir -p "$OUT_DIR"

# 打包函数
pack() {
    local name="$1"
    local path="$2"
    local outfile="${name}.tar.xz"
    local hashfile="${outfile}.sha256"

    if [[ ! -d "$path" ]]; then
        echo "Warning: $path not found, skip"
        return
    fi

    # 计算目录内容 hash（稳定、与时间无关）
    local new_hash
    new_hash=$(tar -cf - \
        --sort=name \
        --mtime='UTC 1970-01-01' \
        --owner=0 --group=0 --numeric-owner \
        -C "$(dirname "$path")" "$(basename "$path")" \
        | sha256sum | awk '{print $1}')

    # 如果已有旧 hash 且一致 → 跳过
    if [[ -f "$hashfile" ]]; then
        local old_hash
        old_hash=$(cat "$hashfile")
        if [[ "$new_hash" == "$old_hash" ]]; then
            echo "Skip $name (no changes)"
            return
        fi
    fi

    # 重新打包
    echo "Packing $name..."
    tar -Jchf "$outfile" \
        -C "$(dirname "$path")" "$(basename "$path")"

    # 更新 hash
    echo "$new_hash" > "$hashfile"
}

# 打包列表
pack "qtpj" "$HOME/qtpj"
pack "qttools" "$HOME/qttools"
pack "rootfs" "$SRC_ROOTFS"

# 移动压缩包
mv ./*.tar.xz "$OUT_DIR"

# 拷贝内核
if [[ -f "$ZIMAGE" ]]; then
    cp "$ZIMAGE" "$OUT_DIR"
else
    echo "Warning: zImage not found"
fi
