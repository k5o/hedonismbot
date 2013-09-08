$(document).ready(function () {
  $('.heading').on('click', '#about_link', function(e){
    e.preventDefault();
    $('#about').toggle(300);
  });
});