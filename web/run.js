
require('shelljs/global')
const fs = require('fs')

const res = exec(`find ../results -name "result.json"`,{silent:true}).stdout
var files = res.split('\n')
files = files.slice(0,files.length-1)

const results = []

exec('mkdir -p imgs')

files.forEach(function(resultFile){

  const accuracyFile = resultFile.replace('result.json', 'accuracy.log')

  const content = fs.readFileSync(resultFile, 'utf-8')

  const resultJson = JSON.parse(content)
  const modelName = resultJson.model_name
  const variant = resultJson.variant

  const outputPath = `imgs/${modelName}_${variant}.png`
  const title = `${modelName}_${variant}`
  exec(`python imagegen.py --inputPath ${accuracyFile} --outputPath ${outputPath} --title ${title}`)

  results.push(content)
})

exec(`echo ${JSON.stringify(results)} > results.json`)

console.log('done')
