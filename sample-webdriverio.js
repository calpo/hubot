/**
 * $ ./node_modules/phantomjs/bin/phantomjs --webdriver=4444
 * $ node sample-webdriverio.js
 */


var options = {
    desiredCapabilities: {
        browserName: 'firefox'
    }
};
var webdriverio = require('webdriverio');

/*
// HTML出力のSCならPhantom.jsで可能
webdriverio
    .remote(options)
    .init()
    .url('http://www.google.com')
    .title(function(err, res) {
        console.log('Title was: ' + res.value);
    })
    .saveScreenshot('./tmp_sc1.png')
    .end();
*/


// JSによる描画結果の取得は
// Selenium2 webdriver + firefox で有効
var client = webdriverio.remote(options);
client
    .init()
    .url('https://oshiete.goo.ne.jp/')
    .click('.popUpBtn a')
    .saveScreenshot('./tmp_sc.png')
    .end();
