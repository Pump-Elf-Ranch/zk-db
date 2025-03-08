# 第一阶段：构建 Rust 项目
FROM rust:latest AS builder

# 安装构建依赖，包括 musl 和 g++
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    pkg-config \
    libssl-dev \
    libclang-dev \
    curl

# 设置工作目录
WORKDIR /usr/src/

# 克隆代码仓库
RUN git clone https://github.com/DelphinusLab/zkwasm-typescript-mini-server --branch release-v1

WORKDIR /usr/src/zkwasm-typescript-mini-server/dbservice

# 使用 musl 目标进行编译
RUN cargo build --release 

# 第二阶段：最小 Debian 运行环境
FROM debian:latest

WORKDIR /zkdb

# 复制静态编译后的二进制文件
COPY --from=builder /usr/src/zkwasm-typescript-mini-server/target/release/csm_service .

RUN chmod +x csm_service

# 运行端口
EXPOSE 3030
