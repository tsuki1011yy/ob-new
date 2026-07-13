FROM python:3.12-slim
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY *.py ./
COPY resources ./resources
COPY scripts ./scripts
COPY dashboard.html .
COPY dashboard_assets ./dashboard_assets
COPY config.example.yaml ./config.yaml

RUN chmod +x scripts/*.sh || true

# 不写 VOLUME,不把桶目录指向 /app 内部——
# 挂载和目录一律交给 Zeabur:环境变量设 OMBRE_BUCKETS_DIR=/data、OMBRE_STATE_DIR=/state
ENV OMBRE_TRANSPORT=streamable-http

EXPOSE 8000 8010

# 双进程内联启动:不依赖任何外部脚本文件
# 任一进程退出,wait -n 返回,容器以非零退出交给平台重启
CMD ["bash", "-c", "python gateway.py & python server.py & wait -n; exit 1"]
