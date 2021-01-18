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
<%@ Import Namespace="Mediachase.Commerce.Catalog.Managers" %>

<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.DataAccess.Internal" %>

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="ListContentOfContentTypeName" Text="List Content Of Content Type name" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void ListContentOfContentTypeName(object sender, EventArgs e)
    {
        string nameOfType = "FreeTextBlock";

        var contentTypeRepository = ServiceLocator.Current.GetInstance<IContentTypeRepository>();
        var contentModelUsage = ServiceLocator.Current.GetInstance<IContentModelUsage>();
        var _contentListDBAccessor = ServiceLocator.Current.GetInstance<ServiceAccessor<ContentListDB>>();

        var pageType = contentTypeRepository.Load(nameOfType);

        if (pageType == null)
        {
            Log("Type not found");
            return;
        }
        var contentUsages = _contentListDBAccessor().ListContentOfContentType(pageType,false); // get crash here
        foreach(var content in contentUsages)
        {
            Log(content.Name);
        }
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Content Testing </h3>");
%>
