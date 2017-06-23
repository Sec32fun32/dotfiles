rbenv_root = "#{anyenv_root}/envs/rbenv"

install_env 'rbenv'

git "#{rbenv_root}/plugins/rbenv-default-gems" do
  repository 'https://github.com/sstephenson/rbenv-default-gems'
  revision 'de4ff2e101c9221dcd92ed91a41edcea2be41945'
end

file "#{rbenv_root}/default-gems" do
  content "#{(node.dig(:rbenv, :'default-gems') || []).join("\n")}\n"
end

install_env_versions 'rbenv' do
  versions node.dig(:rbenv, :versions)
end

env_global 'rbenv' do
  version node.dig(:rbenv, :global)
end
