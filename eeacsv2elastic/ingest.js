var ElasticsearchCSV = require('elasticsearch-csv');

// create an instance of the importer with options
var esCSV = new ElasticsearchCSV({
    es: { index: 'INDEXNAME', type: 'logs', host: 'LOGSTASH_RW_USERNAME:LOGSTASH_RW_PASSWORD@elasticsearch:9200' },
    csv: { filePath: '/OUTPUTDIR/INDEXNAME.csv', headers: true }
});

esCSV.import()
    .then(function (response) {
        // Elasticsearch response for the bulk insert
        console.log(response);
    }, function (err) {
        // throw error
        throw err;
    });
