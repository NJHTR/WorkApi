document.addEventListener('DOMContentLoaded', function() {
    const resetButton = document.getElementById('resetPasswordButton');

    if (resetButton) {
        console.log('Reset password button found');

        resetButton.addEventListener('click', async function(e) {
            e.preventDefault();
            console.log('Reset password button clicked');

            // 获取输入值
            const email = document.getElementById('email').value.trim();
            const newPassword = document.getElementById('ReSetPassword').value;
            const confirmPassword = document.getElementById('ReSetRePassword').value;

            console.log("Email:", email);
            console.log("New Password:", newPassword ? "*****" : "<empty>");
            console.log("Confirm Password:", confirmPassword ? "*****" : "<empty>");

            if (!newPassword || !confirmPassword) {
                alert('请输入新密码和确认密码');
                return;
            }
            if (newPassword !== confirmPassword) {
                alert('两次输入的密码不一致');
                return;
            }

            try {
                console.log('Sending reset password request');

                // 使用相对路径避免CORS问题
                const response = await fetch('http://localhost:8181/Auth/resetuser', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        email: email,
                        password: newPassword,
                        repassword: confirmPassword
                    })
                });

                console.log('Response status:', response.status);

                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('HTTP error:', errorText);
                    throw new Error(`请求失败 (${response.status}): ${errorText}`);
                }

                const result = await response.json();
                console.log('Response data:', result);

                // 使用正确的返回码判断（200表示成功）
                if (result.code === 0) {
                    window.location.href = 'index.jsp';
                } else {
                    alert('密码重置失败: ' + (result.message || '未知错误'));
                }
            } catch (error) {
                console.error('密码重置失败:', error);
                alert('密码重置失败: ' + error.message);
            }
        });
    } else {
        console.error('Reset password button not found!');
    }
});