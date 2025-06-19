document.addEventListener('DOMContentLoaded', function() {
    // 绑定到登录按钮而不是整个表单
    const loginButton = document.querySelector('#b-form .submit');

    if (loginButton) {
        console.log('Login button found');

        loginButton.addEventListener('click', async function(e) {
            e.preventDefault();
            console.log('SIGN IN button clicked');

            // 获取并trim输入值
            const email = document.getElementById('SignInEmail').value.trim();
            const password = document.getElementById('SignInPassword').value.trim();

            console.log("Email:", email);
            console.log("Password:", password ? "*****" : "<empty>");

            // 简单验证
            if (!email || !password) {
                alert('请填写邮箱和密码');
                return;
            }

            try {
                console.log('Sending login request');

                // 使用相对路径避免CORS问题
                const response = await fetch('http://localhost:8181/Auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        email: email,
                        password: password
                    })
                });

                console.log('Response status:', response.status);

                // 处理非JSON响应
                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('HTTP error:', errorText);
                    throw new Error(`请求失败 (${response.status}): ${errorText}`);
                }

                const result = await response.json();
                console.log('Response data:', result);

                // 使用正确的返回码判断（200表示成功）
                if (result.code === 0) {
                    // 存储token到localStorage
                    localStorage.setItem('token', result.data);

                    // 重定向到首页
                    window.location.href = 'home.jsp';
                } else {
                    console.log('登录失败:', result.message);
                    alert('登录失败: ' + (result.message || '未知错误'));
                }
            } catch (error) {
                console.error('登录请求失败:', error);
                alert('登录请求失败: ' + error.message);
            }
        });
    } else {
        console.error('Login button not found! Check button class');
    }
});