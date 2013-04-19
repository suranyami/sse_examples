# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.items do |primary|
    # Need to do this to get Twitter Bootstrap to render properly.
    primary.dom_class = :nav
    primary.item :'nav-posts', 'Posts', posts_path
  end
end
