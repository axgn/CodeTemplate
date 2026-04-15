# ========= 可配置变量 =========
SRC_DIR := src            # 需要编译的源码目录
BUILD_DIR := build        # 编译输出目录
TARGET := app             # 输出程序名
ARCHIVE := archive.tar.gz # 压缩文件名

# 编译器
CC := gcc
CFLAGS := -Wall -O2

# 自动收集源文件
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

# ========= 默认目标 =========
all: build

# ========= 编译 =========
build: $(BUILD_DIR) $(OBJS)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(TARGET) $(OBJS)

# 编译规则
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# 创建 build 目录
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ========= 压缩当前目录 =========
pack:
	tar -czf $(ARCHIVE) .

# ========= 解压 =========
unpack:
	tar -xzf $(ARCHIVE)

# ========= 在指定目录执行 make =========
make-in-dir:
	$(MAKE) -C $(SRC_DIR)

# ========= 清理 =========
clean:
	rm -rf $(BUILD_DIR) $(ARCHIVE)

# ========= 伪目标 =========
.PHONY: all build pack unpack clean make-in-dir
