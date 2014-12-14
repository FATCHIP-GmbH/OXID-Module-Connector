'use strict';

/* Services module */

angular.module('main.services', [])

/**
 * A simple angular value
 * @type string
 */
.value('version', '0.0.1')

/**
 * Service factory for calling our simple PHP interface
 * @param $http
 * @returns asynchronous "promise" functions
 */
.factory('IolyService', ['$http', function($http) {
  function postFormData(fnc, data){
    return $http({
        method: 'POST',
        url: gOxidSelfLink,
        data: $.param({cl: 'ioly_main', fnc: fnc, data: angular.toJson(data)}),
        headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
    });
  }
  return {
    getAllModules: function(searchText, page, pageSize, orderBy, orderDir){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'getAllModulesAjax',page: page, pageSize: pageSize, orderBy: orderBy, orderDir: orderDir, searchstring: searchText}});
    },
    downloadModule: function(moduleid, moduleversion){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'downloadModuleAjax',moduleid: moduleid, moduleversion: moduleversion}});
    },
    removeModule: function(moduleid, moduleversion){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'removeModuleAjax',moduleid: moduleid, moduleversion: moduleversion}});
    },
    updateIoly: function(){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'updateIolyAjax'}});
    },
    updateRecipes: function(){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'updateRecipesAjax'}});
    },
    updateConnector: function(){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'downloadModuleAjax',moduleid: moduleid, moduleversion: moduleversion}});
    },
    getContributors: function(){
        return $http.get('https://api.github.com/repos/ioly/ioly/contributors');
    },
    getModuleHooks: function(moduleid, moduleversion){
        return $http.get(gOxidSelfLink, {params: {cl:'ioly_main', isajax:true, fnc:'getModuleHooksAjax',moduleid: moduleid, moduleversion: moduleversion}});
    },
    saveFooBar: function(mapping){
        return postFormData('savefoobar', mapping);
    }
  };
}])

;
