require 'test_helper'

class ImageTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

  def test_image_list
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, 'fakehost.fqdn')
    uri.expect(:port, '8754')
    uri.expect(:request_uri, '/ws.php')

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":{"paging":{"page":2,"per_page":2,"count":2,"total_count":"29"},"images":[{"id":39,"width":640,"height":480,"hit":0,"file":"pulirmen1.jpg","name":"pulirmen1","comment":null,"date_creation":"2001-03-20 15:01:27","date_available":"2019-11-07 15:48:24","page_url":"http:\/\/10.100.230.78\/picture.php?\/39","element_url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-70af44c1.jpg","derivatives":{"square":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-70af44c1-sq.jpg","width":120,"height":120},"thumb":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-70af44c1-th.jpg","width":144,"height":108},"2small":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-70af44c1-2s.jpg","width":240,"height":180},"xsmall":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-70af44c1-xs.jpg","width":432,"height":324},"small":{"url":"http:\/\/10.100.230.78\/_data\/i\/upload\/2019\/11\/07\/20191107154824-70af44c1-sm.jpg","width":576,"height":432},"medium":{"url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-70af44c1.jpg","width":"640","height":"480"},"large":{"url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-70af44c1.jpg","width":"640","height":"480"},"xlarge":{"url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-70af44c1.jpg","width":"640","height":"480"},"xxlarge":{"url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-70af44c1.jpg","width":"640","height":"480"}},"categories":[{"id":4,"url":"http:\/\/10.100.230.78\/index.php?\/category\/4","page_url":"http:\/\/10.100.230.78\/picture.php?\/39\/category\/4"}]},{"id":40,"width":1280,"height":960,"hit":0,"file":"quebec_city_in_snow_3.jpg","name":"quebec city in snow 3","comment":null,"date_creation":"2002-03-10 06:23:15","date_available":"2019-11-07 15:48:24","page_url":"http:\/\/10.100.230.78\/picture.php?\/40","element_url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-e45605e1.jpg","derivatives":{"square":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-sq.jpg","width":120,"height":120},"thumb":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-th.jpg","width":144,"height":108},"2small":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-2s.jpg","width":240,"height":180},"xsmall":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-xs.jpg","width":432,"height":324},"small":{"url":"http:\/\/10.100.230.78\/_data\/i\/upload\/2019\/11\/07\/20191107154824-e45605e1-sm.jpg","width":576,"height":432},"medium":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-me.jpg","width":792,"height":594},"large":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-la.jpg","width":1008,"height":756},"xlarge":{"url":"http:\/\/10.100.230.78\/i.php?\/upload\/2019\/11\/07\/20191107154824-e45605e1-xl.jpg","width":1224,"height":918},"xxlarge":{"url":"http:\/\/10.100.230.78\/upload\/2019\/11\/07\/20191107154824-e45605e1.jpg","width":"1280","height":"960"}},"categories":[{"id":4,"url":"http:\/\/10.100.230.78\/index.php?\/category\/4","page_url":"http:\/\/10.100.230.78\/picture.php?\/40\/category\/4"}]}]}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    Net::HTTP.stub(:new, httpclient) do
      results = Piwigo::Images.getImages(session, album_id: 4)

      refute results.nil?
      images = results[:images]
      refute images.nil?
      assert images.size == 2
      assert images[0].id == 39
      assert images[0].name == 'pulirmen1'
      paging = results[:paging]
      refute paging.nil?
    end

    uri.verify
    session.verify
    response.verify
    httpclient.verify
  end

  def test_lookup
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, 'fakehost.fqdn')
    uri.expect(:port, '8754')
    uri.expect(:request_uri, '/ws.php')

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":{"c8e8758dbfab0f0fa14c44edee1da8ad":"319"}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    file = 'fakeimage.png'
    File.stub(:binread, 'fakeimage file contents') do
      Net::HTTP.stub(:new, httpclient) do
        results = Piwigo::Images.lookup(session, file)       

        refute results.nil?
        assert results == '319'
      end
    end

    uri.verify
    session.verify
    response.verify
    httpclient.verify
  end

  def test_lookup_not_present
    uri = MiniTest::Mock.new
    uri.expect(:nil?, false)
    uri.expect(:host, 'fakehost.fqdn')
    uri.expect(:port, '8754')
    uri.expect(:request_uri, '/ws.php')

    session = MiniTest::Mock.new
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)
    session.expect(:uri, uri)

    session.expect(:id, '2')

    response = MiniTest::Mock.new
    response.expect(:code, '200')
    response.expect(:body, '{"stat":"ok","result":{"c8e8758dbfab0f0fa14c44edee1da8ad":null}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    file = 'fakeimage.png'
    File.stub(:binread, 'fakeimage file contents') do
      Net::HTTP.stub(:new, httpclient) do
        results = Piwigo::Images.lookup(session, file)

        assert results.nil?
      end
    end

    uri.verify
    session.verify
    response.verify
    httpclient.verify
  end


end
