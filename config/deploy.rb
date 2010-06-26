require 'deprec'
  
set :application, "asteris_labs_crm"
set :domain, "crm.asterislabs.com"
set :repository,  "git://github.com/stalcottsmith/fat_free_crm.git"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
   
set :ruby_vm_type,      :ree        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :mysql      # :mysql, :postgresql, :sqlite

# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
# set :gems_for_project, %w(rmagick mini_magick image_science) # list of gems to be installed

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db,  domain, :primary => true, :no_release => true

# If you aren't deploying to /opt/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/opt/apps/#{application}"

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end
end

desc "Re-establish symlinks"
after "deploy:symlink" do
  sudo "chown -R app_#{application}:app_#{application} #{release_path}"
  # sudo "ln -nfs #{release_path}/config/getmailrc #{deploy_to}/.getmail"
  run <<-CMD
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    rm -f #{release_path}/.rvmrc && rm -rf #{release_path}/.bundle
  CMD
end