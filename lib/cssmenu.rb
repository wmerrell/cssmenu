require 'cssmenu/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

# == Css Menu System
#
# This set of functions makes adding a CSS configured menu as simple as
# possible. Because it uses CSS for all formatting, it will work even if
# javascript is turned off. If there is no styling, it will degrade
# gracefully to a simple unordered list.
#
# === Typical Example:
#
#   <%= menubar do -%>
#     <%= menu_item('Back to Home', 'house', root_path()) %>
#     <%= menu_item('New Registration', 'user_add', new_registration_path) %>
#   <%- end -%>
#
# === Extended Example:
#
#   <%= menubar do -%>
#     <%= menu_item('Back to Home', 'house', root_path()) %>
#     <%= sub_menu('Tagged Actions', 'tag') do -%>
#       <%= menu_item('Send Mail', 'email', nil, nil, :onclick => js_submit('email')) %>
#       <%= menu_item('Delete', 'delete', nil, nil, {:onclick => js_submit('delete', :confirm => "Are you sure you want to delete the tagged registrations?"}) ) %>
#     <%- end -%>
#     <%= sub_menu('Tools', 'cog') do -%>
#       <%= menu_item('Export as CSV', 'report_disk', url_for(:controller=>:registrations, :action=>:index, :format=>:csv)) %>
#       <%= menu_item('Manage Statuses', 'application_view_list', statuses_path) %>
#       <%= menu_item('Manage Documents', 'page_copy', documents_path) %>
#       <%= sub_menu('Sub Item 2', 'add') do -%>
#         <%= menu_item('Sub Sub Item 1', 'add', '#') %>
#         <%= menu_item('Sub Sub Item 2', 'add', '#') %>
#       <%- end -%>
#       <%= menu_item('Sub Item 4', 'add') %>
#     <%- end -%>
#     <%= menu_item('New Registration', 'user_add', new_registration_path) %>
#   <%- end -%>
#
module CssMenu

  # Creates a menu bar
  #
  # This function creates a menu bar by creating an unordered list with a
  # class of "cssMenu". The menu items will be li items within the list.
  # It is expected that the "cssMenu" class will be styled to resemble a
  # horizontal bar that will contain the item buttons.
  #
  # *Parameters*
  #
  # *permission* If the permission argument is supplied, it is expected to
  # evaluate to true or false. If permissions is true or nil the menu is
  # displayed. If it is false, the menu is not displayed.
  #
  # *block* This function expects a block consisting of the menu items to
  # display. If no block is supplied, then no output is returned.
  #
  # === Usage:
  #   <%= menubar(permission) do -%>
  #   <%- end -%>
  #
  def menubar(permission=nil, &block)
    if block_given?
      content = capture(&block)
      if permission.nil? || permission
        raw("\n    <!-- cssMenu -->\n    <ul class=\"cssMenu\">\n" + content + "    </ul>\n")
      end
    end
  end

  # Creates a menu item
  #
  # This function creates a menu item by creating an +li+ element, with a
  # link element inside it. It is assumed that this will be used inside
  # an unordered list with a class of "cssMenu" created by menubar. It is
  # expected that the +li+ element, and the link within it, will be
  # formatted with css to resemble a button.
  #
  # *Parameters*
  #
  # *text* is the text that will be used in the link. It may be blank.
  #
  # *image* is the image that will be used in the link. It may be blank.
  # If an image name is supplied, it will create the link with an embedded
  # image along with text.
  #
  # *url* is the url that will be used in the link. It takes the same
  # arguments as url_for.
  #
  # *permission* If the permission argument is supplied, it is expected to
  # evaluate to true or false. If permissions is true or nil the item is
  # displayed. If it is false, the item is not displayed.
  #
  # *html_options* are any options that will be used in the link. It may be
  # blank and takes the same arguments as +html_options+ in the
  # +link_to+ command.
  #
  # === Usage:
  #   <%= menubar do -%>
  #     <%= menu_item('Back to Home', 'house', root_path()) %>
  #   <%- end -%>
  #
  def menu_item(text='', image='', url='', permission=nil, html_options = {})
    text  = text.blank?  ? ""  : text
    image = image.blank? ? ""  : image_tag(cssmenu_clean_imagefile_name(image), :alt=>'')
    url   = url.blank?   ? "#" : url
    html_options = html_options.stringify_keys
    if permission.nil? || permission
      raw("<li>" + link_to( image + text, url, html_options ) + "</li>")
    end
  end

  # Creates a submenu
  #
  # This function creates a submenu item by creating an unordered list
  # inside a li element. It is expected that an unordered list within a
  # +cssMenu+ will be formatted with css to resemble a drop down box.
  #
  # *Parameters*
  #
  # *text* is the text that will be used in the link. It may be blank.
  #
  # *image* is the image that will be used in the link. It may be blank.
  # If an image name is supplied, it will create the link with an embedded
  # image along with text.
  #
  # *url* is the url that will be used in the link. It takes the same
  # arguments as url_for. This will usually be blank.
  #
  # *permission* If the permission argument is supplied, it is expected to
  # evaluate to true or false. If permissions is true or nil the item and
  # the submenu will be displayed. If it is false, then neither the item nor
  # the submenu is displayed.
  #
  # *html_options* are any options that will be used in the link. It may be
  # blank and takes the same arguments as +html_options+ in the
  # +link_to+ command.  This will usually be blank.
  #
  # *block* This function expects a block consisting of the menu items to
  # display. If no block is supplied, then no output is returned.
  #
  # === Usage:
  #   <%= menubar do -%>
  #     <%= sub_menu('Sub Item 2', 'add') do -%>
  #       <%= menu_item('Sub Sub Item 1', 'add', item1_path) %>
  #       <%= menu_item('Sub Sub Item 2', 'add', item2_path) %>
  #     <%- end -%>
  #   <%- end -%>
  #
  def sub_menu(text='', image='', url='', permission=nil, html_options = {}, &block)
    if block_given?
      content = capture(&block)
      text  = text.blank?  ? ""  : text
      image = image.blank? ? ""  : image_tag(cssmenu_clean_imagefile_name(image), :alt=>'')
      url   = url.blank?   ? "#" : url
      html_options = html_options.stringify_keys
      if permission.nil? || permission
        raw("    <li>" + link_to( "<span>" + image + text + "</span>", url, html_options ) + "\n      <ul>\n" + content + "      </ul></li>\n")
      end
    end
  end

  # Makes a menu item into a submit button.
  #
  # This function is a convienience function to aid in using menu items
  # inside a form. It adds javascript to the menu item to turn it into a
  # submit button.
  #
  # The intent is to use menu items to manipulate data sets within a form.
  # Typically you would display a dataset with checkboxes and use the menu
  # items to issue commands against the checked data items.
  #
  # *Parameters*
  #
  # *command* is the command that will be submitted.
  #
  # *options* is hash of options. The following options are supported.
  #
  # _form_name_ The +name+ of the form. Defaults to +taglist+.
  #
  # _tag_name_  The name of the form's submit tag. Defauts to +commit+.
  #
  # _confirm_   If present, a confirm dialog will be generated using this text.
  #
  # === Usage:
  #   <%= form_tag('/posts')do -%>
  #     <%= menubar do -%>
  #       <%= sub_menu('Tagged Actions', 'tag') do -%>
  #         <%= menu_item('Touch', 'finger', nil, nil, :onclick => js_submit('touch')) %>
  #         <%= menu_item('Delete', 'delete', nil, nil, {:onclick => js_submit('delete', :confirm => "Are you sure you want to delete the tagged registrations?"}) ) %>
  #       <%- end -%>
  #     <%- end -%>
  #     <div><%= check_box_tag 'post_1' -%>Post 1</div>
  #     <div><%= check_box_tag 'post_2' -%>Post 2</div>
  #     <div><%= check_box_tag 'post_3' -%>Post 3</div>
  #     <div><%= submit_tag 'Save' -%></div>
  #   <%- end -%>
  #
  def js_submit(command='', options={})
    options.to_options!
    form_name = options.delete(:form_name) || 'taglist'
    tag_name  = options.delete(:tag_name) || 'commit'
    submit_str = "document.#{form_name}['#{tag_name}'].value='#{command}'; document.#{form_name}.submit(); return false;"
    if confirm_str = options.delete(:confirm)
      output = "if (confirm('#{confirm_str}')) { #{submit_str} } else { return false; }"
    else
      output = submit_str
    end
    output.html_safe
  end

