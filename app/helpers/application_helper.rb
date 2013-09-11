module ApplicationHelper

  def date_presenter_for_next_airdate(date)
    if date.nil?
      "N/A"
    elsif (date - Date.today) == 0
      "Today"
    elsif (date - Date.today) == 1
      "Tomorrow"
    else
      date.strftime("%m-%d-%Y")
    end
  end

  def date_presenter_for_last_airdate(date)
    date ? date.strftime("%m-%d-%Y") : "Show in Development"
  end
end
