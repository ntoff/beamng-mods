angular.module('beamng.apps')

.directive('rockMadness', [function () {
    return {
        templateUrl: '/ui/modules/apps/rockMadness/app.html',
        replace: false,
        restrict: 'E',
        scope: false,
        controller: function ($scope, $element, $attrs) {
            $scope.amount = 30
            this.amount = $scope.amount
            this.spawn = function () {
                bngApi.engineLua(`extensions.rockMadness.spawnRocks( ${bngApi.serializeToLua(this.amount)} )`)
            }

            this.delete = function () {
                bngApi.engineLua(`extensions.rockMadness.removeRocks()`)
            }

            this.toggle = function () {
                bngApi.engineLua(`extensions.rockMadness.toggleRocks()`)
            }
        },
        controllerAs: 'ctrl'
    };
}])