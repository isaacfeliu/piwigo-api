require "test_helper"

class PiwigoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

  def test_album_list  
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, "fakehost.fqdn")
    uri.expect(:port, "8754")
    uri.expect(:request_uri, "/ws.php")

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')
    

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":{"categories":[{"id":18,"name":"Gatineau","comment":"","permalink":null,"status":"public","uppercats":"18","global_rank":"1","id_uppercat":null,"nb_images":33,"total_nb_images":33,"representative_picture_id":"283","date_last":"2019-11-07 15:50:17","max_date_last":"2019-11-07 15:50:17","nb_categories":0,"url":"http:\/\/10.100.230.78\/index.php?\/category\/18","tn_url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107155007-860a2373-th.jpg"}]}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])


      Net::HTTP.stub(:new, httpclient) do
        albums = Piwigo::Albums.list(session)

        refute albums.nil?
        assert albums.size == 1
        assert albums[0].id == 18
        assert albums[0].name == 'Gatineau'
        assert albums[0].status == 'public'

      end
      uri.verify
      session.verify
      response.verify
      httpclient.verify
  end


  def test_album_add
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, "fakehost.fqdn")
    uri.expect(:port, "8754")
    uri.expect(:request_uri, "/ws.php")

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')
    

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":{"info":"Virtual album added","id":19}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])


      Net::HTTP.stub(:new, httpclient) do
        album = Piwigo::Albums::Album.new
        album.name = "My First Album"
        album = Piwigo::Albums.add(session, album)
    
        refute album.nil?
        assert album.id == 19

      end
      uri.verify
      session.verify
      response.verify
      httpclient.verify
  end  


  def test_album_delete
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, "fakehost.fqdn")
    uri.expect(:port, "8754")
    uri.expect(:request_uri, "/ws.php")

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')
    session.expect(:pwg_token, 'pwg_token')    

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":null}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])


      Net::HTTP.stub(:new, httpclient) do
        result = Piwigo::Albums.delete(session, 19)
    
        assert result

      end
      uri.verify
      session.verify
      response.verify
      httpclient.verify
  end    

end
