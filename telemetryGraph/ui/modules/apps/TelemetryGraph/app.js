angular.module('beamng.apps')
.directive('telemetryGraph', function () {
  return {
    restrict: 'E',
    template: `
      <div>
        <canvas width="400" height="160"></canvas>
        <div class="md-caption" style="padding: 2px; color: silver; position: absolute; top: 0; left: 0; width: auto; height: auto; background-color: rgba(50, 50, 50, 0.9)" layout="column">
          <span style="color: #FFFFFF; margin:0px">Steering: {{ steering_input }}%</span>
          <span style="color: #b5f987; margin:0px">Throttle: {{ throttle }}%</span>
          <span style="color: #ff6f6f; margin:0px">Brake: {{ brake }}%</span>
          <span style="color: #87c8f9; margin:0px">Clutch: {{ clutch }}%</span>
        </div>
      </div>`,
    replace: true,
    link: function (scope, element, attrs) {
      var streamsList = ['sensors', 'electrics']
      StreamsManager.add(streamsList)
      scope.$on('$destroy', function () {
        StreamsManager.remove(streamsList)
      })

      var canvas = element[0].children[0]
      var chart = new SmoothieChart({
          minValue: -1.0,
          maxValue: 1.0,
          millisPerPixel: 20,
          interpolation: 'linear',
          grid: { fillStyle: 'rgba(0,0,0,0.43)', strokeStyle: 'black', verticalSections: 4, millisPerLine: 1000, sharpLines: true }
        })
        , brakeGraph     =new TimeSeries()
        , clutchGraph    =new TimeSeries()
        , throttleGraph  = new TimeSeries()
        , steerGraph     = new TimeSeries()
        , steerLine      = { strokeStyle: '#FFFFFF', lineWidth: 2 }
        , clutchLine     = { strokeStyle: '#87c8f9', lineWidth: 2 }
        , brakeLine      = { strokeStyle: '#ff6f6f', lineWidth: 2 }
        , throttleLine   = { strokeStyle: '#b5f987', lineWidth: 2 }

      let pausedTime = 0
      chart.addTimeSeries(steerGraph,     steerLine)
      chart.addTimeSeries(clutchGraph,    clutchLine)
      chart.addTimeSeries(brakeGraph,     brakeLine)
      chart.addTimeSeries(throttleGraph,  throttleLine)
      chart.streamTo(canvas, 40+pausedTime)

      let lastPaused = undefined
      //scale function found here: https://stackoverflow.com/questions/10756313/javascript-jquery-map-a-range-of-numbers-to-another-range-of-numbers
      function scale (number, inMin, inMax, outMin, outMax) {
        return (number - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
      }
      scope.$on('streamsUpdate', function (event, streams) {
        if (!streams.electrics) { return }

        let now = new Date().getTime()
        if (scope.$parent.$parent.app.showPauseIcon) {
          if (lastPaused === undefined) {
            lastPaused = now
            chart.stop()
          }
          return
        }
        if (lastPaused !== undefined) {
          pausedTime += now - lastPaused
          lastPaused = undefined
          chart.streamTo(canvas, 40+pausedTime)
          chart.start()
        }

        let dataTime = now - pausedTime
        //graphs
        steerGraph.append(dataTime, streams.electrics.steering_input);
        throttleGraph.append(dataTime, scale(streams.electrics.throttle,0,1,-1,1));
        brakeGraph.append(dataTime, scale(streams.electrics.brake,0,1,-1,1));
        clutchGraph.append(dataTime, scale(streams.electrics.clutch,0,1,-1,1));
        //text values
        scope.steering_input = (streams.electrics.steering_input*100).toFixed(1)
        scope.throttle = (streams.electrics.throttle*100).toFixed(1)
        scope.brake = (streams.electrics.brake*100).toFixed(1)
        scope.clutch = (streams.electrics.clutch*100).toFixed(1)
      })

      scope.$on('app:resized', function (event, data) {
        canvas.width = data.width
        canvas.height = data.height
      })
    }
  }
})
