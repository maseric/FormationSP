// alert('--*** Bienvenue Neo ***--');

(function () {
    var overrideCurrentContext = {};
    overrideCurrentContext.Templates = {};
    overrideCurrentContext.OnPostRender = HighLightRow;
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(overrideCurrentContext);
}
)();



function HighLightRow(ctx) {
    // alert('appel fonction highlight');
    var statusColors = {
        'LOW': 'green',
        'MEDIUM': 'yellow',
        'HIGH': 'red'

    };

    var rows = ctx.ListData.Row;

    for (var i = 0; i < rows.length; i++) {
        var status = rows[i]["PRIORITY"];

        var rowId = GenerateIIDForListItem(ctx, rows[i]);

        var row = document.getElementById(rowId);
        row.style.backgroundColor = statusColors[status];
    }
}




