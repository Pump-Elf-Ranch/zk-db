# Use the official Rust image from the Docker Hub
FROM rust:alpine3.21 AS builder

# Install Git, CMake, and other dependencies
RUN apk add --no-cache \
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

COPY --from=builder /usr/src/zkwasm-typescript-mini-server/target/release/csm_service .

RUN chmod +x csm_service
EXPOSE 3030
