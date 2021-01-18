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


<%
    string username = "sysadmin6";
    string password = "p@ssword";
    string email = "sysadmin@mysite.com";
    string[] roles = { "Administrators" };
    string connectionString = "EPiServerDB";

    Response.Write("<h3> User name: " + username + "</h3>");
    Response.Write("<h3> Password: " + password + "</h3>");
    Response.Write("<h3> Email: " + email + "</h3><strike><div>****************************</div></strike>");


    Response.Write("<h3> Using connection string: " + connectionString + "</h3>");
    Response.Write("<h3> Start creating user: " + username + "</h3>");

    using (UserStore<ApplicationUser> store = new UserStore<ApplicationUser>(new ApplicationDbContext<ApplicationUser>(connectionString)))
    {
        //If there's already a user, then we don't need a seed
        if (!store.Users.Any(x => x.UserName == username))
        {
            // CreateUser(UserStore<ApplicationUser> store, string username, string password, string email)
            IPasswordHasher hasher = new PasswordHasher();
            string passwordHash = hasher.HashPassword(password);
        
            ApplicationUser applicationUser = new ApplicationUser
            {
                Email = email,
                EmailConfirmed = true,
                LockoutEnabled = true,
                IsApproved = true,
                UserName = username,
                PasswordHash = passwordHash,
                SecurityStamp = Guid.NewGuid().ToString()
            };
        
            store.CreateAsync(applicationUser).GetAwaiter().GetResult();
            ApplicationUser createdUser = store.FindByNameAsync(username).GetAwaiter().GetResult();
        
            // AddUserToRoles(UserStore<ApplicationUser> store, ApplicationUser user, string[] roles)
            IUserRoleStore<ApplicationUser, string> userRoleStore = store;
            using (var roleStore = new RoleStore<IdentityRole>(new ApplicationDbContext<ApplicationUser>(connectionString)))
            {
                IList<string> userRoles = userRoleStore.GetRolesAsync(createdUser).GetAwaiter().GetResult();
                foreach (string roleName in roles)
                {
                    if (roleStore.FindByNameAsync(roleName).GetAwaiter().GetResult() == null)
                    {
                        roleStore.CreateAsync(new IdentityRole { Name = roleName }).GetAwaiter().GetResult();
                    }
                    if (!userRoles.Contains(roleName))
                        userRoleStore.AddToRoleAsync(createdUser, roleName).GetAwaiter().GetResult();
                }
            }
            store.UpdateAsync(createdUser).GetAwaiter().GetResult();

            Response.Write("<h3> Created successfully user: " + username + "</h3>");
        }
        else
        {
            Response.Write("<h3> Failed to create as the user " + username + " already exist </h3>");

        }
    }
%>
