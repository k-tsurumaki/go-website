# ================================
# 1. Build stage
# ================================
FROM golang:1.25 AS builder

WORKDIR /app

# Go module filesを先にコピー（キャッシュ効く）
COPY go.mod ./
RUN go env -w GOPROXY=https://proxy.golang.org && go mod download

# 残りのソースコードコピー
COPY . .

# Linux用の静的バイナリをビルド
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server main.go

# ================================
# 2. Runtime stage
# ================================
FROM alpine:3.20

WORKDIR /app

# ビルドしたバイナリをコピー
COPY --from=builder /app/server .

# templates ディレクトリをコピー
COPY --from=builder /app/templates ./templates

# ポート公開（デフォルト8080）
EXPOSE 8080

# 本番実行コマンド
CMD ["./server"]