(function() {
  let speedSlider = document.querySelector("#range-slider");
  let speedValue = speedSlider.value;
  let snow = document.querySelectorAll("#snowbanner .snow");
  let snowSwitch = true;

  speedSlider.addEventListener("input", function() {
    speedValue = speedSlider.value;
    setSeconds();
  });

  function setSeconds() {
    let seconds = (100 - speedValue) * 0.2;
    if (seconds < 0.5) {
      seconds = 0.5;
    }

    seconds >= 20 ? (snowSwitch = false) : (snowSwitch = true);

    snow.forEach(element => {
      element.style.WebkitAnimationDuration = `${seconds}s`;
      element.style.animationDuration = `${seconds}s`;

      if (snowSwitch) {
        element.style.WebkitAnimationIterationCount = "infinite";
        element.style.animationIterationCount = "infinite";
        element.style.opacity = "1";
      } else {
        element.style.WebkitAnimationIterationCount = "1";
        element.style.animationIterationCount = "1";
        element.style.opacity = "0";
      }
    });
  }
  setSeconds();
/*
  var percent = 0

  function eatCount(){
    document.querySelector(".monsterText").innerHTML = ("Swift<br>Parking");
    // $(".monsterText").html("We are<br>SQUARE<br>MONSTER!")
  }

  var timer = setInterval(function(){
    // $(".bar").css("width",percent+"%")
    document.querySelector(".bar").style.setProperty("width",percent+"%")
    percent+=1
    if (percent>100){
      // $(".pageLoading").addClass("complete")
      document.querySelector(".pageLoading").classList.add("complete");
      setTimeout(eatCount,3000);
      clearInterval(timer);
    }
  },30)

 */


})();