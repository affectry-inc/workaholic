# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'Admin User', 
            email: 'admin@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: true)
User.create(name: 'Dai Moriya', 
            email: 'dai.moriya@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Yuya Tokuzato', 
            email: 'yuya.tokuzato@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Manabu Ikeda', 
            email: 'manabu.ikeda@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Shizuka Kakimoto', 
            email: 'shizuka.kakimoto@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Yoshihiro Kato', 
            email: 'yoshihiro.kato@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Tatsuyuki Otani', 
            email: 'tatsuyuki.otani@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Ryota Kabuyama', 
            email: 'ryota.kabuyama@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Yumemaro Hirayama', 
            email: 'yumemaro.hirayama@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)
User.create(name: 'Miki Chiba', 
            email: 'miki.chiba@linkage.jp.net', 
            password: 'linkage00', 
            password_confirmation: 'linkage00', 
            admin: false)

Language.create(lang_id: 0, name: 'jp')
Language.create(lang_id: 1, name: 'en')

Category.create(ctgr_id: 0, lang_id: 0, val: 0, name: '出勤')
Category.create(ctgr_id: 0, lang_id: 0, val: 1, name: '休暇')
Category.create(ctgr_id: 0, lang_id: 1, val: 0, name: 'Attendance')
Category.create(ctgr_id: 0, lang_id: 1, val: 1, name: 'Absence')

Group.create(name: 'Admin', priv_level: 0)
Group.create(name: 'Moriya', priv_level: 1)
Group.create(name: 'Secretary', priv_level: 1)
Group.create(name: 'Director', priv_level: 2)
Group.create(name: 'JEPCO', priv_level: 2)
Group.create(name: 'Member', priv_level: 10)

GroupMember.create(group_id: 1, user_id: 1)
GroupMember.create(group_id: 2, user_id: 2)
GroupMember.create(group_id: 3, user_id: 10)
GroupMember.create(group_id: 4, user_id: 3)
GroupMember.create(group_id: 4, user_id: 7)
GroupMember.create(group_id: 5, user_id: 4)
GroupMember.create(group_id: 5, user_id: 5)
GroupMember.create(group_id: 5, user_id: 6)
GroupMember.create(group_id: 6, user_id: 8)
GroupMember.create(group_id: 6, user_id: 9)

GroupRelation.create(applicant_group_id: 1, approver_group_id: 1)
GroupRelation.create(applicant_group_id: 2, approver_group_id: 2)
GroupRelation.create(applicant_group_id: 3, approver_group_id: 2)
GroupRelation.create(applicant_group_id: 4, approver_group_id: 2)
GroupRelation.create(applicant_group_id: 5, approver_group_id: 2)
GroupRelation.create(applicant_group_id: 6, approver_group_id: 2)
GroupRelation.create(applicant_group_id: 6, approver_group_id: 4)

Approver.create(user_id: 1, approver_user_id: 1)
Approver.create(user_id: 2, approver_user_id: 2)
Approver.create(user_id: 3, approver_user_id: 2)
Approver.create(user_id: 4, approver_user_id: 2)
Approver.create(user_id: 5, approver_user_id: 2)
Approver.create(user_id: 6, approver_user_id: 2)
Approver.create(user_id: 7, approver_user_id: 2)
Approver.create(user_id: 8, approver_user_id: 3)
Approver.create(user_id: 9, approver_user_id: 3)
Approver.create(user_id: 10, approver_user_id: 2)
