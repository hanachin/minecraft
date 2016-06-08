'use strict';

const INSTANCE_ID = $instanceID;

var AWS = require('aws-sdk');
AWS.config.region = 'ap-northeast-1';

function ec2Stop(cb){
    var ec2 = new AWS.EC2();
    var params = {
        InstanceIds: [
            INSTANCE_ID
        ]
    };

    ec2.stopInstances(params, function(err, data) {
        if (!!err) {
            console.log('stop minecraft server instance: error');
            console.log(err, err.stack);
        } else {
            console.log('stop minecraft server instance: success');
            console.log(data);
            cb();
        }
    });
}

exports.handler = function(event, context) {
    console.log('stop minecraft server instance: start');
    ec2Stop(function() {
        context.done(null, 'stop minecraft server instance: done');
    });
};
