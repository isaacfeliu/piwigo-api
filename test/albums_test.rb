require 'test_helper'

class AlbumsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Piwigo::VERSION
  end

  def test_album_list
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
    response.expect(:body, '{"stat":"ok","result":{"info":"Virtual album added","id":19}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    Net::HTTP.stub(:new, httpclient) do
      album = Piwigo::Albums::Album.new
      album.name = 'My First Album'
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
    uri.expect(:host, 'fakehost.fqdn')
    uri.expect(:port, '8754')
    uri.expect(:request_uri, '/ws.php')

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

  def test_album_lookup
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
    response.expect(:body, '{"stat":"ok","result":{"categories":[{"id":39,"name":"My First Album","comment":"","permalink":null,"status":"public","uppercats":"39","global_rank":"1","id_uppercat":null,"nb_images":0,"total_nb_images":0,"representative_picture_id":null,"date_last":null,"max_date_last":null,"nb_categories":0,"url":"http://10.100.230.78/index.php?/category/39"},{"id":18,"name":"Gatineau","comment":"","permalink":null,"status":"public","uppercats":"18","global_rank":"2","id_uppercat":null,"nb_images":33,"total_nb_images":33,"representative_picture_id":"310","date_last":"2019-11-07 15:50:17","max_date_last":"2019-11-07 15:50:17","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/18","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/07/20191107155015-f1ea2f17-th.jpg"},{"id":17,"name":"ChrisCottage","comment":"","permalink":null,"status":"public","uppercats":"17","global_rank":"3","id_uppercat":null,"nb_images":8,"total_nb_images":8,"representative_picture_id":"275","date_last":"2019-11-07 15:50:07","max_date_last":"2019-11-07 15:50:07","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/17","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107155004-93f8bff9-th.jpg"},{"id":16,"name":"album04","comment":"","permalink":null,"status":"public","uppercats":"16","global_rank":"4","id_uppercat":null,"nb_images":9,"total_nb_images":9,"representative_picture_id":"266","date_last":"2019-11-07 15:50:04","max_date_last":"2019-11-07 15:50:04","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/16","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107155001-8df7a1b5-th.jpg"},{"id":15,"name":"album03","comment":"","permalink":null,"status":"public","uppercats":"15","global_rank":"5","id_uppercat":null,"nb_images":10,"total_nb_images":10,"representative_picture_id":"256","date_last":"2019-11-07 15:50:00","max_date_last":"2019-11-07 15:50:00","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/15","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154957-5d2b7c80-th.jpg"},{"id":14,"name":"Thailand","comment":"","permalink":null,"status":"public","uppercats":"14","global_rank":"6","id_uppercat":null,"nb_images":47,"total_nb_images":47,"representative_picture_id":"209","date_last":"2019-11-07 15:49:37","max_date_last":"2019-11-07 15:49:37","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/14","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154925-a2d7f24d-th.jpg"},{"id":13,"name":"SteveCottage","comment":"","permalink":null,"status":"public","uppercats":"13","global_rank":"7","id_uppercat":null,"nb_images":10,"total_nb_images":10,"representative_picture_id":"199","date_last":"2019-11-07 15:49:25","max_date_last":"2019-11-07 15:49:25","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/13","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154922-3b0511d3-th.jpg"},{"id":12,"name":"Seoul","comment":"","permalink":null,"status":"public","uppercats":"12","global_rank":"8","id_uppercat":null,"nb_images":2,"total_nb_images":2,"representative_picture_id":"197","date_last":"2019-11-07 15:49:22","max_date_last":"2019-11-07 15:49:22","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/12","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154921-32e98e04-th.jpg"},{"id":11,"name":"SanFran","comment":"","permalink":null,"status":"public","uppercats":"11","global_rank":"9","id_uppercat":null,"nb_images":4,"total_nb_images":4,"representative_picture_id":"193","date_last":"2019-11-07 15:49:21","max_date_last":"2019-11-07 15:49:21","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/11","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154920-efbcd046-th.jpg"},{"id":10,"name":"myH","comment":"","permalink":null,"status":"public","uppercats":"10","global_rank":"10","id_uppercat":null,"nb_images":68,"total_nb_images":68,"representative_picture_id":"125","date_last":"2019-11-07 15:49:20","max_date_last":"2019-11-07 15:49:20","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/10","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154904-f4e9b00e-th.jpg"},{"id":9,"name":"Cloud","comment":"","permalink":null,"status":"public","uppercats":"9","global_rank":"11","id_uppercat":null,"nb_images":23,"total_nb_images":23,"representative_picture_id":"102","date_last":"2019-11-07 15:49:04","max_date_last":"2019-11-07 15:49:04","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/9","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154856-8e911e54-th.jpg"},{"id":8,"name":"Australia","comment":"","permalink":null,"status":"public","uppercats":"8","global_rank":"12","id_uppercat":null,"nb_images":18,"total_nb_images":18,"representative_picture_id":"84","date_last":"2019-11-07 15:48:55","max_date_last":"2019-11-07 15:48:55","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/8","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154850-d622e4af-th.jpg"},{"id":7,"name":"Ashcroft","comment":"","permalink":null,"status":"public","uppercats":"7","global_rank":"13","id_uppercat":null,"nb_images":20,"total_nb_images":20,"representative_picture_id":"64","date_last":"2019-11-07 15:48:34","max_date_last":"2019-11-07 15:48:34","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/7","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/07/20191107154829-a217abc3-th.jpg"},{"id":6,"name":"Artsy","comment":"","permalink":null,"status":"public","uppercats":"6","global_rank":"14","id_uppercat":null,"nb_images":11,"total_nb_images":11,"representative_picture_id":"53","date_last":"2019-11-07 15:48:29","max_date_last":"2019-11-07 15:48:29","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/6","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154827-af0728d3-th.jpg"},{"id":5,"name":"album09","comment":"","permalink":null,"status":"public","uppercats":"5","global_rank":"15","id_uppercat":null,"nb_images":7,"total_nb_images":7,"representative_picture_id":"46","date_last":"2019-11-07 15:48:27","max_date_last":"2019-11-07 15:48:27","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/5","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154825-e39140df-th.jpg"},{"id":4,"name":"album05","comment":"","permalink":null,"status":"public","uppercats":"4","global_rank":"16","id_uppercat":null,"nb_images":29,"total_nb_images":29,"representative_picture_id":"17","date_last":"2019-11-07 15:48:25","max_date_last":"2019-11-07 15:48:25","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/4","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154819-7279515b-th.jpg"},{"id":2,"name":"1999","comment":"","permalink":null,"status":"public","uppercats":"2","global_rank":"17","id_uppercat":null,"nb_images":0,"total_nb_images":16,"representative_picture_id":"1","date_last":null,"max_date_last":"2019-11-02 22:13:21","nb_categories":2,"url":"http://10.100.230.78/index.php?/category/2","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221112-7c09c33d-th.jpg"},{"id":1,"name":"CUOC","comment":"","permalink":null,"status":"public","uppercats":"2,1","global_rank":"17.1","id_uppercat":"2","nb_images":12,"total_nb_images":12,"representative_picture_id":"1","date_last":"2019-11-02 22:11:17","max_date_last":"2019-11-02 22:11:17","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/1","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221112-7c09c33d-th.jpg"},{"id":3,"name":"Kittens","comment":"","permalink":null,"status":"public","uppercats":"2,3","global_rank":"17.2","id_uppercat":"2","nb_images":4,"total_nb_images":4,"representative_picture_id":"13","date_last":"2019-11-02 22:13:21","max_date_last":"2019-11-02 22:13:21","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/3","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221320-297fee1c-th.jpg"}]}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    Net::HTTP.stub(:new, httpclient) do
      result = Piwigo::Albums.lookup(session, 'Gatineau')
      refute result.nil?
      assert result.id == 18
      assert result.name == 'Gatineau'
      assert result.status == 'public'
    end
    uri.verify
    session.verify
    response.verify
    httpclient.verify
  end


  def test_album_lookup_not_found
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
    response.expect(:body, '{"stat":"ok","result":{"categories":[{"id":39,"name":"My First Album","comment":"","permalink":null,"status":"public","uppercats":"39","global_rank":"1","id_uppercat":null,"nb_images":0,"total_nb_images":0,"representative_picture_id":null,"date_last":null,"max_date_last":null,"nb_categories":0,"url":"http://10.100.230.78/index.php?/category/39"},{"id":18,"name":"Gatineau","comment":"","permalink":null,"status":"public","uppercats":"18","global_rank":"2","id_uppercat":null,"nb_images":33,"total_nb_images":33,"representative_picture_id":"310","date_last":"2019-11-07 15:50:17","max_date_last":"2019-11-07 15:50:17","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/18","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/07/20191107155015-f1ea2f17-th.jpg"},{"id":17,"name":"ChrisCottage","comment":"","permalink":null,"status":"public","uppercats":"17","global_rank":"3","id_uppercat":null,"nb_images":8,"total_nb_images":8,"representative_picture_id":"275","date_last":"2019-11-07 15:50:07","max_date_last":"2019-11-07 15:50:07","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/17","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107155004-93f8bff9-th.jpg"},{"id":16,"name":"album04","comment":"","permalink":null,"status":"public","uppercats":"16","global_rank":"4","id_uppercat":null,"nb_images":9,"total_nb_images":9,"representative_picture_id":"266","date_last":"2019-11-07 15:50:04","max_date_last":"2019-11-07 15:50:04","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/16","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107155001-8df7a1b5-th.jpg"},{"id":15,"name":"album03","comment":"","permalink":null,"status":"public","uppercats":"15","global_rank":"5","id_uppercat":null,"nb_images":10,"total_nb_images":10,"representative_picture_id":"256","date_last":"2019-11-07 15:50:00","max_date_last":"2019-11-07 15:50:00","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/15","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154957-5d2b7c80-th.jpg"},{"id":14,"name":"Thailand","comment":"","permalink":null,"status":"public","uppercats":"14","global_rank":"6","id_uppercat":null,"nb_images":47,"total_nb_images":47,"representative_picture_id":"209","date_last":"2019-11-07 15:49:37","max_date_last":"2019-11-07 15:49:37","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/14","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154925-a2d7f24d-th.jpg"},{"id":13,"name":"SteveCottage","comment":"","permalink":null,"status":"public","uppercats":"13","global_rank":"7","id_uppercat":null,"nb_images":10,"total_nb_images":10,"representative_picture_id":"199","date_last":"2019-11-07 15:49:25","max_date_last":"2019-11-07 15:49:25","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/13","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154922-3b0511d3-th.jpg"},{"id":12,"name":"Seoul","comment":"","permalink":null,"status":"public","uppercats":"12","global_rank":"8","id_uppercat":null,"nb_images":2,"total_nb_images":2,"representative_picture_id":"197","date_last":"2019-11-07 15:49:22","max_date_last":"2019-11-07 15:49:22","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/12","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154921-32e98e04-th.jpg"},{"id":11,"name":"SanFran","comment":"","permalink":null,"status":"public","uppercats":"11","global_rank":"9","id_uppercat":null,"nb_images":4,"total_nb_images":4,"representative_picture_id":"193","date_last":"2019-11-07 15:49:21","max_date_last":"2019-11-07 15:49:21","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/11","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154920-efbcd046-th.jpg"},{"id":10,"name":"myH","comment":"","permalink":null,"status":"public","uppercats":"10","global_rank":"10","id_uppercat":null,"nb_images":68,"total_nb_images":68,"representative_picture_id":"125","date_last":"2019-11-07 15:49:20","max_date_last":"2019-11-07 15:49:20","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/10","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154904-f4e9b00e-th.jpg"},{"id":9,"name":"Cloud","comment":"","permalink":null,"status":"public","uppercats":"9","global_rank":"11","id_uppercat":null,"nb_images":23,"total_nb_images":23,"representative_picture_id":"102","date_last":"2019-11-07 15:49:04","max_date_last":"2019-11-07 15:49:04","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/9","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154856-8e911e54-th.jpg"},{"id":8,"name":"Australia","comment":"","permalink":null,"status":"public","uppercats":"8","global_rank":"12","id_uppercat":null,"nb_images":18,"total_nb_images":18,"representative_picture_id":"84","date_last":"2019-11-07 15:48:55","max_date_last":"2019-11-07 15:48:55","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/8","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154850-d622e4af-th.jpg"},{"id":7,"name":"Ashcroft","comment":"","permalink":null,"status":"public","uppercats":"7","global_rank":"13","id_uppercat":null,"nb_images":20,"total_nb_images":20,"representative_picture_id":"64","date_last":"2019-11-07 15:48:34","max_date_last":"2019-11-07 15:48:34","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/7","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/07/20191107154829-a217abc3-th.jpg"},{"id":6,"name":"Artsy","comment":"","permalink":null,"status":"public","uppercats":"6","global_rank":"14","id_uppercat":null,"nb_images":11,"total_nb_images":11,"representative_picture_id":"53","date_last":"2019-11-07 15:48:29","max_date_last":"2019-11-07 15:48:29","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/6","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154827-af0728d3-th.jpg"},{"id":5,"name":"album09","comment":"","permalink":null,"status":"public","uppercats":"5","global_rank":"15","id_uppercat":null,"nb_images":7,"total_nb_images":7,"representative_picture_id":"46","date_last":"2019-11-07 15:48:27","max_date_last":"2019-11-07 15:48:27","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/5","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154825-e39140df-th.jpg"},{"id":4,"name":"album05","comment":"","permalink":null,"status":"public","uppercats":"4","global_rank":"16","id_uppercat":null,"nb_images":29,"total_nb_images":29,"representative_picture_id":"17","date_last":"2019-11-07 15:48:25","max_date_last":"2019-11-07 15:48:25","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/4","tn_url":"http://10.100.230.78/i.php?/upload/2019/11/07/20191107154819-7279515b-th.jpg"},{"id":2,"name":"1999","comment":"","permalink":null,"status":"public","uppercats":"2","global_rank":"17","id_uppercat":null,"nb_images":0,"total_nb_images":16,"representative_picture_id":"1","date_last":null,"max_date_last":"2019-11-02 22:13:21","nb_categories":2,"url":"http://10.100.230.78/index.php?/category/2","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221112-7c09c33d-th.jpg"},{"id":1,"name":"CUOC","comment":"","permalink":null,"status":"public","uppercats":"2,1","global_rank":"17.1","id_uppercat":"2","nb_images":12,"total_nb_images":12,"representative_picture_id":"1","date_last":"2019-11-02 22:11:17","max_date_last":"2019-11-02 22:11:17","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/1","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221112-7c09c33d-th.jpg"},{"id":3,"name":"Kittens","comment":"","permalink":null,"status":"public","uppercats":"2,3","global_rank":"17.2","id_uppercat":"2","nb_images":4,"total_nb_images":4,"representative_picture_id":"13","date_last":"2019-11-02 22:13:21","max_date_last":"2019-11-02 22:13:21","nb_categories":0,"url":"http://10.100.230.78/index.php?/category/3","tn_url":"http://10.100.230.78/_data/i/upload/2019/11/02/20191102221320-297fee1c-th.jpg"}]}}')

    httpclient = MiniTest::Mock.new
    httpclient.expect(:request, response, [Net::HTTP::Post])

    Net::HTTP.stub(:new, httpclient) do
      result = Piwigo::Albums.lookup(session, 'Gatineau Park')
      assert result.nil?
    end
    uri.verify
    session.verify
    response.verify
    httpclient.verify
  end

end
