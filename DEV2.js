//Initialize Namespace|Object
var DMRendering = DMRendering || {};

//Custom function
DMRendering.CustomizeFieldRendering = function () {
	//alert('ici');
    var customRenderingOverride = {};
    customRenderingOverride.Templates = {};

    customRenderingOverride.Templates.Fields =
        { 'PRIORITY': { 'View': DMRendering.RenderColorField } };

    //Override Template
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(customRenderingOverride)
};



//on remplace la valeur initialize par du html
DMRendering.RenderColorField = function (context) {
    var PriorityField = context.CurrentItem.PRIORITY;
    var color = '';

    switch (PriorityField) {
        case 'HIGH':
            color = 'red';
            break;
        case 'LOW':
            color = 'green';
            break;
        case 'MEDIUM':
            color = 'yellow';
            break;
        default:
            color = 'white';
            break;

    }
    return "<div style='float: left; width: 20px; height: 20px; margin: 5px; border: 1px solid rgba(0,0,0,.2); background:"+color+"'/>";
};

DMRendering.CustomizeFieldRendering();

