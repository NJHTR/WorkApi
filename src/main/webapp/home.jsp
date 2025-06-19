<%--
  Created by IntelliJ IDEA.
  User: NJHTR
  Date: 2025/6/19
  Time: 16:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首页</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <script>
        // 获取Token的完整Authorization头
        function getAuthorizationHeader() {
            const token = localStorage.getItem('token');
            return token ? `Bearer ${token}` : '';
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
            background: linear-gradient(135deg, #e0e8ff, #d5f0ff);
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

        /* 搜索区域 */
        .search-section {
            background: rgba(255, 255, 255, 0.35);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1),
            inset 0 0 15px rgba(255, 255, 255, 0.5);
            padding: 30px;
            text-align: center;
        }

        .hero-title {
            font-size: 3rem;
            background: linear-gradient(135deg, #4B70E2, #8d6ee5);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 15px;
            letter-spacing: 1px;
        }

        .hero-subtitle {
            color: #5a5d70;
            margin-bottom: 30px;
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 30px;
        }

        .search-box {
            max-width: 600px;
            margin: 0 auto;
            display: flex;
            gap: 10px;
        }

        .search-input {
            flex: 1;
            height: 50px;
            padding: 0 20px;
            border-radius: 15px;
            border: none;
            background: rgba(255, 255, 255, 0.6);
            box-shadow: inset 5px 5px 10px rgba(0, 0, 0, 0.05),
            inset -5px -5px 10px rgba(255, 255, 255, 0.8);
            font-size: 16px;
            transition: all 0.3s;
        }

        .search-input:focus {
            outline: none;
            box-shadow: inset 3px 3px 8px rgba(0, 0, 0, 0.05),
            inset -3px -3px 8px rgba(255, 255, 255, 0.8);
            background: rgba(255, 255, 255, 0.8);
        }

        .search-btn {
            height: 50px;
            padding: 0 30px;
            border-radius: 15px;
            background: #4B70E2;
            color: white;
            border: none;
            font-weight: 600;
            font-size: 16px;
            box-shadow: 0 5px 15px rgba(75, 112, 226, 0.3);
            cursor: pointer;
            transition: all 0.3s;
        }

        .search-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(75, 112, 226, 0.4);
        }

        /* 分类区域 */
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .category-card {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 25px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08),
            inset 0 0 10px rgba(255, 255, 255, 0.6);
            transition: all 0.3s;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1),
            inset 0 0 15px rgba(255, 255, 255, 0.7);
        }

        .category-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            color: #4B70E2;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .category-title {
            font-weight: 700;
            margin-bottom: 8px;
            color: #3a3f5c;
        }

        .category-count {
            font-size: 14px;
            color: #6a6e8d;
        }

        /* 产品网格 */
        .section-title {
            font-size: 28px;
            color: #3a3f5c;
            margin: 30px 0 20px;
            text-align: center;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #4B70E2, #8d6ee5);
            border-radius: 2px;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .product-card {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08),
            inset 0 0 10px rgba(255, 255, 255, 0.6);
            transition: all 0.4s;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15),
            inset 0 0 15px rgba(255, 255, 255, 0.7);
        }

        .product-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(45deg, #e0e8ff, #d5f0ff);
            display: flex;
            justify-content: center;
            align-items: center;
            color: #4B70E2;
            font-size: 3rem;
        }

        .product-content {
            padding: 20px;
        }

        .product-badge {
            display: inline-block;
            background: #ff6b6b;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .product-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #3a3f5c;
        }

        .product-desc {
            color: #6a6e8d;
            font-size: 14px;
            margin-bottom: 15px;
            min-height: 60px;
        }

        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .product-price {
            font-weight: 800;
            font-size: 20px;
            color: #4B70E2;
        }

        .add-to-cart {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #4B70E2;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 5px 15px rgba(75, 112, 226, 0.3);
            cursor: pointer;
            transition: all 0.3s;
        }

        .add-to-cart:hover {
            transform: scale(1.1);
        }

        /* 推荐区域 */
        .featured {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
        }

        .featured-product {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08),
            inset 0 0 10px rgba(255, 255, 255, 0.6);
            display: flex;
            overflow: hidden;
            height: 350px;
        }

        .featured-img {
            flex: 1;
            background: linear-gradient(45deg, #d5f0ff, #e0e8ff);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 4rem;
            color: #4B70E2;
        }

        .featured-content {
            flex: 1;
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .featured-badge {
            display: inline-block;
            background: #8d6ee5;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .featured-title {
            font-size: 28px;
            font-weight: 800;
            color: #3a3f5c;
            margin-bottom: 15px;
        }

        .featured-desc {
            color: #6a6e8d;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .featured-price {
            font-size: 32px;
            font-weight: 800;
            color: #4B70E2;
            margin-bottom: 20px;
        }

        .featured-btn {
            background: #4B70E2;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 12px;
            font-weight: 700;
            width: 200px;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(75, 112, 226, 0.3);
        }

        .featured-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(75, 112, 226, 0.4);
        }

        /* 底部 */
        .footer {
            background: rgba(255, 255, 255, 0.35);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            margin-top: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08),
            inset 0 0 10px rgba(255, 255, 255, 0.6);
        }

        .footer-text {
            color: #6a6e8d;
            font-size: 16px;
        }

        /* 媒体查询 */
        @media (max-width: 1000px) {
            .featured {
                grid-template-columns: 1fr;
            }

            .featured-product {
                flex-direction: column;
                height: auto;
            }

            .featured-img {
                height: 250px;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
            }

            .nav-actions {
                width: 100%;
                justify-content: center;
            }

            .hero-title {
                font-size: 2.2rem;
            }

            .search-box {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .glass-container {
                padding: 10px;
            }

            .products-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="bubbles" id="bubbles"></div>

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
            <a href="#" class="nav-link active">首页</a>
            <a href="#" class="nav-link">商店</a>
            <a href="#" class="nav-link">类别</a>
            <a href="#" class="nav-link">限时优惠</a>
            <a href="#" class="nav-link">品牌</a>
            <a href="#" class="nav-link">联系我们</a>
        </div>

        <div class="nav-actions">
            <a href="cart.jsp">
                <div class="cart-icon">
                    <i class="fas fa-shopping-cart"></i>
                    <div class="cart-count">3</div>
                </div>
            </a>
            <div class="user-icon">
                <i class="fas fa-user"></i>
            </div>
        </div>
    </nav>

    <!-- 搜索区域 -->
    <section class="search-section">
        <h1 class="hero-title">发现精美设计产品</h1>
        <p class="hero-subtitle">探索我们精心挑选的产品系列，感受玻璃美学设计的独特魅力。每件产品都经过精心设计，符合现代美学标准。</p>

        <div class="search-box">
            <input type="text" class="search-input" placeholder="搜索设计商品、品牌或类别...">
            <button class="search-btn">搜索 <i class="fas fa-search"></i></button>
        </div>
    </section>

    <!-- 分类区域 -->
    <div class="categories">
        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-glass-martini-alt"></i>
            </div>
            <h3 class="category-title">玻璃器皿</h3>
            <p class="category-count">86件产品</p>
        </div>

        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-mug-hot"></i>
            </div>
            <h3 class="category-title">厨房用品</h3>
            <p class="category-count">132件产品</p>
        </div>

        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-paint-brush"></i>
            </div>
            <h3 class="category-title">艺术装饰</h3>
            <p class="category-count">54件产品</p>
        </div>

        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-lightbulb"></i>
            </div>
            <h3 class="category-title">照明灯具</h3>
            <p class="category-count">79件产品</p>
        </div>

        <div class="category-card">
            <div class="category-icon">
                <i class="fas fa-chair"></i>
            </div>
            <h3 class="category-title">家具</h3>
            <p class="category-count">63件产品</p>
        </div>
    </div>

    <!-- 热门产品 -->
    <h2 class="section-title">热门设计产品</h2>
    <div class="products-grid">
        <div class="product-card">
            <div class="product-img">
                <i class="fas fa-wine-glass-alt"></i>
            </div>
            <div class="product-content">
                <span class="product-badge">最受欢迎</span>
                <h3 class="product-title">极光玻璃酒杯</h3>
                <p class="product-desc">采用高品质玻璃手工制作，独特的光泽设计在灯光下呈现极光效果。</p>
                <div class="product-footer">
                    <div class="product-price">¥299</div>
                    <div class="add-to-cart">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-card">
            <div class="product-img">
                <i class="fas fa-ice-cream"></i>
            </div>
            <div class="product-content">
                <span class="product-badge" style="background: #8d6ee5;">新品上市</span>
                <h3 class="product-title">冰川水晶甜点碗</h3>
                <p class="product-desc">现代简约设计的水晶玻璃碗，适合盛放甜点、沙拉或水果。</p>
                <div class="product-footer">
                    <div class="product-price">¥189</div>
                    <div class="add-to-cart">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-card">
            <div class="product-img">
                <i class="fas fa-wind"></i>
            </div>
            <div class="product-content">
                <span class="product-badge" style="background: #20bf6b;">独家设计</span>
                <h3 class="product-title">流体艺术装饰瓶</h3>
                <p class="product-desc">流体艺术与现代玻璃工艺的结合，每件作品都独一无二。</p>
                <div class="product-footer">
                    <div class="product-price">¥659</div>
                    <div class="add-to-cart">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-card">
            <div class="product-img">
                <i class="fas fa-lightbulb"></i>
            </div>
            <div class="product-content">
                <span class="product-badge">限量版</span>
                <h3 class="product-title">棱镜几何吊灯</h3>
                <p class="product-desc">现代几何设计吊灯，在不同角度折射出迷人光线。</p>
                <div class="product-footer">
                    <div class="product-price">¥1299</div>
                    <div class="add-to-cart">
                        <i class="fas fa-plus"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 精选产品 -->
    <h2 class="section-title">本月精选</h2>
    <div class="featured">
        <div class="featured-product">
            <div class="featured-img">
                <i class="fas fa-wine-bottle"></i>
            </div>
            <div class="featured-content">
                <span class="featured-badge">本月之星</span>
                <h2 class="featured-title">极光渐变玻璃瓶系列</h2>
                <p class="featured-desc">融合传统吹制玻璃工艺与现代设计，独特的渐变色彩来自特殊金属氧化物涂层，在不同光源下呈现多变光影效果。每件作品均为手工制作，限量供应。</p>
                <div class="featured-price">¥899</div>
                <button class="featured-btn">立即购买</button>
            </div>
        </div>

        <div class="products-grid">
            <div class="product-card">
                <div class="product-img">
                    <i class="fas fa-infinity"></i>
                </div>
                <div class="product-content">
                    <span class="product-badge" style="background: #ff9f43;">限时折扣</span>
                    <h3 class="product-title">莫比乌斯咖啡杯</h3>
                    <p class="product-desc">灵感来自莫比乌斯环的独特设计，双层玻璃结构保持饮品温度。</p>
                    <div class="product-footer">
                        <div class="product-price">¥249 <span style="text-decoration: line-through; font-size: 14px; color: #999;">¥329</span></div>
                        <div class="add-to-cart">
                            <i class="fas fa-plus"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="product-card">
                <div class="product-img">
                    <i class="fas fa-feather-alt"></i>
                </div>
                <div class="product-content">
                    <span class="product-badge" style="background: #01a3a4;">手工制作</span>
                    <h3 class="product-title">羽翼纹茶杯组</h3>
                    <p class="product-desc">手工雕刻羽毛纹理，轻盈优雅，展现玻璃材质的精致美感。</p>
                    <div class="product-footer">
                        <div class="product-price">¥599</div>
                        <div class="add-to-cart">
                            <i class="fas fa-plus"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 底部 -->
    <footer class="footer">
        <p class="footer-text">© 2025 GlassMart - 玻璃美学设计商城 | 所有设计保留权利</p>
        <p class="footer-text">客服热线: 400-123-4567 | 邮箱: contact@glassmart.com</p>
    </footer>
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

    // 添加购物车交互
    function setupCartInteraction() {
        const addToCartButtons = document.querySelectorAll('.add-to-cart');

        addToCartButtons.forEach(button => {
            button.addEventListener('click', function() {
                const card = this.closest('.product-card');
                const title = card.querySelector('.product-title').textContent;
                const price = card.querySelector('.product-price').textContent;

                // 动画效果
                this.innerHTML = '<i class="fas fa-check"></i>';
                this.style.background = '#20bf6b';

                setTimeout(() => {
                    this.innerHTML = '<i class="fas fa-plus"></i>';
                    this.style.background = '#4B70E2';
                }, 1500);

                // 更新购物车数量
                const cartCount = document.querySelector('.cart-count');
                let count = parseInt(cartCount.textContent);
                count++;
                cartCount.textContent = count;

                // 添加提示
                const message = `已添加 ${title} ${price} 到购物车`;
                alert(message);
            });
        });
    }

    // 初始化
    document.addEventListener('DOMContentLoaded', function() {
        createBubbles();
        add3dEffect();
        setupCartInteraction();
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // 设置API基础URL
    const API_BASE_URL = 'http://localhost:8181';

    // 从localStorage获取token
    function getToken() {
        return localStorage.getItem('token') || '';
    }

    // 加载购物车数量（在导航栏显示）
    async function loadCartCount() {
        try {
            const response = await axios.get(`${API_BASE_URL}/cart/count`, {
                headers: { Authorization: getAuthorizationHeader() }
            });

            if (response.data.code === 0) {
                document.querySelector('.cart-count').textContent = response.data.data.count;
            }
        } catch (error) {
            console.error('获取购物车数量失败:', error);
        }
    }

    // 加载分类数据
    async function loadCategories() {
        try {
            const response = await axios.get(`${API_BASE_URL}/categories`);

            if (response.data.code === 0) {
                const categories = response.data.data;
                const categoriesContainer = document.querySelector('.categories');
                categoriesContainer.innerHTML = '';

                // 获取每个分类的商品数量
                const countPromises = categories.map(category =>
                    axios.get(`${API_BASE_URL}/categories/${category.id}/count`)
                );

                const countResponses = await Promise.all(countPromises);
                const counts = countResponses.map(res => res.data.code === 0 ? res.data.data : 0);

                // 渲染分类
                categories.forEach((category, index) => {
                    const categoryCard = document.createElement('div');
                    categoryCard.className = 'category-card';
                    categoryCard.innerHTML = `
                    <div class="category-icon">
                        <i class="fas fa-glass-martini-alt"></i>
                    </div>
                    <h3 class="category-title">${category.name}</h3>
                    <p class="category-count">${counts[index]}件产品</p>
                `;
                    categoriesContainer.appendChild(categoryCard);
                });
            }
        } catch (error) {
            console.error('加载分类数据失败:', error);
        }
    }

    // 加载热门商品
    async function loadHotProducts() {
        try {
            const response = await axios.get(`${API_BASE_URL}/products/hot`);

            if (response.data.code === 0) {
                const products = response.data.data;
                const productsGrid = document.querySelector('.products-grid');
                productsGrid.innerHTML = '';

                products.forEach(product => {
                    const productCard = document.createElement('div');
                    productCard.className = 'product-card';
                    productCard.innerHTML = `
                    <div class="product-img">
                        <i class="fas fa-wine-glass-alt"></i>
                    </div>
                    <div class="product-content">
                        <span class="product-badge">最受欢迎</span>
                        <h3 class="product-title">${product.name}</h3>
                        <p class="product-desc">${product.des}</p>
                        <div class="product-footer">
                            <div class="product-price">¥${product.price.toFixed(2)}</div>
                            <div class="add-to-cart" onclick="addToCart(${product.id})">
                                <i class="fas fa-plus"></i>
                            </div>
                        </div>
                    </div>
                `;
                    productsGrid.appendChild(productCard);
                });
            }
        } catch (error) {
            console.error('加载热门商品失败:', error);
        }
    }

    // 加载精选商品
    async function loadFeaturedProducts() {
        try {
            const response = await axios.get(`${API_BASE_URL}/products/featured`);

            if (response.data.code === 0) {
                const products = response.data.data;
                const featuredContainer = document.querySelector('.featured').querySelector('.products-grid');
                featuredContainer.innerHTML = '';

                products.forEach(product => {
                    const productCard = document.createElement('div');
                    productCard.className = 'product-card';
                    productCard.innerHTML = `
                    <div class="product-img">
                        <i class="fas fa-infinity"></i>
                    </div>
                    <div class="product-content">
                        <span class="product-badge" style="background: #ff9f43;">限时折扣</span>
                        <h3 class="product-title">${product.name}</h3>
                        <p class="product-desc">${product.des}</p>
                        <div class="product-footer">
                            <div class="product-price">¥${product.price.toFixed(2)}</div>
                            <div class="add-to-cart" onclick="addToCart(${product.id})">
                                <i class="fas fa-plus"></i>
                            </div>
                        </div>
                    </div>
                `;
                    featuredContainer.appendChild(productCard);
                });
            }
        } catch (error) {
            console.error('加载精选商品失败:', error);
        }
    }

    // 添加到购物车
    async function addToCart(productId) {
        try {
            const token = getToken();
            if (!token) {
                alert('请先登录!');
                window.location.href = 'index.jsp';
                return;
            }

            const response = await axios.post(`${API_BASE_URL}/cart`, {
                productId: productId,
                quantity: 1
            }, {
                headers: { Authorization: getAuthorizationHeader() }
            });

            if (response.data.code === 0) {
                alert('商品已添加到购物车');
                loadCartCount();
            }
        } catch (error) {
            console.error('添加到购物车失败:', error);
            alert('添加失败: ' + (error.response?.data?.message || error.message));
        }
    }

    // 页面加载时初始化
    document.addEventListener('DOMContentLoaded', () => {
        loadCartCount();
        loadCategories();
        loadHotProducts();
        loadFeaturedProducts();
    });
</script>
</body>
</html>

