module TypographyHelper
  def data_box title, value, icon, user_options = {}
  	options = {
      class: "col-md-2 col-sm-4 col-xs-6 tile_stats_count",
    }.merge user_options

    icon = "" if icon.blank?

    title = t("na") if title.blank?
    content = t("na") if content.blank?

    content_tag(:div, class: options[:class], id: options[:id]){
      concat content_tag(:span, class: "count_top"){
      	concat content_tag("i", "", class: icon)
      	concat title
      }
      concat content_tag(:div, value, class: "count")
    }
  end
end