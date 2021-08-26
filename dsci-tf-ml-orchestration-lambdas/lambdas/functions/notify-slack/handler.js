const https = require("https");

exports.lambda_handler = (event, context, callback) => {
  let path = ''
  if(event.channel && event.channel === 'CH8GNNVS5' ){
    path= "/services/T0UKUKNBV/BHM04HA8H/mKcG4rDrTGCUjFPXs0kbGaAZ"
  }
  else{
    path= "/services/T0UKUKNBV/BFSSRMUHJ/4cDo5CT9cOlLVQkPkMQeiDtZ"
  }
  const payload = JSON.stringify({
    text: `${event.message} ${
      event.inputs && event.inputs.length > 0 ? event.inputs.join(" ") : ""
    }`
  });

  const options = {
    hostname: "hooks.slack.com",
    method: "POST",
    path: path
  }

  const req = https.request(options, res =>
    res.on("data", () => callback(null, "OK"))
  );
  req.on("error", error => callback(JSON.stringify(error)));
  req.write(payload);
  req.end();
};
