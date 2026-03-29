#!/bin/bash

# Credit Risk Web Deployment Script
# Usage: ./deploy.sh [build|deploy|clean]

set -e

PROJECT_NAME="credit-risk-web"
IMAGE_NAME="credit-risk-web-app"
CONTAINER_NAME="credit-risk-web-container"

echo "🎵 Credit Risk Web Deployment Script"
echo "====================================="

case "$1" in
    
    deploy)
        echo "🚀 Deploying application with Docker..."
        
        # Stop existing container
        echo "Stopping existing container..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        
        # Build image
        echo "Building Docker image..."
        docker build -t $IMAGE_NAME .
        
        # Start container
        echo "Starting container..."
        docker run -d \
            --name $CONTAINER_NAME \
            --restart unless-stopped \
            -p 8190:80 \
            -e NODE_ENV=production \
            --network nacos_net \
            -v /home/docker-app/$PROJECT_NAME/dist:/usr/share/nginx/html \
            -v /home/docker-app/$PROJECT_NAME/nginx.conf:/etc/nginx/nginx.conf \
            $IMAGE_NAME
        
        echo "✅ Deployment completed!"
        ;;
    
    clean)
        echo "🧹 Cleaning up Docker container..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        echo "✅ Cleanup completed!"
        ;;
    
    *)
        echo "Usage: $0 [build|deploy|clean]"
        echo ""
        echo "Commands:"
        echo "  deploy  - Deploy the application using Docker"
        echo "  clean   - Clean up Docker container"
        echo ""
        echo "Examples:"
        echo "  $0 deploy"
        echo "  $0 clean"
        exit 1
        ;;
esac