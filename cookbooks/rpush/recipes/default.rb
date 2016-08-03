#
# Cookbook Name:: rpush
# Recipe:: default
#
node[:applications].each do |app_name,data|
  ey_cloud_report "rpush" do
    message "Setting up rpush"
  end

  user = node[:users].first
  case node[:instance_role]
  when "solo", "app", "app_master"
    template "/engineyard/bin/rpush" do
      source "rpush.erb"
      owner user[:username]
      group user[:username]
      mode 0755
      variables({
        :app_name => app_name,
        :framework_env => node[:environment][:framework_env]
      })
    end

    template "/etc/monit.d/rpush.monitrc" do
      source "rpush.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :app_name => node[:app_name]
        :user => node[:owner_name],
        :group => node[:owner_name]
      })
    end
  end
end