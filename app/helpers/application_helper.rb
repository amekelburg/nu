module ApplicationHelper

  def submenu_item(code, label, path)
    link = content_tag(:a, label, href: path)
    content_tag('li', link, class: @submenu == code ? 'active' : nil)
  end

  def dropdown_submenu_item(codes, label, &block)
    items = capture(&block)
    li_content = [
      content_tag(:a, label, href: '#', class: "dropdown-toggle", data: { toggle: 'dropdown' }, role: 'button', 'aria-expanded' => 'false'),
      content_tag(:ul, items, class: 'dropdown-menu', role: 'menu')
    ].join.html_safe

    content_tag(:li, li_content, class: codes.include?(@submenu) ? 'active' : nil)
  end

  # shows the section row with label and optional show / hide button
  def section_row(title, section_id, options = nil)
    options ||= {}

    state      = (options[:state] || :closed).to_sym
    show_label = options[:show_label] || 'Show'
    hide_label = options[:hide_label] || 'Hide'

    content = [
      content_tag(:div, content_tag(:h4, title), class: 'col-sm-11')
    ]

    if state != :always_open
      content << content_tag(:div, content_tag(:button, state == :opened ? hide_label : show_label, :class => 'btn btn-xs btn-default', :type => 'button', :data => { show_label: show_label, hide_label: hide_label, toggle: 'collapse', target: "##{section_id}" }, "aria-expanded" => false, "aria-controls" => section_id), class: 'col-sm-1 text-right')
    end

    content_tag(:div, content.join.html_safe, class: 'row section-row')
  end

  def icon_tag(icon, options = nil)
    options ||= {}
    path_options = options[:path_options]
    path = content_tag(:path, '', { d: Icons::PATHS[icon.to_sym] || Icons::PATHS[:_missing] }.merge(path_options || {}))
    g = content_tag(:g, path)
    svg = content_tag(:svg, g, viewBox: '0 0 24 24', preserveAspectRatio: 'xMidYMid meet')

    opts = { class: [ 'icon', [ options[:class] ] ].flatten.reject(&:blank?).join(' ') }
    if options[:tooltip]
      opts['data-toggle'] = 'tooltip'
      opts['data-html'] = true
      opts['title'] = options[:tooltip].gsub('"', '&#34;')
      opts['data-modal-id'] = options[:modal_id]
      # opts['data-delay'] = { show: 100, hide: 2000 }.to_json
    end
    content_tag(:div, svg, opts)
  end

  def section_icon(section)
    case section.to_sym
    when :profile
      'person'
    else
      section.to_s
    end
  end

  def section_root_path(section)
    case section.to_sym
    when :profile
      :my_profile
    else
      section.to_sym
    end
  end

  def show_hide_link(section_selector, expanded)
    link_to '#', data: { toggle: 'expand', expanded: expanded, target: section_selector } do
      [ icon_tag('expand_less', class: [ "less", expanded ? nil : 'hide' ]),
        icon_tag('expand_more', class: [ "more", expanded ? 'hide' : nil ]) ].join.html_safe
    end
  end

  def help_icon(brief, options = nil)
    options ||= {}
    more_title = options[:more_title]
    more_text  = options[:more_text]

    opts = {}
    tooltip = brief
    if more_text.present?
      modal_id = SecureRandom.uuid
      tooltip = [
        content_tag(:p, tooltip),
        content_tag(:p, "Click icon for more info", class: 'tooltip-more').gsub('"', "'")
      ].join.html_safe
      opts[:class] = "with-more"
      opts[:modal_id] = modal_id
    end
    opts[:tooltip] = tooltip

    icon = icon_tag('help', opts)

    if more_text.present?
      [ icon, modal(options[:more_title], options[:more_text], id: modal_id) ].join.html_safe
    else
      icon
    end
  end

  def modal(title, text, options = nil)
    options ||= {}

    close_button  = content_tag(:button, content_tag(:span, '&times;'.html_safe, 'aria-hidden' => 'true'), 'class' => 'close', 'type' => 'button', 'data-dismiss' => 'modal', 'aria-label' => 'Close').html_safe
    header        = content_tag(:h4, title, class: 'modal-title').html_safe
    modal_header  = content_tag(:div, [ close_button, header ].join.html_safe, class: 'modal-header').html_safe
    modal_body    = content_tag(:div, text.html_safe, class: 'modal-body').html_safe
    modal_content = content_tag(:div, [ modal_header, modal_body ].join.html_safe, class: 'modal-content').html_safe

    modal_dialog  = content_tag(:div, modal_content, class: 'modal-dialog').html_safe
    content_tag(:div, modal_dialog, class: 'modal fade', id: options[:id]).html_safe
  end

  def front_page?
    params[:controller] == 'user_sessions'
  end

  def public_page?
    %w{ user_sessions applications }.include?(params[:controller])
  end

end
