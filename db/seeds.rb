# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Language.create(:lang_id => 0, :name => 'JP')
Language.create(:lang_id => 1, :name => 'EN')

Category.create(:ctgr_id => 0, :lang_id => 0, :val => 0, :name => '出勤')
Category.create(:ctgr_id => 0, :lang_id => 0, :val => 1, :name => '休暇')
Category.create(:ctgr_id => 0, :lang_id => 1, :val => 0, :name => 'Attendance')
Category.create(:ctgr_id => 0, :lang_id => 1, :val => 1, :name => 'Absence')
