<%--
  Created by IntelliJ IDEA.
  User: NJHTR
  Date: 2025/6/17
  Time: 21:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Auth</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <link href="./assets/css/Auth.css" rel="stylesheet">
</head>
<body>
    <div class="shell" id="shell">
        <div class="bubbles" id="bubbles"></div>

<%--        <div class="container a-container" id="a-container">--%>
<%--            <form action="" method="" class="form" id="a-form">--%>
<%--                <h2 class="form_title title">重置密码</h2>--%>
<%--                <div class="message">请输入您的邮箱以接收密码重置链接</div>--%>
<%--                <input type="email" class="form_input" id="ForgotEmail" placeholder="邮箱">--%>
<%--                <button class="form_button button submit">--%>
<%--                    SEND TO EMAIL--%>
<%--                </button>--%>
<%--            </form>--%>
<%--        </div>--%>

        <div class="container b-container" id="b-container">
            <form action="" method="" class="form" id="b-form">
                <h2 class="form_title title">设置新密码</h2>
                <div class="message">请设置您的新密码</div>
                <input type="password" class="form_input" id="ReSetPassword" placeholder="新密码" >
                <input type="password" class="form_input" id="ReSetRePassword" placeholder="确认密码">
                <button class="form_button button submit" id="resetPasswordButton">
                    重置密码
                </button>
            </form>
        </div>

        <div class="switch" id="switch-cnt">
            <div class="switch_circle"></div>
            <div class="switch_circle switch_circle-t"></div>

            <div class="switch_container" id="switch-c1">
                <h2 class="switch_title title" style="letter-spacing: 0;">Back!</h2>
                <p class="switch_description description">突然想起密码了??,我要直接登录</p>

                <a href="index.jsp">
                    <button class="switch_button button switch-btn">
                        BACK TO SIGN IN
                    </button>
                </a>
            </div>

            <div class="switch_container is-hidden" id="switch-c2">
                <h2 class="switch_title title" style="letter-spacing: 0;">Friend!</h2>
                <p class="switch_description description">不想重置密码了！！！</p>

                <a href="index.jsp">
                    <button class="switch_button button switch-btn">
                        BACK
                    </button>
                </a>
            </div>
        </div>
    </div>
    <script src="./assets/js/Auth.js"></script>
</body>
</html>
