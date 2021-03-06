module ApplicationHelper
  def flash_message_margin(session_id, homepage)
    session_id && homepage ? "flash_message_margin" : ""
  end

  def background_photo_class(session_id, homepage, moments, user)
    # boat photo for verification, nye photo for registration
    class_name = session_id ? "logged-in" : "not-logged-in"

    # if we're on the homepage, don't load a photo
    if moments && moments.empty? && user.moments.count == 0
      class_name = "welcome"
    elsif homepage
      class_name = homepage
    end

    return class_name
  end
end
