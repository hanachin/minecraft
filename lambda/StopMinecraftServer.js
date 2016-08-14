'use strict';

var AWS = require('aws-sdk');
AWS.config.region = 'ap-northeast-1';

function ec2Stop(instanceId, cb){
    var ec2 = new AWS.EC2();
    var params = {
        InstanceIds: [
            instanceId
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

function findMinecraftInstance(cb) {
  var ec2 = new AWS.EC2();
  var params = {
      Filters: [
          {
              Name: 'tag:Name',
              Values: ['minecraft']
          }
    ]
  }

  ec2.describeInstances(params, function(err, data) {
      if (!!err) {
          console.log('describe minecraft server instance: error');
          console.log(err, err.stack);
      } else {
          console.log('describe minecraft server instance: success');
          console.log(data);
          if (data.Reservations[0] && data.Reservations[0].Instances[0]) {
            cb(data.Reservations[0].Instances[0].InstanceId);
          }
      }
  });
}

exports.handler = function(event, context) {
    console.log('stop minecraft server instance: start');
    findMinecraftInstance(function (instanceId) {
        ec2Stop(instanceId, function() {
            context.done(null, 'stop minecraft server instance: done');
        });
    })
};
