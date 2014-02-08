var Shortly = angular.module('Shortly', ['ngRoute']);

Shortly.config(function($routeProvider) {
	
	$routeProvider.when('/', {
		controller: 'linksController',
		templateUrl: 'template/index.html'
	})
	.when('/shorten', {
		controller: 'shortenController',
		templateUrl: 'template/shorten.html'
	})
	.when('login', {
		controller: '',
		templateUrl: ''
	})
	.when('register', {
		controller: '',
		templateUrl: ''
	})
	.otherwise({
		redirectTo: '/' 
	});

});

Shortly.controller('linksController', function($scope, $http) {
	$scope.name = 'WIll',
	$http({
    method: 'GET',
    url: '/links' 
	}).success(function(data){
    $scope.links = data;
	}).error(function(data){
		console.log(data);
	});
});

Shortly.controller('shortenController', function($scope, $http){
  $scope.url = {url:null};
  $scope.post = function(){
  	$http({
  		method: 'POST',
  		url: '/links',
  		data: JSON.stringify($scope.url)
  	})
  	.then(function(data){
  		console.log(data);
  	})
  	.catch(function(data){
      console.log('err', data);
  	});
  }
});