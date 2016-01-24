;(function(e,t,n){function i(n,s){if(!t[n]){if(!e[n]){var o=typeof require=="function"&&require;if(!s&&o)return o(n,!0);if(r)return r(n,!0);throw new Error("Cannot find module '"+n+"'")}var u=t[n]={exports:{}};e[n][0](function(t){var r=e[n][1][t];return i(r?r:t)},u,u.exports)}return t[n].exports}var r=typeof require=="function"&&require;for(var s=0;s<n.length;s++)i(n[s]);return i})({1:[function(require,module,exports){
(function() {
  $(function() {
    return $.get('/users', function(data) {
      var member, _i, _len, _ref, _results;
      _ref = JSON.parse(data);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        member = _ref[_i];
        _results.push($('#members tbody').append("<tr>\n  <td>" + member.number + "</td>\n  <td>" + member.name + "</td>\n  <td>" + (moment(member.date, 'MMMM Do YYYY, h:mm:ss a').format('lll')) + "</td>\n  <td><a href='https://tradeblock.com/bitcoin/tx/" + member.txid + "'>" + (member.txid.substr(0, 5)) + "...</a></td>\n</tr>"));
      }
      return _results;
    });
  });

}).call(this);


},{}]},{},[1])
;