require 'rails_helper'

feature 'following' do
	before do
		visit '/'
		click_link 'Sign up'
		fill_in('Email', with: 'test@test.com')
		fill_in('Password', with: '123456')
		fill_in('Password confirmation', with: '123456')
		click_button('Sign up')
	end
	after do
		remove_uploaded_file
	end

	context 'viewing a list of users' do
		scenario 'at the user index page a user should see all users' do
			visit '/'
			click_link 'Sign out'
			click_link 'Sign up'
			fill_in('Email', with: 'test2@test.com')
			fill_in('Password', with: '123456')
			fill_in('Password confirmation', with: '123456')
			click_button('Sign up')
			click_link 'View users'
			expect(current_path).to eq '/users'
			expect(page).to have_content('test@test.com')
			expect(page).to have_content('test2@test.com')
		end
	end

	context 'following a user' do
		scenario 'a user can click to follow a user then see their posts in the feed' do
			visit '/'
			create_post
			click_link 'Sign out'
			click_link 'Sign up'
			fill_in('Email', with: 'test2@test.com')
			fill_in('Password', with: '123456')
			fill_in('Password confirmation', with: '123456')
			click_button('Sign up')
			create_post(caption: 'Post I am not interested in')
			click_link 'Sign out'
			click_link 'Sign up'
			fill_in('Email', with: 'test3@test.com')
			fill_in('Password', with: '123456')
			fill_in('Password confirmation', with: '123456')
			click_button('Sign up')
			click_link 'View users'
			user = User.find_by(email: 'test@test.com')
			click_link('Follow', href: "/users/#{user.id}/follow")
			visit('/my_feed')
			expect(page).to have_content('The best name ever')
			expect(page).not_to have_content('Post I am not interested in')
		end
	end

end