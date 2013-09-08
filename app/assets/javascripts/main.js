$(document).ready(function () {
  $('.wrapper').on('click', '#about_link', function(e){
    e.preventDefault();
    $('#signup').css("display", "none");
    $('#login').css("display", "none");
    $('#about').toggle(300);
  });

  $('.container').on('click', '.signup_link', function(e){
    e.preventDefault();
    $('#about').css("display", "none");
    $('#login').css("display", "none");
    $('#signup').toggle(300);
  });

  $('.wrapper').on('click', '#login_link', function(e){
    e.preventDefault();
    $('#about').css("display", "none");
    $('#signup').css("display", "none");
    $('#login').toggle(300);
  });

  $("#scroll_to_signup").click(function(e) {
    e.preventDefault();
    $('#about').css("display", "none");
    $('#login').css("display", "none");
    if ($('#signup').css("display", "none")){
      $('#signup').toggle(300);
    }
    else {
      return false
    }

    $('html, body').animate({
        scrollTop: $("#popin").offset().top
      }, 600);
      return false;
    });
});