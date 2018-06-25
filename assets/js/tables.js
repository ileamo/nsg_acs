import $ from "jquery"

require('datatables.net-bs')(window, $);

$("#datatable").DataTable();
$("#datatableJ").DataTable({
  "order": [
    [0, "desc"]
  ]
});

$('#wizard').smartWizard();

$('.buttonNext').addClass('btn btn-success');
$('.buttonPrevious').addClass('btn btn-primary');
$('.buttonFinish').addClass('btn btn-default');
