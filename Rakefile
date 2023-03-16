# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"users.inspect


require 'bundler/audit/task'
Bundler::Audit::Task.new
require 'bundler/plumber/task'
Bundler::Plumber::Task.new

task default: 'bundle:leak'

Rails.application.load_tasks
