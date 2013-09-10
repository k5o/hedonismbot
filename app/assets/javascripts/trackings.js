var Tracking = {
  init: function() {
    $('.delete').on('ajax:success', 'a.delete_tracking', this.deleteTracking);
    $('#query_form_tag').on('submit', this.invokeAjaxLoader);
  },

  deleteTracking: function() {
    $(this).parent().parent().fadeOut(400);
  },

  invokeAjaxLoader: function() {
    $('#query_submit').html("<img src='/assets/ajax-loader.gif'>")
  }
}

$(document).ready(function() {
  Tracking.init();
});