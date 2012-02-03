#### [node.js](http://nodejs.org) setups
# - Override `.run`.
# - Inherit `EventEmitter`.
# - Register _.co_ extension.

module.exports = (LiveScript) ->
  fs   = require \fs
  path = require \path

  LiveScript.run = (code, options or {}) ->
    {main} = require
    main.moduleCache &&= {}
    # Hack for relative `require`.
    filename = \.
    if options.filename
      try that = fs.readlinkSync that
      main.paths = main.._nodeModulePaths path.dirname that
      filename = process.argv.1 = path.resolve that
    main <<< {filename}
    options.js or code = LiveScript.compile code, {filename, +bare}
    try main._compile code, filename catch throw hackTrace e, code, filename

  LiveScript import all require(\events)EventEmitter::

  require.extensions\.co = (module, filename) ->
    js = LiveScript.compile fs.readFileSync(filename, \utf8), {filename, +bare}
    try module._compile js, filename catch throw hackTrace e, js, filename

# Weave the source into stack trace.
function hackTrace error, js, filename
  traces = error?stack / \\n
  return error unless traces.length > 1
  for trace, i in traces
    continue if 0 > index = trace.indexOf "(#filename:"
    {1: lno} = /:(\d+):/exec trace.slice index + filename.length or ''
    continue unless +=lno
    {length} = '' + end = lno+4; lines ||= js / \\n
    for n from 1 >? lno-4 to end
      traces[i] += "\n#{ ('    ' + n)slice -length }
                      #{ '|+'charAt n is lno } #{[lines[n-1]]}"
  error <<< stack: traces.join \\n
