<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>

<%
    var mu = Membership.GetUser("EpiSQLAdmin");

    if (mu != null) return;

    try
    {
        Membership.CreateUser("EpiSQLAdmin", "P@ssw0rd", "EpiSQLAdmin@site.com");

        try
        {

            Roles.AddUserToRoles("EpiSQLAdmin", 
                new[] {"Administrators", "WebAdmins", "WebEditors" });
            Response.Write("created successfully");
        }
        catch (ProviderException pe)
        {
            Response.Write(pe);
        }
    }
    catch (MembershipCreateUserException mcue)
    {
        Response.Write(mcue);
    }
%>