<%--
  Created by IntelliJ IDEA.
  User: NJHTR
  Date: 2025/6/20
  Time: 1:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        // 获取Token的完整Authorization头
        function getAuthorizationHeader() {
            const token = localStorage.getItem('token');
            return token ? `Bearer ${token}` : '';
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script>
        // 存储购物车商品数量的全局变量
        let cartItemCount = 0;

        // 页面加载时获取token并加载购物车数据
        document.addEventListener('DOMContentLoaded', async function() {
            // 获取token
            const token = localStorage.getItem('token');
            console.log(token)
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            // 显示加载动画
            document.getElementById('loadingIndicator').style.display = 'block';

            try {

                // 获取购物车数据
                const response = await axios.get('http://localhost:8181/cart', {
                    headers: { Authorization: getAuthorizationHeader() }
                });

                if (response.data.code === 0) {
                    cartItemCount = response.data.data.length;
                    renderCartItems(response.data.data);
                } else {
                    throw new Error(response.data.message || '获取购物车数据失败');
                }
            } catch (error) {
                console.error('加载购物车出错:', error);
                alert('加载购物车失败: ' + error.message);
            } finally {
                // 隐藏加载动画
                document.getElementById('loadingIndicator').style.display = 'none';
            }

            // 更新导航栏购物车数量
            document.querySelector('.cart-count').textContent = cartItemCount;
        });

        // 渲染购物车项目
        function renderCartItems(cartItems) {
            const cartItemsContainer = document.getElementById('cart-items');
            const cartSummary = document.getElementById('cart-summary');

            // 清空容器
            cartItemsContainer.innerHTML = '';

            if (cartItems.length === 0) {
                cartItemsContainer.innerHTML = `
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart fa-4x"></i>
                        <h3>您的购物车是空的</h3>
                        <p>去看看有什么喜欢的商品吧</p>
                        <a href="home.jsp" class="btn primary">去逛逛</a>
                    </div>
                `;

                // 隐藏结算区
                cartSummary.style.display = 'none';
                return;
            }

            // 计算总价
            let totalPrice = 0;

            // 渲染每个商品项
            cartItems.forEach(item => {
                const subtotal = item.productPrice * item.quantity;
                totalPrice += subtotal;

                cartItemsContainer.innerHTML += `
                    <div class="cart-item" data-id="${item.id}">
                        <div class="cart-item-image">
                            <img src="${item.productImage}" alt="${item.productName}">
                        </div>
                        <div class="cart-item-details">
                            <h3>${item.productName}</h3>
                            <p>单价: ¥${item.productPrice.toFixed(2)}</p>
                            <div class="cart-item-actions">
                                <button class="btn quantity-btn" onclick="updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                                <input type="number" min="1" value="${item.quantity}" class="quantity-input"
                                    onchange="updateQuantity(${item.id}, this.value)" onblur="validateQuantity(this)">
                                <button class="btn quantity-btn" onclick="updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                                <button class="btn delete-btn" onclick="removeCartItem(${item.id})">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                        <div class="cart-item-price">
                            <div>小计</div>
                            <div class="subtotal">¥${subtotal.toFixed(2)}</div>
                        </div>
                    </div>
                `;
            });

            // 更新总价
            document.getElementById('cart-total').textContent = `¥${totalPrice.toFixed(2)}`;

            // 显示结算区
            cartSummary.style.display = 'flex';
        }

        // 验证数量输入
        function validateQuantity(input) {
            if (input.value < 1) {
                input.value = 1;
            }
        }

        // 更新商品数量
        async function updateQuantity(itemId, newQuantity) {
            if (newQuantity < 1) return;

            const token = localStorage.getItem('token');
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            try {
                // 显示加载状态
                const cartItem = document.querySelector(`.cart-item[data-id="${itemId}"]`);
                cartItem.classList.add('updating');

                // 发送更新请求
                const response = await axios.put(`http://localhost:8181/cart/${itemId}`, {
                    quantity: parseInt(newQuantity)
                }, {
                    headers: { Authorization: getAuthorizationHeader() }
                });

                if (response.data.code === 0) {
                    // 更新页面显示
                    const subtotal = response.data.data.productPrice * newQuantity;
                    cartItem.querySelector('.quantity-input').value = newQuantity;
                    cartItem.querySelector('.subtotal').textContent = `¥${subtotal.toFixed(2)}`;

                    // 重新计算总价
                    recalculateTotal();

                    // 更新购物车数量
                    await updateCartItemCount();
                } else {
                    throw new Error(response.data.message || '更新数量失败');
                }
            } catch (error) {
                console.error('更新数量出错:', error);
                alert('更新失败: ' + error.message);
            } finally {
                // 移除加载状态
                if (document.querySelector(`.cart-item[data-id="${itemId}"]`)) {
                    document.querySelector(`.cart-item[data-id="${itemId}"]`).classList.remove('updating');
                }
            }
        }

        // 删除购物车项目
        async function removeCartItem(itemId) {
            if (!confirm('确定要从购物车中删除此商品吗?')) return;

            const token = localStorage.getItem('token');
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            try {
                // 显示加载状态
                const cartItem = document.querySelector(`.cart-item[data-id="${itemId}"]`);
                cartItem.classList.add('deleting');

                // 发送删除请求
                const response = await axios.delete(`http://localhost:8181/cart/${itemId}`, {
                    headers: { Authorization: getAuthorizationHeader() }
                });

                if (response.data.code === 0) {
                    // 从DOM中删除
                    cartItem.remove();

                    // 更新总价
                    recalculateTotal();

                    // 更新购物车数量
                    await updateCartItemCount();

                    // 如果购物车空了
                    if (document.querySelectorAll('.cart-item').length === 0) {
                        renderCartItems([]);
                    }
                } else {
                    throw new Error(response.data.message || '删除商品失败');
                }
            } catch (error) {
                console.error('删除商品出错:', error);
                alert('删除失败: ' + error.message);
            }
        }

        // 重新计算总价
        function recalculateTotal() {
            let total = 0;
            document.querySelectorAll('.cart-item').forEach(item => {
                const subtotal = parseFloat(item.querySelector('.subtotal').textContent.replace('¥', ''));
                total += subtotal;
            });

            document.getElementById('cart-total').textContent = `¥${total.toFixed(2)}`;
        }

        // 更新购物车数量
        async function updateCartItemCount() {
            const token = localStorage.getItem('token');
            if (!token) return;

            try {
                const response = await axios.get('http://localhost:8181/cart/count', {
                    headers: { Authorization: getAuthorizationHeader() }
                });

                if (response.data.code === 0) {
                    cartItemCount = response.data.data.count;
                    document.querySelector('.cart-count').textContent = cartItemCount;
                } else {
                    throw new Error(response.data.message || '获取购物车数量失败');
                }
            } catch (error) {
                console.error('更新购物车数量出错:', error);
            }
        }

        // 结算功能
        function checkout() {
            alert('结算功能即将推出!');
            // window.location.href = 'checkout.jsp';
        }

        // 返回首页
        function goToHomepage() {
            window.location.href = 'home.jsp';
        }
    </script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f0f5ff, #e6f7ff);
            color: #333;
            padding: 20px;
        }

        /* 气泡背景 */
        .bubbles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }

        .bubble {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(5px);
            animation: float 15s infinite ease-in-out;
            bottom: -150px;
        }

        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); }
            100% { transform: translateY(-1000px) rotate(360deg); }
        }

        /* 页面容器 */
        .glass-container {
            max-width: 1200px;
            margin: 20px auto;
            display: flex;
            flex-direction: column;
            gap: 25px;
            z-index: 10;
        }

        /* 导航栏 */
        .navbar {
            background: rgba(255, 255, 255, 0.35);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1),
            inset 0 0 15px rgba(255, 255, 255, 0.5);
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #4B70E2;
            font-weight: 700;
            font-size: 24px;
        }

        .logo-icon {
            background: #4B70E2;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 4px 12px rgba(75, 112, 226, 0.3);
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-link {
            color: #3a3f5c;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 12px;
            transition: all 0.3s;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(75, 112, 226, 0.1);
            color: #4B70E2;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .cart-icon, .user-icon {
            background: rgba(255, 255, 255, 0.6);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
            color: #4B70E2;
            position: relative;
            cursor: pointer;
            transition: all 0.3s;
        }

        .cart-icon:hover, .user-icon:hover {
            background: rgba(75, 112, 226, 0.15);
            transform: translateY(-3px);
        }

        .cart-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff6b6b;
            color: white;
            font-size: 12px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 700;
        }

        /* 购物车标题 */
        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 30px 0 20px;
        }

        .cart-title {
            font-size: 32px;
            background: linear-gradient(135deg, #4B70E2, #8d6ee5);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            letter-spacing: 1px;
        }

        .continue-shopping {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
            font-weight: 600;
            color: #4B70E2;
            text-decoration: none;
            background: rgba(75, 112, 226, 0.1);
            padding: 10px 20px;
            border-radius: 12px;
            transition: all 0.3s;
        }

        .continue-shopping:hover {
            background: rgba(75, 112, 226, 0.2);
            transform: translateY(-2px);
        }

        /* 购物车内容区 */
        .cart-container {
            background: rgba(255, 255, 255, 0.35);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1),
            inset 0 0 15px rgba(255, 255, 255, 0.5);
            padding: 30px;
        }

        /* 购物车项目 */
        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }

        .cart-item {
            display: flex;
            gap: 20px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.4);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            align-items: center;
            position: relative;
            transition: all 0.3s;
            opacity: 1;
        }

        .cart-item:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
        }

        .cart-item.updating::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.7);
            border-radius: 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #4B70E2;
            font-size: 14px;
            font-weight: 600;
            backdrop-filter: blur(2px);
        }

        .cart-item.deleting {
            transform: scale(0.95);
            opacity: 0.5;
        }

        .cart-item-image {
            width: 120px;
            height: 120px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
        }

        .cart-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cart-item-details {
            flex: 1;
        }

        .cart-item-details h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #3a3f5c;
        }

        .cart-item-details p {
            color: #6a6e8d;
            margin-bottom: 15px;
        }

        .cart-item-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .quantity-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: white;
            border: 1px solid #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .quantity-btn:hover {
            background: #4B70E2;
            color: white;
            border-color: #4B70E2;
        }

        .quantity-input {
            width: 50px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 14px;
        }

        .delete-btn {
            background: transparent;
            border: none;
            color: #ff6b6b;
            font-size: 16px;
            cursor: pointer;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: all 0.3s;
            margin-left: 15px;
        }

        .delete-btn:hover {
            background: rgba(255, 107, 107, 0.1);
        }

        .cart-item-price {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            min-width: 100px;
            font-weight: 600;
            color: #6a6e8d;
        }

        .cart-item-price div:first-child {
            font-size: 14px;
            margin-bottom: 5px;
        }

        .subtotal {
            font-size: 18px;
            color: #4B70E2;
            font-weight: 700;
        }

        /* 空购物车 */
        .empty-cart {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 20px;
            text-align: center;
            color: #6a6e8d;
        }

        .empty-cart i {
            color: #c7c9d5;
            margin-bottom: 20px;
        }

        .empty-cart h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #3a3f5c;
        }

        .empty-cart p {
            margin-bottom: 25px;
            max-width: 400px;
            line-height: 1.6;
        }

        /* 购物车汇总 */
        #cart-summary {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            display: flex;
            flex-direction: column;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .summary-title {
            font-size: 24px;
            color: #3a3f5c;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
            color: #6a6e8d;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
            font-size: 20px;
            font-weight: 700;
            color: #4B70E2;
        }

        .checkout-btn {
            background: #4B70E2;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 16px;
            margin-top: 30px;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(75, 112, 226, 0.3);
            width: 100%;
        }

        .checkout-btn:hover {
            background: #3a5bc7;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(75, 112, 226, 0.4);
        }

        .checkout-btn:disabled {
            background: #a8b7e8;
            cursor: not-allowed;
        }

        /* 加载指示器 */
        #loadingIndicator {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid rgba(75, 112, 226, 0.3);
            border-radius: 50%;
            border-top: 5px solid #4B70E2;
            animation: spin 1s linear infinite;
            margin-bottom: 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-text {
            color: #4B70E2;
            font-size: 18px;
            font-weight: 600;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .cart-item {
                flex-wrap: wrap;
            }

            .cart-item-price {
                width: 100%;
                align-items: flex-end;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid rgba(0, 0, 0, 0.05);
            }
        }

        @media (max-width: 576px) {
            .cart-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .cart-item-details {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="bubbles" id="bubbles"></div>

<!-- 加载指示器 -->
<div id="loadingIndicator">
    <div class="spinner"></div>
    <div class="loading-text">加载购物车中...</div>
</div>

<div class="glass-container">
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-shopping-bag"></i>
            </div>
            <span>GlassMart</span>
        </div>

        <div class="nav-links">
            <a href="home.jsp" class="nav-link">首页</a>
            <a href="#" class="nav-link">商店</a>
            <a href="#" class="nav-link">类别</a>
            <a href="#" class="nav-link">限时优惠</a>
            <a href="cart.jsp" class="nav-link active">购物车</a>
        </div>

        <div class="nav-actions">
            <div class="cart-icon">
                <i class="fas fa-shopping-cart"></i>
                <div class="cart-count">0</div>
            </div>
            <div class="user-icon">
                <i class="fas fa-user"></i>
            </div>
        </div>
    </nav>

    <!-- 购物车标题 -->
    <div class="cart-header">
        <h1 class="cart-title">我的购物车</h1>
        <a href="home.jsp" class="continue-shopping">
            <i class="fas fa-arrow-left"></i> 继续购物
        </a>
    </div>

    <!-- 购物车内容区 -->
    <div class="cart-container">
        <div id="cart-items" class="cart-items">
            <!-- 购物车商品会在这里动态渲染 -->
        </div>

        <!-- 购物车汇总 -->
        <div id="cart-summary" class="cart-summary">
            <h2 class="summary-title">订单摘要</h2>
            <div class="summary-item">
                <span>商品数量</span>
                <span id="item-count">0</span>
            </div>
            <div class="summary-item">
                <span>运费</span>
                <span>¥0.00</span>
            </div>
            <div class="summary-total">
                <span>总计</span>
                <span id="cart-total">¥0.00</span>
            </div>
            <button id="checkout-button" class="checkout-btn" onclick="checkout()">
                结算 <i class="fas fa-arrow-right"></i>
            </button>
        </div>
    </div>
</div>

<script>
    // 生成气泡背景
    function createBubbles() {
        const bubblesContainer = document.getElementById('bubbles');
        for (let i = 0; i < 15; i++) {
            const bubble = document.createElement('div');
            bubble.classList.add('bubble');

            // 随机大小和位置
            const size = Math.random() * 120 + 20;
            const posX = Math.random() * 100;
            const delay = Math.random() * 15;
            const duration = Math.random() * 20 + 10;

            bubble.style.width = `${size}px`;
            bubble.style.height = `${size}px`;
            bubble.style.left = `${posX}%`;
            bubble.style.animationDelay = `${delay}s`;
            bubble.style.animationDuration = `${duration}s`;

            bubblesContainer.appendChild(bubble);
        }
    }

    // 添加3D倾斜效果
    function add3dEffect() {
        const container = document.querySelector('.glass-container');

        function onMouseMove(e) {
            const rect = container.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;
            const mouseX = e.clientX - centerX;
            const mouseY = e.clientY - centerY;

            // 计算旋转角度（适度限制）
            const rotateY = (mouseX / centerX) * 1.5;
            const rotateX = (mouseY / centerY) * -1.5;

            container.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            container.style.transition = 'transform 0.1s';
        }

        function resetCard() {
            container.style.transform = 'perspective(1000px) rotateX(0) rotateY(0)';
            container.style.transition = 'transform 0.5s';
        }

        container.addEventListener('mousemove', onMouseMove);
        container.addEventListener('mouseleave', resetCard);
    }

    // 初始化
    document.addEventListener('DOMContentLoaded', function() {
        createBubbles();
        add3dEffect();
    });
</script>
<script>
    // 设置API基础URL
    const API_BASE_URL = 'http://localhost:8181';

    // 从localStorage获取token
    function getToken() {
        return localStorage.getItem('token') || '';
    }

    // 渲染购物车商品
    async function renderCartItems(cartItems) {
        const cartItemsContainer = document.getElementById('cart-items');
        const cartSummary = document.getElementById('cart-summary');

        cartItemsContainer.innerHTML = '';

        if (cartItems.length === 0) {
            cartItemsContainer.innerHTML = `
            <div class="empty-cart">
                <i class="fas fa-shopping-cart fa-4x"></i>
                <h3>您的购物车是空的</h3>
                <p>去看看有什么喜欢的商品吧</p>
                <a href="home.jsp" class="btn primary">去逛逛</a>
            </div>
        `;
            cartSummary.style.display = 'none';
            return;
        }

        // 计算总价
        let totalPrice = 0;
        let itemCount = 0;

        // 渲染每个商品项
        cartItems.forEach(item => {
            const subtotal = item.productPrice * item.quantity;
            totalPrice += subtotal;
            itemCount += item.quantity;

            const cartItem = document.createElement('div');
            cartItem.className = 'cart-item';
            cartItem.setAttribute('data-id', item.id);
            cartItem.innerHTML = `
            <div class="cart-item-image">
                <img src="${item.productImage}" alt="${item.productName}">
            </div>
            <div class="cart-item-details">
                <h3>${item.productName}</h3>
                <p>单价: ¥${item.productPrice.toFixed(2)}</p>
                <div class="cart-item-actions">
                    <button class="btn quantity-btn" onclick="updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                    <input type="number" min="1" value="${item.quantity}" class="quantity-input"
                        onchange="updateQuantity(${item.id}, this.value)" onblur="validateQuantity(this)">
                    <button class="btn quantity-btn" onclick="updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                    <button class="btn delete-btn" onclick="removeCartItem(${item.id})">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            </div>
            <div class="cart-item-price">
                <div>小计</div>
                <div class="subtotal">¥${subtotal.toFixed(2)}</div>
            </div>
        `;
            cartItemsContainer.appendChild(cartItem);
        });

        // 更新订单摘要
        document.getElementById('cart-total').textContent = `¥${totalPrice.toFixed(2)}`;
        document.getElementById('item-count').textContent = cartItems.length;

        // 显示结算区
        cartSummary.style.display = 'flex';
    }

    // 加载购物车数据
    async function loadCart() {
        try {
            const token = getToken();
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            const response = await axios.get(`${API_BASE_URL}/cart`, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (response.data.code === 0) {
                renderCartItems(response.data.data);
                document.querySelector('.cart-count').textContent = response.data.data.length;
            }
        } catch (error) {
            console.error('加载购物车出错:', error);
            alert('加载购物车失败: ' + (error.response?.data?.message || error.message));
        }
    }

    // 更新商品数量
    async function updateQuantity(itemId, newQuantity) {
        if (newQuantity < 1) return;

        try {
            const token = getToken();
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            const response = await axios.put(`${API_BASE_URL}/cart/${itemId}`, {
                quantity: parseInt(newQuantity)
            }, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (response.data.code === 0) {
                loadCart(); // 刷新购物车列表
            }
        } catch (error) {
            console.error('更新数量出错:', error);
            alert('更新失败: ' + (error.response?.data?.message || error.message));
        }
    }

    // 验证数量输入
    function validateQuantity(input) {
        if (input.value < 1) {
            input.value = 1;
        }
    }

    // 删除购物车项目
    async function removeCartItem(itemId) {
        if (!confirm('确定要从购物车中删除此商品吗?')) return;

        try {
            const token = getToken();
            if (!token) {
                alert('请先登录!');
                return;
            }

            const response = await axios.delete(`${API_BASE_URL}/cart/${itemId}`, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (response.data.code === 0) {
                loadCart(); // 刷新购物车列表
            }
        } catch (error) {
            console.error('删除商品出错:', error);
            alert('删除失败: ' + (error.response?.data?.message || error.message));
        }
    }

    // 更新导航栏购物车数量
    async function updateCartItemCount() {
        try {
            const token = getToken();
            if (!token) return;

            const response = await axios.get(`${API_BASE_URL}/cart/count`, {
                headers: { Authorization: `${token}` }
            });

            if (response.data.code === 0) {
                document.querySelector('.cart-count').textContent = response.data.data.count;
            }
        } catch (error) {
            console.error('更新购物车数量出错:', error);
        }
    }

    // 结算功能
    function checkout() {
        alert('结算功能即将推出!');
    }

    // 页面加载时初始化
    document.addEventListener('DOMContentLoaded', () => {
        loadCart();
    });
</script>
</body>
</html>