document.addEventListener("turbo:load", () => {
  const flash = document.querySelector(".flash-message");
  
  if (flash) {
    console.log("found flash");

    setTimeout(() => {
      flash.remove();
    }, 500);
  }
});