//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require excanvas
//= require_self
//= require jquery.flot
//= require jquery.flot.navigate
//= require jquery.flot.threshold

$(document).ready(function() {
  $('#locale_selector').change(function() {
    document.location = $(this).val();
  });
});

var application ={
  options:  { legend:{show:false, position:'se',backgroundColor:'transparent'},xaxis: { mode: "time", timeformat:"%0d.%0m" }, grid:{ hoverable: true, clickable: true } },

  mapThresholds: function(thresholds, data) {
    var _data = [];
    var last_data = data.data[data.data.length - 1];
    for (var i=0;i<thresholds.length;i++){
      if (data.data[0] && (thresholds[i][0] < data.data[0][0])) {
        thresholds[i][0] = data.data[0][0];
      }
    }
    for (var i=0;i<thresholds.length;i++){
      if (thresholds[i+1]) {
        _data.push(thresholds[i], [thresholds[i+1][0], thresholds[i][1]]);
      } else if ((last_data) && (last_data[0] > thresholds[i][0])) {
        _data.push(thresholds[i], [last_data[0], thresholds[i][1]]);
      } else {
        _data.push(thresholds[i]);
      }
    }
    return _data;
  },
  plotGlucose: function(data, patient_id) {
    $.getJSON('/patients/' + patient_id + '/measurement_thresholds/glucose_thresholds.json', function(thresholds) {
      var thresholds_values = { high: [], low: []};
      $.each(thresholds, function(index, threshold) {
        var time = threshold.glucose_threshold.created_at;
        thresholds_values.high.push([ time, parseFloat(threshold.glucose_threshold.value.high) ]);
        thresholds_values.low.push([ time, parseFloat(threshold.glucose_threshold.value.low) ]);
      });
      var graph = [];
      graph.push({color:7 , shadowSize:0, label: "highThresholds" , data:application.mapThresholds(thresholds_values.high, data), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "lowThresholds" , data:application.mapThresholds(thresholds_values.low, data), lines: {show: true}, points:{show: true} });
      graph.push(data);
      $.plot($("#glucoses_graph"), graph, application.options);
      $("form.new_glucose_threshold").unbind("ajax:complete");
      $("form.new_glucose_threshold").bind("ajax:complete", { data : data, patient_id : patient_id }, function(event) {
        application.plotGlucose(event.data.data, event.data.patient_id)
      });
    });
  },
  plotTemperature: function(data, patient_id){
    $.getJSON('/patients/' + patient_id + '/measurement_thresholds/temperature_thresholds.json', function(thresholds) {
      var thresholds_values = { high: [], low: []};
      $.each(thresholds, function(index, threshold) {
        var time = threshold.temperature_threshold.created_at;
        thresholds_values.high.push([ time, parseFloat(threshold.temperature_threshold.value.high) ]);
        thresholds_values.low.push([ time, parseFloat(threshold.temperature_threshold.value.low) ]);
      });
      var graph = [];
      graph.push({color:7 , shadowSize:0, label: "highThresholds" , data:application.mapThresholds(thresholds_values.high, data), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "lowThresholds" , data:application.mapThresholds(thresholds_values.low, data), lines: {show: true}, points:{show: true} });
      graph.push(data);
      $.plot($("#temperatures_graph"), graph, application.options);
      $("form.new_temperature_threshold").unbind("ajax:complete");
      $("form.new_temperature_threshold").bind("ajax:complete", { data : data, patient_id : patient_id }, function(event) {
        application.plotTemperature(event.data.data, event.data.patient_id)
      });
    });
  },
  plotBloodpressure: function(data, patient_id){
    $.getJSON('/patients/' + patient_id + '/measurement_thresholds/bloodpressure_thresholds.json', function(thresholds) {
      var thresholds_values = { high_sys: [], low_sys: [], high_dia: [], low_dia: [], high_pulse: [], low_pulse: []};
      $.each(thresholds, function(index, threshold) {
        var time = threshold.bloodpressure_threshold.created_at;
        thresholds_values.high_sys.push([ time, parseInt(threshold.bloodpressure_threshold.value.high_sys) ]);
        thresholds_values.low_sys.push([ time, parseInt(threshold.bloodpressure_threshold.value.low_sys) ]);
        thresholds_values.high_dia.push([ time, parseInt(threshold.bloodpressure_threshold.value.high_dia) ]);
        thresholds_values.low_dia.push([ time, parseInt(threshold.bloodpressure_threshold.value.low_dia) ]);
        thresholds_values.high_pulse.push([ time, parseInt(threshold.bloodpressure_threshold.value.high_pulse) ]);
        thresholds_values.low_pulse.push([ time, parseInt(threshold.bloodpressure_threshold.value.low_pulse) ]);
      });
      var graph = [];
      graph.push({color:7 , shadowSize:0, label: "highSysThresholds" , data:application.mapThresholds(thresholds_values.high_sys, data[0]), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "lowSysThresholds" , data:application.mapThresholds(thresholds_values.low_sys, data[0]), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "highDiaThresholds" , data:application.mapThresholds(thresholds_values.high_dia, data[1]), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "lowDiaThresholds" , data:application.mapThresholds(thresholds_values.low_dia, data[1]), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "highPulseThresholds" , data:application.mapThresholds(thresholds_values.high_pulse, data[2]), lines: {show: true}, points:{show: true} });
      graph.push({color:7 , shadowSize:0, label: "lowPulseThresholds" , data:application.mapThresholds(thresholds_values.low_pulse, data[2]), lines: {show: true}, points:{show: true} });
      graph.push(data[0]);
      graph.push(data[1]);
      graph.push(data[2]);
      $.plot($("#bloodpressures_graph"), graph, application.options);
      $("form.new_bloodpressure_threshold").unbind("ajax:complete");
      $("form.new_bloodpressure_threshold").bind("ajax:complete", { data : data, patient_id : patient_id }, function(event) {
        application.plotBloodpressure(event.data.data, event.data.patient_id)
      });
    });
  },
  poolNotifications: function (from_date, patient){
    $req = $.getJSON('/notifications/from_date.json',{ date: from_date, patient_id: patient }, function(data) {
      if( data.items.length > 0 ) { return location.reload(); }
      from_date = data.date
      setTimeout(function(){ application.poolNotifications(from_date, patient) }, 60000);
    });
  }
}

