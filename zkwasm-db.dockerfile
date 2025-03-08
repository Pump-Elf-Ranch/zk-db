# Use the official Rust image from the Docker Hub
FROM rust:latest AS builder
# Install Node.js 18.6
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs=18.6.0-1nodesource1

# Install Git
RUN apt-get update && apt-get install -y git

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    pkg-config \
    libssl-dev \
    libclang-dev \
    curl


# Set the working directory inside the container
WORKDIR /usr/src/

# Clone the GitHub repository
RUN git clone https://github.com/DelphinusLab/zkwasm-typescript-mini-server --branch release-v1

WORKDIR /usr/src/zkwasm-typescript-mini-server/dbservice

# Build the application
RUN cargo build --release

FROM alpine:latest

WORKDIR /zkdb

COPY --from=builder /usr/src/zkwasm-typescript-mini-server/target/release/csm_service /zkdb/csm_service

EXPOSE 3030
