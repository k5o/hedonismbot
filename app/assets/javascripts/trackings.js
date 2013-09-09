var Tracking = {
  init: function() {
    $('.delete').on('ajax:success', 'a.delete_tracking', this.deleteTracking);
  },

  deleteTracking: function() {
    $(this).parent().parent().fadeOut(400);
  },
}

$(document).ready(function() {
  Tracking.init();
});