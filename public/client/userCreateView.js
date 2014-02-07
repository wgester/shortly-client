Shortly.UserCreateView = Backbone.View.extend({
  el: 'body',

  // events: {
  //   "submit": "createNewUser"
  // },

  template: _.template('<h1> Create an Account </h1><form> Username: <input type="text" name="username"> Password: <input type="password" name="password"><input type="submit" value="submit"></form>'),

  initialize: function(){
    this.render();

    $(document).ready(function(){
      $('form').on('submit', function(e){
        e.preventDefault();
        var name = $("input[name='username']").val();
        var password = $("input[name='password'").val();
        $.post('http://localhost:4567/users?user_name=' + name + '&password=' + password, function(data){
          document.cookie="" +data + "";
          ////aseljfsaef
        });
      });
    });
  },

  render: function(){
    $('body').html(this.template);
  },

  createNewUser: function(e){
    e.preventDefault();
    var name = $("input[name='username']").val();
    var password = $("input[name='password'").val();
    user = new Shortly.User();
    user.on('sync',    this.success,      this );
    user.on('error',   this.failure,      this );
    user.save({},{url: '/users?user_name=' + name + '&password=' + password});
  },

  success: function(){
    console.log();
  },

  failure: function(){
    console.log('it failed lol');
  }
});