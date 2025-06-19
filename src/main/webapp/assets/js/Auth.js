// 基本功能
let switchCtn = document.querySelector("#switch-cnt")
let switchC1 = document.querySelector("#switch-c1")
let switchC2 = document.querySelector("#switch-c2")
let switchCircle = document.querySelectorAll(".switch_circle")
let switchBtn = document.querySelectorAll(".switch-btn")
let aContainer = document.querySelector("#a-container")
let bContainer = document.querySelector("#b-container")
let allButtons = document.querySelectorAll(".submit")
let shell = document.getElementById('shell')

let getButtons = (e) => e.preventDefault()

let chageForm = (e) => {
    switchCtn.classList.add("is-gx")
    setTimeout(function(){
        switchCtn.classList.remove("is-gx")
    }, 1500)

    switchCtn.classList.toggle("is-txr")
    switchCircle[0].classList.toggle("is-txr")
    switchCircle[1].classList.toggle("is-txr")

    setTimeout(function(){
        switchC1.classList.toggle("is-hidden");
        switchC2.classList.toggle("is-hidden");
        switchC2.classList.toggle("is-visible");
    }, 400)

    aContainer.classList.toggle("is-txl")
    bContainer.classList.toggle("is-txl")
    bContainer.classList.toggle("is-z")
}

let mainF = (e) => {
    for(let i = 0; i < allButtons.length; i++){
        allButtons[i].addEventListener("click", getButtons)
    }
    for(let i = 0; i < switchBtn.length; i++){
        switchBtn[i].addEventListener("click", chageForm)
    }
}

window.addEventListener("load", mainF)

// 3D倾斜效果
function onMouseMove(e) {
    const shellRect = shell.getBoundingClientRect();
    const centerX = shellRect.left + shellRect.width / 4;
    const centerY = shellRect.top + shellRect.height / 4;
    const mouseX = e.clientX - centerX;
    const mouseY = e.clientY - centerY;

    // 计算旋转角度 (限制在8度以内)
    const rotateY = (mouseX / centerX) * 2;
    const rotateX = (mouseY / centerY) * -2;

    shell.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateZ(0)`;
}

function resetCard() {
    shell.style.transform = 'perspective(1000px) rotateX(0) rotateY(0)';
}

shell.addEventListener('mousemove', onMouseMove);
shell.addEventListener('mouseleave', resetCard);

// 生成气泡背景
function createBubbles() {
    const bubblesContainer = document.getElementById('bubbles');
    for (let i = 0; i < 15; i++) {
        const bubble = document.createElement('div');
        bubble.classList.add('bubble');

        // 随机大小和位置
        const size = Math.random() * 120 + 20;
        const posX = Math.random() * 100;
        const delay = Math.random() * 5;
        const duration = Math.random() * 6 + 6;

        bubble.style.width = `${size}px`;
        bubble.style.height = `${size}px`;
        bubble.style.left = `${posX}%`;
        bubble.style.animationDelay = `${delay}s`;
        bubble.style.animationDuration = `${duration}s`;

        bubblesContainer.appendChild(bubble);
    }
}

window.addEventListener('load', createBubbles);