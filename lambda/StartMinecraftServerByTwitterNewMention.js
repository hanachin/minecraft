'use strict';

const INSTANCE_ID = $instanceID;
const TWITTER_USER_NAMES = [];
const TOKEN = $token;

var AWS = require('aws-sdk');
AWS.config.region = 'ap-northeast-1';

function ec2Start(cb){
    var ec2 = new AWS.EC2();
    var params = {
        InstanceIds: [
            INSTANCE_ID
        ]
    };

    ec2.startInstances(params, function(err, data) {
        if (!!err) {
            console.log('start minecraft server instance: error');
            console.log(err, err.stack);
        } else {
            console.log('start minecraft server instance: success');
            console.log(data);
            cb();
        }
    });
}

exports.handler = function(event, context) {
    console.log(JSON.stringify(event));

    if (event.token != TOKEN) {
      context.done(null, 'start minecraft-server instance: failed, token is invalid');
      return;
    }

    if (TWITTER_USER_NAMES.every(function (n) { return n != event.user_name; })) {
      context.done(null, 'start minecraft-server instance: failed, user_name ' + event.user_name + ' is not found');
      return;
    }

    console.log('start minecraft server instance: start');
    ec2Start(function() {
        context.done(null, 'start minecraft server instance: done');
    });
};
