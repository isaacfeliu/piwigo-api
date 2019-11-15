require "test_helper"

class PiwigoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

  def test_login_logoff_success
    logon = MiniTest::Mock.new
    logon.expect(:code, '200')
    logon.expect(:body, '{"stat":"ok","result":true}')
    logon.expect(:response, {'set-cookie' => 'pwg_id=ns4bilhgbr2nrhk0to226fs2cc; path=/; HttpOnly, pwg_remember=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/'})

    logout = MiniTest::Mock.new
    logout.expect(:code, '200')
    logout.expect(:body, '{"stat":"ok","result":true}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, logon, [Net::HTTP::Post])
    httpclient.expect(:request, logout, [Net::HTTP::Get])

      Net::HTTP.stub(:new, httpclient) do
        session = Piwigo::Session.new
        session.login('mygallery.fakefqdn.com', 'myuser', 'mypassword', https: false)

        assert session.session_id == ["pwg_id=ns4bilhgbr2nrhk0to226fs2cc"]

        session.logout
        assert session.session_id.nil?
      end
      logon.verify
      logout.verify
      httpclient.verify
  end


end
