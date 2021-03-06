require 'rails_helper'

feature 'likes' do
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

	context 'adding likes' do
		scenario 'a logged in user can add a like to a post', js: true do
			create_post
			click_link 'Like'
			expect(page).to have_content('1 like')
		end
		scenario 'a non-logged in user cannot add a like to a post', js: true do
			create_post
			click_link 'Sign out'
			visit '/posts'
			click_link 'Like'
			expect(page).to have_content('You must be logged in to like a post')
			expect(page).to have_content '0 likes'
		end
		scenario 'each user can only like a post once', js: true do
			create_post
			click_link 'Like'
			click_link 'Like'
			expect(page).to have_content('You have already liked this post')
			expect(page).to have_content('1 like')
		end
	end

end