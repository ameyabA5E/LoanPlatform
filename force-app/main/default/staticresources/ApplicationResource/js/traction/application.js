function isInIframe() {
	return self !== top;
	// Alternative test: (window.location != window.parent.location) ? true : false;
}

function adjustHeight() {
	if (isInIframe() == true) {
		var html = document.documentElement;
		var actual_height = html.scrollHeight + 10;
		window.parent.postMessage(actual_height,"*");
	} else {
		// do nothing, if not in Iframe
	}
}

function scrollToTop() {
	if (isInIframe() == true) {
		window.parent.postMessage("scroller = true","*");
	} else {
		$("#topOfSteps")[0].scrollIntoView(true);
	}
	return;
}

/****************************************************************************************/
// topOrigin needs to be set in every page using custom setting
function xDomainHandler(event) {
	event = event || window.event;
	var origin = event.origin;
	if (topOrigin != '*' && origin.indexOf(topOrigin, origin.length - topOrigin.length) === -1) {
		return;
	}
	
	try {
		var data = JSON.parse(event.data);
	} catch (e) {
		// SyntaxError or JSON is undefined.
		return;
	}
	if (data.cid) {
		sendHit(data.cid);
	}
}

if (window.addEventListener) {
	window.addEventListener('message', xDomainHandler, false);
} else if (window.attachEvent) {
	window.attachEvent('onmessage', xDomainHandler);
}

function dataPush(cid, url, title) {
	dataLayer.push({
		'event':'virtualPageView',
		'virtualPageClientId':cid,
		'virtualPageURL':url,
		'virtualPageTitle':title
	});
}


var alreadySent = false;
var virtualPageClientId = '';
var virtualPageURL; 
var virtualPageTitle;

function sendHit(cid) {
	if (alreadySent) return;
	alreadySent = true;
	virtualPageClientId = cid;
	dataPush(virtualPageClientId, virtualPageURL, virtualPageTitle);
}

function pushHit(vUrl, vTitle) {
	if (virtualPageClientId == '') {
		// Get client id

		// Set url and title for callback
		virtualPageURL = vUrl;
		virtualPageTitle = vTitle;

		if (!window.postMessage) {
			// If no postMessage Support.
			sendHit();
		} else {
			// Tell top that we are ready.
			window.parent.postMessage('send_client_id', '*');
			// Set a timeout in case top doesn't respond.
			setTimeout(sendHit, 200);
		}
	} else {
		dataPush(virtualPageClientId, vUrl, vTitle);
	}

}


/****************************************************************************************/

$(document).ready( function () {
	adjustHeight();
});