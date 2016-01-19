(function() {
  var bcrypt, db;

  db = require("redis").createClient();

  bcrypt = require('bcrypt');

  module.exports = function(sessions) {
    return {
      exists: function(req, res) {
        return db.hgetall(req.params.user, function(err, obj) {
          if (obj != null) {
            res.write('true');
          } else {
            res.write('false');
          }
          return res.end();
        });
      },
      "new": function(req, res) {
        return res.render('users/new', {
          js: (function() {
            return global.js;
          }),
          css: (function() {
            return global.css;
          })
        });
      },
      create: function(req, res) {
        return db.hgetall(req.body.username, function(err, obj) {
          if (obj) {
            return res.redirect(req.body.username);
          } else {
            return bcrypt.hash(req.body.password, 12, function(err, hash) {
              return db.hmset(req.body.username, {
                username: req.body.username,
                password: hash
              }, function() {
                req.headers['referer'] = "/" + req.body.username + "/edit";
                return sessions.create(req, res);
              });
            });
          }
        });
      }
    };
  };

}).call(this);
