# encoding: UTF-8
require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class EditarArticuloSeltest < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :phantomjs
    @base_url = "http://localhost:9292/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_editar_articulo_sel
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Mi primer blog").click
    @driver.find_element(:link, "Crear artículo").click
    @driver.find_element(:id, "post_titulo").clear
    @driver.find_element(:id, "post_titulo").send_keys "prueba editar"
    @driver.find_element(:id, "post_texto").clear
    @driver.find_element(:id, "post_texto").send_keys "texto prueba editar"
    @driver.find_element(:name, "commit").click
    assert !60.times{ break if (element_present?(:link, "Editar") rescue false); sleep 1 }
    @driver.find_element(:link, "Editar").click
    @driver.find_element(:id, "post_texto").clear
    @driver.find_element(:id, "post_texto").send_keys "texto prueba editar\nmas texto editado"
    @driver.find_element(:id, "post_titulo").clear
    @driver.find_element(:id, "post_titulo").send_keys "prueba editar editado"
    @driver.find_element(:name, "commit").click
    verify { assert element_present?(:link, "Editar") }
    assert_equal "Texto: texto prueba editar mas texto editado", @driver.find_element(:xpath, "//p[2]").text
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
