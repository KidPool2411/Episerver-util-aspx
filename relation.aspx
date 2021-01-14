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
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>

<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.Linking" %>



<form id="form1" runat="server" enctype="multipart/form-data">

    <asp:Button runat="server" ID="btnUpload" OnClick="btnRemoveClick" Text="Remove" />
</form>

<script language="C#" type="text/C#" runat="server">
    void btnRemoveClick(object sender, EventArgs e)
    {
        int parentId = 1073741836;
        int childId = 418;

        var _relationRepository = ServiceLocator.Current.GetInstance<IRelationRepository>();
        var parentLink = new ContentReference(parentId, 0, ReferenceConverter.CatalogProviderKey);
        var currentRelations = _relationRepository.GetChildren<Relation>(parentLink).ToList();

        var relation = currentRelations.FirstOrDefault(r => r.Child.ID == childId);
        if (relation == null)
        {
           Log("ERROR: Relation not found");
        }
        else
        {
            _relationRepository.RemoveRelation(relation);
            Log("INFO: Remove relation successfully");
        }
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }

</script>

<%
    Response.Write("<h3> Relation Testing </h3>");
%>
