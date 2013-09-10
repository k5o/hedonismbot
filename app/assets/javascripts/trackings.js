var Tracking = {
  init: function() {
    $('#query_form_tag').on('submit', this.invokeAjaxLoader);
  },

  invokeAjaxLoader: function() {
    $('#query_submit').html("<img src='/assets/ajax-loader.gif'>")
  }
}

$(document).ready(function() {
  Tracking.init();
});