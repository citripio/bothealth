require "application_system_test_case"

class FacebookPagesTest < ApplicationSystemTestCase
  setup do
    @facebook_page = facebook_pages(:one)
  end

  test "visiting the index" do
    visit facebook_pages_url
    assert_selector "h1", text: "Facebook Pages"
  end

  test "creating a Facebook page" do
    visit facebook_pages_url
    click_on "New Facebook Page"

    fill_in "Access token", with: @facebook_page.access_token
    fill_in "Name", with: @facebook_page.name
    fill_in "Organization", with: @facebook_page.organization_id
    click_on "Create Facebook page"

    assert_text "Facebook page was successfully created"
    click_on "Back"
  end

  test "updating a Facebook page" do
    visit facebook_pages_url
    click_on "Edit", match: :first

    fill_in "Access token", with: @facebook_page.access_token
    fill_in "Name", with: @facebook_page.name
    fill_in "Organization", with: @facebook_page.organization_id
    click_on "Update Facebook page"

    assert_text "Facebook page was successfully updated"
    click_on "Back"
  end

  test "destroying a Facebook page" do
    visit facebook_pages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Facebook page was successfully destroyed"
  end
end
