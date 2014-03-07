# encoding: UTF-8
require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class Prueba1 < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :phantomjs
    @base_url = "http://www2.scjn.gob.mx/Electoral/Paginas/Resultados.aspx?search=fraude&r=1&t=1&l=1&b=1&s=1&n=1&a=0&page=10"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_prueba1
    @driver.get(@base_url)
    assert !60.times{ break if (element_present?(:css, "td.dxpSummary") rescue false); sleep 1 }
    assert !60.times{ break if (element_present?(:css, "#ctl00_cphContent_TabPageControl_ctl50_pcTesis_PagerTop > tbody > tr > td.dxpCtrl > table > tbody > tr > td.dxpSummary") rescue false); sleep 1 }
    assert_equal "Página 1 de 19 (184 elementos)", @driver.find_element(:css, "td.dxpSummary").text
    assert_equal "Página 1 de 19 (184 elementos)", @driver.find_element(:css, "td.dxpSummary").text
    assert_equal "Página 1 de 19 (184 elementos)", @driver.find_element(:css, "td.dxpSummary").text
    assert_equal "Página 1 de 19 (184 elementos)", @driver.find_element(:css, "td.dxpSummary").text
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
