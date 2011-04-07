$:.unshift File.expand_path('../omniscient/', __FILE__)

require 'configuration'
require 'shell/shell'
require 'command'

module Omniscient
  DUMP_FILENAME = '.omni_dump.sql'
  DUMP_LOCAL_PATH = '~/'+DUMP_FILENAME
  DUMP_REMOTE_PATH = DUMP_FILENAME
end