private

  # Normalizes image file names
  #
  # This function tries to find the file based on the name supplied. In
  # normal use you will only need to supply the image file name without
  # any extention. It will check for the supplied name as is, and with
  # .png, .gif, or .jpg extentions added to the supplied name, in the
  # public, public/images, and public/images/icons directories. If the
  # file is found, it's normalized path name is returned. Note: It will
  # also match any file that is explictly specified.
  #
  # This version is used internally, and should not be used by users.
  #
  def cssmenu_clean_imagefile_name(name='')
    root = Rails.public_path
    filename = ""
    # Shortcut to handle the most common cases.
    if FileTest.exist?( File.join( root, "/images/#{name}.png" ) )
      filename = "/images/#{name}.png"
    elsif FileTest.exist?( File.join( root, "/images/icons/#{name}.png" ) )
      filename = "/images/icons/#{name}.png"
    else
      # If not, check all
      ["", ".png", ".gif", ".jpg"].each do |ext|
        # Check if full path has been specified
        if FileTest.exist?( File.join( root, name + ext ) )
          filename = name + ext
        elsif FileTest.exist?( File.join( root, "/images/", name + ext ) )
          filename = File.join( "/images/", name + ext )
        elsif FileTest.exist?( File.join( root, "/images/icons/", name + ext ) )
          filename = File.join( "/images/icons/", name + ext )
        end
      end
    end
    if filename.blank?
      filename = "/images/broken.png"
    end
    filename
  end

end

ActionView::Base.send :include, CssMenu
