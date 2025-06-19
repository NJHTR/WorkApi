document.addEventListener('DOMContentLoaded', function() {
    console.log('Register script loaded');

    // 确保绑定到按钮而不是整个表单
    const registerButton = document.querySelector('#a-form .submit');

    if (registerButton) {
        console.log('Register button found');

        registerButton.addEventListener('click', async function(e) {
            e.preventDefault();
            console.log('SIGN UP button clicked');

            const username = document.getElementById('SignUpName').value;
            console.log("username", username);
            const email = document.getElementById('SignUpEmail').value;
            console.log("email", email);
            const gender = document.getElementById('SignUpGender').value;
            console.log("gender", gender);
            const city = document.getElementById('SignUpCity').value;
            console.log("city", city);
            const password = document.getElementById('SignUpPassword').value;
            console.log("password", password);

            try {
                console.log('Sending register request');
                const response = await fetch('http://localhost:8181/Auth/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        username: username,
                        email: email,
                        gender: gender,
                        city: city,
                        password: password
                    })
                });

                console.log('Response received, status:', response.status);
                const result = await response.json();
                console.log('Response data:', result);

                if (result.code === 0) {
                    chageForm();
                } else {
                    alert('注册失败: ' + result.message);
                }
            } catch (error) {
                console.error('注册请求失败:', error);
                alert('注册请求失败: ' + error.message);
            }
        });
    } else {
        console.error('Register button not found! Check button class');
    }
});