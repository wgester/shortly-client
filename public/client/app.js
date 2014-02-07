var Shortly = angular.module('Shortly', ['ngRoute']);

Shortly.config(function($routeProvider) {
	
	$routeProvider.when('/', {
		controller: 'linksController',
		templateUrl: 'template/index.html'
	})
	.when('/shorten', {
		controller: '',
		templateUrl: ''
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

Shortly.controller('linksController', function($scope) {
	$scope.name = 'Joseph!'
});