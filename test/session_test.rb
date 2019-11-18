require "test_helper"

class SessionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

  def test_login_logoff_success
    logon = MiniTest::Mock.new
    logon.expect(:code, '200')
    logon.expect(:body, '{"stat":"ok","result":true}')
    logon.expect(:response, {'set-cookie' => 'pwg_id=ns4bilhgbr2nrhk0to226fs2cc; path=/; HttpOnly, pwg_remember=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/'})
    logon.expect(:code, '200')
    logon.expect(:body, '{"stat":"ok","result":{"username":"Adrian","status":"webmaster","theme":"modus","language":"en_GB","pwg_token":"9edde6a1ae535934cca6a2423f9bcbe7","charset":"utf-8","current_datetime":"2019-11-17 22:12:40","version":"2.10.1","available_sizes":["square","thumb","2small","xsmall","small","medium","large","xlarge","xxlarge"],"upload_file_types":"jpg,jpeg,png,gif","upload_form_chunk_size":500}}')

    logout = MiniTest::Mock.new
    logout.expect(:code, '200')
    logout.expect(:body, '{"stat":"ok","result":true}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, logon, [Net::HTTP::Post])
    httpclient.expect(:request, logon, [Net::HTTP::Post])
    httpclient.expect(:request, logout, [Net::HTTP::Get])

      Net::HTTP.stub(:new, httpclient) do
        session = Piwigo::Session.login('mygallery.fakefqdn.com', 'myuser', 'mypassword', https: false)

        refute session.nil?
        assert session.id == "pwg_id=ns4bilhgbr2nrhk0to226fs2cc"
        assert session.pwg_token == "9edde6a1ae535934cca6a2423f9bcbe7"
        assert session.username == "Adrian"

        session.logout
        assert session.id.nil?
      end
      logon.verify
      logout.verify
      httpclient.verify
  end


end
