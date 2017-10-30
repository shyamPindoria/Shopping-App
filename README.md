<h1>INFT 3033 - Mobile Application Enterprise Development</h1>
<h2>Assignment 2</h2>
<h3>Shopping App</h3>
<p>You are a developer who has been contracted to produce a “shopping app” for a 3D printing company specialising in cosplay. The client has a number of venues around the country where they keep a range of 3D printers able to produce products in different materials, and they attend a series of conventions and events around the country. When a client places an order, the order will be filled at the nearest printing venue and the client can either collect the part or have it shipped to their address.</p>
<p>The client specs are detailed below (they are very knowledgeable developers themselves but have no time to complete the app). The client stipulates that they want at least 6 different items in a master menu view, including:</p>
<ul>
<li>“Homepage” containing a nice graphic, either as a picture or 3D rendering;</li>
<li>“List” of products with pictures for each model, together with pricing information for multiple print materials and a button to add items to a shopping cart</li>
<li>“Search” function whereby users can easily locate amodel</li>
<li>“Cart”, which stores all information about the user's purchases and provides a running total in dollars.</li>
<li>“Finder”, which allows the user to find the closest 3D printing venue relative to their current location</li>
<li>“Checkout”, which allows the user to enter credit card details to make a purchase</li>
</ul>
<p>Required elements:</p>
<ul>
<li>Master-view controller with at least 6 different detail views configured in storyboard and containing different outlets (graphics, buttons, text fields, etc.) (30%)</li>
<li>Model-view-controller design pattern with custom classes specifying all the detail view properties and methods, plus a local database containing specifying all the items on the product menu and their metadata (image, pricing, availability) (40%)</li>
<li>Network database accessibility using the SwiftyJSON framework for checkout (15%) and network-based location mapping for the store finder (15%)</li>
</ul>
<p>The intent is to produce an application which would closely mirror a commercial product.</p>
<h2>Pricing</h2>
<p>Each product will have  set price. However, that price is for printing in PLA with no painting. Printing in ABS will add 10% to the price, while painting and finished adds 55%. </p>
<h2>Server</h2>
<p>You will be provided with access to a JSON data stream and the specifications for the server by the end of week 9. (The original server is playing up, so we're moving it to something more reliable). Checkout will not need to be secure - you will need to collect the credit card data but not transmit it. You will be able to submit a request for checkout to the server without including credit card information, and it will respond confirming that checkout has been completed.</p>
<p>The server will provide a list of outlets with GPS coordinates and confirmation of a successful checkout.</p>
<p>The server will located at: http://partiklezoo.com/3dprinting/</p>
<p>To get a list of products, the base URL http://partiklezoo.com/<span>3dprinting</span>/ will work. Products will be returned as JSON data, as an array in which each record has the fields UID, price, name, description, image, and category. Category can be "3D printers" or "Consumables". Example data:</p>
<pre>[<br /> {"name": "D.Va Headset",<br /> "price": "60.00",<br /> "image": "http://partiklezoo.com/3dprinting/u0001.jpg",<br /> "description": "A headset as worn by Hana Song in Overwatch",<br /> "category": "Overwatch",<br /> "uid": "u0001" },<br /> {"name": "Scout's Gun",<br /> "price": "98.00",<br /> "image": "http://partiklezoo.com/3dprinting/u0002.jpg",<br /> "description": "The gun used by Scout in Team Fortress 2",<br /> "category": "TF2, Team Fortress 2",<br /> "uid": "u0002" }<br />]</pre>
<p>To make a purchase, you need to provide (using get or post) the action "purchase", each UID used with a field for the number of products, and the total price. For example, to purchase two of the first item, with the u0001, you would send:</p>
<pre>http://partiklezoo.com/products/?action=purchase&amp;u0001=2&amp;total=120&amp;material=pla&amp;painting=false</pre>
<p>As the price is correct for two of u0001, it will return:</p>
<pre><span>{ "success": "true" }</span></pre>
<p>If incorrect, it will return:</p>
<pre><span>{ "success": "false" }</span></pre>
<p>Finally, to get a list of locations, you need to send two GPS coordinates as coord1 and coord2, with the action "locations". An error will return the "false" message above. A successful request will return:</p>
<pre>[<br /> {"street": "939 Marion Rd",<br /> "suburb": "Mitchell Park",<br /> "postcode": "5043",<br /> "state": "SA",<br /> "countrycode": "au",<br /> "uid": "a0001" },<br /> {"street": "449/459 Port Rd",<br /> "suburb": "Croydon",<br /> "postcode": "5008",<br /> "state": "SA",<br /> "countrycode": "au",<br /> "uid": "a0002" }<br />]</pre>
<p></p>
