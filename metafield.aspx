<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EPiServer.Cms.UI.AspNetIdentity" %>
<%@ Import Namespace="Microsoft.AspNet.Identity" %>

<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.EntityFramework" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>

<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.DataAccess.Internal" %>

<%@ Import Namespace="Mediachase.Commerce.Customers" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Data" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Data.Meta.Management" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="AddMetaFieldCheckboxBoolean" Text="Add MetaField Checkbox Boolean" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void AddMetaFieldCheckboxBoolean(object sender, EventArgs e)
    {
        string name = "Attends";
        string friendlyName = name;
        var typeName = MetaFieldType.CheckboxBoolean;

        var orgMetaClass = DataContext.Current.MetaModel.MetaClasses[OrganizationEntity.ClassName];
        var metaClass = orgMetaClass;

        var existingField = metaClass.Fields[name];
        if (existingField == null)
        {   
            var attributes = new Mediachase.BusinessFoundation.Data.Meta.Management.AttributeCollection
            {
                { McDataTypeAttribute.BooleanLabel, friendlyName },
                { McDataTypeAttribute.EnumEditable, true }
            };
            metaClass.CreateMetaField(name, friendlyName, typeName, attributes);

            using (var myEditScope = DataContext.Current.MetaModel.BeginEdit())
            {
                metaClass.Fields[name].AccessLevel = AccessLevel.Development;
                metaClass.Fields[name].Owner = "Development";

                myEditScope.SaveChanges();
            }

            Log(String.Format("Meta field {0} is added to meta class {1}", name, OrganizationEntity.ClassName));
        }
        else
        {
            Log(String.Format("Meta field {0} is already exist in meta class {1}", name, OrganizationEntity.ClassName));
        }
        
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Metafield Testing </h3>");
%>
