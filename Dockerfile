FROM alpine:latest
WORKDIR /opt
COPY . .

RUN apk add py3-pip

# important, 这里是需要安装alpine缺少的依赖包
RUN apk update && \
    apk add --no-cache ca-certificates && \
    apk add --no-cache --virtual .build-deps gcc musl-dev

COPY requirements.txt ./
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 安装完成后清理缓存
RUN apk del .build-deps gcc musl-dev && \
    rm -rf /var/cache/apk/*


CMD ["gunicorn", "web:app", "-c", "./gunicorn.conf.py"]
