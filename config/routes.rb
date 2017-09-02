Rails.application.routes.draw do
#  binding.pry

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/help'
# get 'static_pages/about'
  get  '/about', to: 'static_pages#about'
  get 'static_pages/addmember'
  get 'static_pages/contact'
  get 'static_pages/delmember'

end
