function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}


setupWebViewJavascriptBridge(function(bridge) {
                             
                             /* Initialize your app here */
                             
                             bridge.registerHandler('JS Echo', function(data, responseCallback) {
                                                    console.log("JS Echo called with:", data)
                                                    responseCallback(data)
                                                    })
                             bridge.callHandler('ObjC Echo', function responseCallback(responseData) {
                                                console.log("JS received response:", responseData)
                                                })
                             })
