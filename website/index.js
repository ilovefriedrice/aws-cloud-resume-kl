const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://5hjhw36gh5ypkjhszq4avzr5dq0cmmkv.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `${data}`;
}
updateCounter();