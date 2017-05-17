require "../Library/services_helper.rb"
require "../Library/xlsx_helper.rb"
require "rexml/document"
include REXML

test_start_time = Time.now

# ToDo: wyciaganie parametrow testu z pliku konfiguracji testu
test_params = get_test_data('../TestDataBase/SOU.SalesOfferPreparation/DaneTestowe.xlsx')
test_params.each_with_index do |test_param, index|
  log "[TEST]: Starting Test[#{index}] of SalesOfferPreparation endpoint"
  response_code, body, msg = Services.new.offerpreparation(
    cifApplicant = test_param[:cifApplicant],
    cifRelated = test_param[:cifRelated],
    source = test_param[:source],
    offerType = test_param[:offerType],
    productTypeFilter = test_param[:productTypeFilter]
  )
  expected_code = 200
  condition = expected_code == response_code
  assert "Endpoint response code assertion==> Expected code: '#{expected_code}' | Received code: '#{response_code}'", condition

  expected_permissionToApply = true
  received_permissionToApply = body['permissionToApply']
  condition = expected_permissionToApply == received_permissionToApply
  assert "permissionToApply assertion==> Expected: '#{expected_permissionToApply}' | Received: '#{received_permissionToApply}'", condition

  assert_not_empty?(param = 'offer', body['offers'])
end

=begin
test_params = {
  cifApplicant: 26016317,
  cifRelated: 26029373,
  source: '2',
  offerType: ['0'],
  productTypeFilter: ['BEX']
}

log '[TEST]: Starting Test of SalesOfferPreparation endpoint'
response_code, body, msg = Services.new.offerpreparation(
  cifApplicant = test_params[:cifApplicant],
  cifRelated = test_params[:cifRelated],
  source = test_params[:source],
  offerType = test_params[:offerType],
  productTypeFilter = test_params[:productTypeFilter]
)

# ToDo: Expected do testu tez z pliku (najlepiej tego samego co konfig testu)
expected_code = 200
condition = expected_code == response_code
assert "Endpoint response code assertion==> Expected code: '#{expected_code}' | Received code: '#{response_code}'", condition

expected_permissionToApply = true
received_permissionToApply = body['permissionToApply']
condition = expected_permissionToApply == received_permissionToApply
assert "permissionToApply assertion==> Expected: '#{expected_permissionToApply}' | Received: '#{received_permissionToApply}'", condition

assert_not_empty?(param = 'offer', body['offers'])
=end
log "Whole assertions done. Test completed in: #{Time.now - test_start_time}s"
