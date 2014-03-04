describe 'djangoAjax:', ->
  mod = {}

  beforeEach module('app.djangoAjax')

  it 'should be registered', ->
    expect(mod).not.to.equal null


  describe 'djangoAjax.queryService:', ->
    service = {}
    simple_data =
      member: true
      member2: 'string'
      member3: 100

    simple_params = "member=true&member2=string&member3=100"

    data =
      member: [5, 10]
      member2: 'string'
      member3: 100

    complex_params = "member=5&member=10&member2=string&member3=100"

    beforeEach module('app.djangoAjax')

    beforeEach inject [
      '$queryService'
      ($queryService) ->
        service = $queryService
    ]

    it 'should have a queryService', ->
      expect(service).to.not.equal null

    it 'should parametricize a simple data object', ->
      params = service.param simple_data

      expect( params )
        .to.equal simple_params

    it 'should parametricize a complex data object', ->
      params = service.param data

      expect( params )
        .to.equal complex_params