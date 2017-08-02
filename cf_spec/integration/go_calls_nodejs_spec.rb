$: << 'cf_spec'
require 'yaml'
require 'spec_helper'

describe 'running supply nodejs buildpack before the go buildpack' do
  let(:buildpack) { ENV.fetch('SHARED_HOST')=='true' ? 'multi_buildpack' : 'multi-test-buildpack' }
  let(:app) { Machete.deploy_app(app_name, buildpack: buildpack) }
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'the app is pushed' do
    let (:app_name) { 'go_calls_nodejs' }

    it 'finds the supplied dependency in the runtime container' do
      expect(app).to be_running
      expect(app).to have_logged "Multi Buildpack version"
      expect(app).to have_logged "Nodejs Buildpack version"

      browser.visit_path('/')
      expect(browser).to have_body(/INFO hello world/)
    end
  end
end
