Shortly.Session = Backbone.Model.extend({
  defaults: {
    access_token: null,
    user_id: null
  },

  initialize: function(){
    this.load();
  },

  authenticated: function(){
    console.log(this.get('access_token'));
    return !!this.get('access_token');
  },

  save: function(auth_hash){
    $.cookie('user_id', auth_hash.id);
    $.cookie('access_token', auth_hash.access_token);
  },

  load: function(){
    this.set({user_id: $.cookie('user_id'),
         access_token: $.cookie('rack.session')});
  }
});
