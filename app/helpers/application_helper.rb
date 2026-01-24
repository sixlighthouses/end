module ApplicationHelper
  def render_markdown(text)
    return "" if text.blank?

    # Use the marksmithed helper since it's available globally
    # Sanitize the result to prevent XSS attacks
    sanitize(marksmithed(text), tags: %w[p h1 h2 h3 h4 h5 h6 ul ol li blockquote code pre em strong a br hr table thead tbody tr th td del span],
            attributes: { "a" => %w[href title], "code" => %w[class], "pre" => %w[class], "span" => %w[class] })
  end
end
