<%--
  Created by IntelliJ IDEA.
  User: NJHTR
  Date: 2025/6/17
  Time: 21:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
    <html>
        <head>
            <title>Auth</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
            <link href="./assets/css/Auth.css" rel="stylesheet">
        </head>
        <body>
            <div class="shell" id="shell">
                <div class="bubbles" id="bubbles"></div>

                <div class="container a-container" id="a-container">
                    <form action="" method="" class="form" id="a-form">
                        <h2 class="form_title title">创建账户</h2>
                        <div class="form_icons">
                            <i class="iconfont fab fa-weixin"></i>
                            <i class="iconfont fab fa-google"></i>
                            <i class="iconfont fab fa-twitter"></i>
                        </div>
                        <span class="form_span">选择注册方式激活电子邮箱注册</span>
                        <input type="text" class="form_input" name="" id="SignUpName" placeholder="Name">
                        <input type="text" class="form_input" name="" id="SignUpEmail" placeholder="Email">
                        <input type="text" class="form_input" name="" id="SignUpGender" placeholder="Gender">
                        <input type="text" class="form_input" name="" id="SignUpCity" placeholder="City">
                        <input type="password" class="form_input" name="" id="SignUpPassword" placeholder="Password">
                        <button class="form_button button submit">SIGN UP</button>
                    </form>
                </div>

                <div class="container b-container" id="b-container">
                    <form action="" method="" class="form" id="b-form">
                        <h2 class="form_title title">登入账户</h2>
                        <div class="form_icons">
                            <i class="iconfont fab fa-weixin"></i>
                            <i class="iconfont fab fa-google"></i>
                            <i class="iconfont fab fa-twitter"></i>
                        </div>
                        <span class="form_span">选择登录方式激活电子邮箱注册</span>
                        <input type="text" class="form_input" name="" id="SignInEmail" placeholder="Email">
                        <input type="password" class="form_input" name="" id="SignInPassword" placeholder="Password">
                        <a class="form_link" href="./Auth.jsp">忘记密码?</a>
                        <button class="form_button button submit">SIGN IN</button>
                    </form>
                </div>

                <div class="switch" id="switch-cnt">
                    <div class="switch_circle"></div>
                    <div class="switch_circle switch_circle-t"></div>

                    <div class="switch_container" id="switch-c1">
                        <h2 class="switch_title title" style="letter-spacing: 0;">Welcome Back!</h2>
                        <p class="switch_description description">已经有账号了嘛,去登入账号来进入奇妙世界吧!!</p>
                        <button class="switch_button button switch-btn">SIGN IN</button>
                    </div>

                    <div class="switch_container is-hidden" id="switch-c2">
                        <h2 class="switch_title title" style="letter-spacing: 0;">Hello Friend!</h2>
                        <p class="switch_description description">去注册一个账号,成为尊贵的粉丝会员,让我们踏入奇妙的旅途!!</p>
                        <button type="button" id="signUpButton" class="switch_button button switch-btn">SIGN UP</button>
                    </div>
                </div>
            </div>
            <script src="./assets/js/Auth.js"></script>
            <script src="./api/login.js"></script>
            <script src="./api/register.js"></script>
            <script>

            </script>
        </body>
    </html>