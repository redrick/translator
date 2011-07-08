# encoding: UTF-8
#
shared_examples_for "translations_management" do
  scenario "see translations keys specified in main language yaml file" do
    page.should have_content "hello.world"
  end

  scenario "see translations provided in language files" do
    visit root_path
    page.should have_content "Hello world!"
    visit root_path(:locale => "pl")
    page.should have_content "Witaj, Świecie"
  end

  scenario "editing translations" do
    within :css, "#pl-hello-world" do
      fill_in "value", :with => "Elo ziomy"
      click_button I18n.t('translator.save')
    end

    within :css, "#en-hello-world" do
      fill_in "value", :with => "Yo hommies"
      click_button I18n.t('translator.save')
    end

    visit root_path
    page.should have_content("Yo hommies")
    visit root_path(:locale => "pl")
    page.should have_content("Elo ziomy")
  end

  scenario "see only app translations by default, Rails ones after changing tab" do
    page.should_not have_content("date.formats")
    click_link I18n.t('translator.framework_translations')
    page.should have_content("date.formats")
  end

  scenario "paginate translations, 10 on every page" do
    click_link I18n.t('translator.framework_translations')
    page.should_not have_content("helpers.submit.submit")
    click_link "2"
    page.should have_content("helpers.submit.submit")
  end
end

