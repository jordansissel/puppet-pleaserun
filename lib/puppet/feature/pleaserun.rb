require 'puppet/util/feature'

Puppet.features.add(:pleaserun) do
  begin
    require "pleaserun/platform/base"
    require "pleaserun/cli"
    require "pleaserun/detector"
    true
  rescue LoadError => err
      warn "Cannot load the pleaserun gem. #{err}"
  end
end
