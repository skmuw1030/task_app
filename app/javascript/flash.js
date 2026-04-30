console.log("flash loaded");
document.addEventListener("turbo:load", () => {
  const flash = document.querySelector(".flash-message");
  console.log("flash loaded");

  if (flash) {
    console.log("found flash");
    flash.remove();
  }
});