river = require('../lib/river')

expectUpdate = (expectedValues) ->
  (newValues) ->
    expect(newValues).toEqual(expectedValues)

expectUpdates = (expectedValues...) ->
  callCount = 0
  (newValues) ->
    expectedNewValues = expectedValues[callCount]
    expect(newValues).toEqual(expectedNewValues)
    callCount++

describe "Bounded Queries", ->
  it "Compiles length based queries", ->
    ctx = river.createContext()
    query = ctx.addQuery 'SELECT * FROM data.win:length(2)'
    query.on('insert', expectUpdates({foo:1},{foo:2},{foo:3}))
    query.on('remove', expectUpdates({foo:1}))
    ctx.push('data', foo:1)
    ctx.push('data', foo:2)
    ctx.push('data', foo:3)

  it "Compiles where conditions", ->
    ctx = river.createContext()
    query = ctx.addQuery 'SELECT * FROM data.win:length(2) WHERE foo > 1'
    query.on('insert', expectUpdates({foo:2},{foo:3},{foo:4}))
    query.on('remove', expectUpdates({foo:2}))
    ctx.push('data', foo:1)
    ctx.push('data', foo:2)
    ctx.push('data', foo:1)
    ctx.push('data', foo:3)
    ctx.push('data', foo:1)
    ctx.push('data', foo:4)