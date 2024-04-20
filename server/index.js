const http = require('node:http');

async function ping(_req, res) {
	res.end();
	return;
}

async function fibonacciLoop(req, res) {
	if (req.params.sequenceNumber <= 1) {
		res.end(JSON.stringify({ result: req.params.sequenceNumber }));
		return;
	}

	let fibPrev = 0;
	let fibCurr = 1;

	for (let i = 2; i <= req.params.sequenceNumber; i++) {
		let temp = fibCurr;
		fibCurr += fibPrev;
		fibPrev = temp;
	}

	res.end(JSON.stringify({ result: fibCurr }));
	return;
}

async function fibonacciRecursion(req, res) {
	function recur(n) {
		if (n <= 1) {
			return n;
		}
		return recur(n - 1) + recur(n - 2);
	}
	const result = recur(req.params.sequenceNumber);
	res.end(JSON.stringify({ result }));
	return;
}

function requestHandler(request, response) {
	const router = {
		ping,
		'fibo-loop': fibonacciLoop,
		'fibo-recur': fibonacciRecursion,
	};

	// Parses the request
	const url = new URL(request.url ?? '', `http://${request.headers.host}`);
	const [_, endpoint] = url.pathname.split('/');

	// Checks if the endpoint is valid
	if (!Object.keys(router).includes(endpoint)) {
		response.statusCode = 404;
		response.end('Invalid endpoint');
		return;
	}

	// Checks if the parameter sent is a valid number
	const sequenceNumber = Number(url.searchParams.get('n'));
	if (Number.isNaN(sequenceNumber) || sequenceNumber < 0) {
		response.statusCode = 400;
		response.end('Invalid sequence number');
		return;
	}

	// Inserts the sequence number into the request object
	request.params = { sequenceNumber };

	// Executes the endpoint
	response.statusCode = 200;
	response.setHeader('Content-Type', 'application/json');
	const fn = router[endpoint];
	void fn(request, response);

	return;
}

const s = http
	.createServer(requestHandler)
	.listen({ port: process.env.PORT }, () => {
		console.log(`>>> server: listening on port ${process.env.PORT}`);
	})
	.on('close', () => {
		console.log('>>> server: closed');
	});

process.on('SIGINT', () => {
	s.close();
});
