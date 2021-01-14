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
<%@ Import Namespace="Mediachase.Commerce.Catalog.ImportExport" %>



<form id="form1" runat="server" enctype="multipart/form-data">
    <input type="file" id="myFile" name="myFile" />
    <asp:Button runat="server" ID="btnUpload" OnClick="btnImportClick" Text="Import" />
</form>

<script language="C#" type="text/C#" runat="server">
    void btnImportClick(object sender, EventArgs e)
    {
        HttpPostedFile file = Request.Files["myFile"];

        //check file was submitted
        if (file != null && file.ContentLength > 0)
        {
            Log(file.FileName + " was submitted");
            string fname = Path.GetFileName(file.FileName);
            var path = Server.MapPath(Path.Combine("~/App_Data/", fname));
            file.SaveAs(path);
            Log(file.FileName + " was saved in: " + path);

            try{
                DoImport(path);
            }
            catch (Exception ex){
                // if (ex is AggregateException){
                //     foreach (var errInner in (ex as AggregateException).InnerExceptions){
                //         Log("Error: " + errInner.Message);
                //         Log(errInner.StackTrace);
                //     }
                // }else{
                //     Log("Error: " + ex.Message);
                //     Log(ex.StackTrace);
                // }
                Log(ex.ToString());
            }
        }
    }
    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
    void DoImport(string sourceFile)
    {
        var sourceXmlInZip = "Catalog.xml";

        var sourceDirectory = DoExtractArchive(sourceFile, sourceXmlInZip);
        var catalogImportExport = new CatalogImportExport()
        {
            IsModelsAvailable = true
        };
        catalogImportExport.ImportExportProgressMessage += (s, e) =>
        {
            var progress = Math.Round(e.CompletedPercentage);
            Log(progress.ToString() + "%: " + e.Message);

            // test the exception
            // if (progress == 100){
            //     TestAggregateException();
            // }
        };

        catalogImportExport.Import(sourceDirectory, true);
    }
    void TestAggregateException()
    {
        var exceptions = new List<Exception>();
        for (int i =0; i<2; i++){
            try{
                var x = 0;
                var y = 10/x;
            }catch (Exception ex) {
                exceptions.Add(ex);
            }
        }
        if (exceptions.Count > 0)
            throw new AggregateException(exceptions);
    }
    string DoExtractArchive(string sourceFile, string sourceXmlInZip)
    {
        var tempDirectory = CreateTempDirectory();

        var fileInfo = new FileInfo(sourceFile);
        long target = fileInfo.Length;
        long processed = 0;

        Log("Preparing to unpack zip file.");
        int lastProgressAtMessagePost = 0;
        int megabyte = 1024 * 1024;

        using (System.IO.Compression.ZipArchive zipFile = ZipFile.OpenRead(sourceFile))
        {
            foreach (var entry in zipFile.Entries)
            {
                if (processed - lastProgressAtMessagePost >= megabyte || processed == target)
                {
                    Log("Extracting zip archive ({" + processed + "}/{" + target + "} bytes)...");
                    lastProgressAtMessagePost = (int)processed;
                }

                entry.ExtractToFile(Path.Combine(tempDirectory, entry.Name), true);
                processed += entry.CompressedLength;
            }

        }
        Log("Unpacked zip file in: " + tempDirectory);

        // sourceFile = Path.Combine(tempDirectory, sourceXmlInZip);
        return tempDirectory;
    }
    string CreateTempDirectory()
    {
        var tries = 3;

        string tempDirectory;
        do{
            try{
                tempDirectory = Path.GetTempFileName();
                File.Delete(tempDirectory);
                Directory.CreateDirectory(tempDirectory);
            }
            catch{
                tempDirectory = null;
                if (--tries <= 0) throw;
            }
        }
        while (tempDirectory == null);

        return tempDirectory;
    }
</script>

<%
    Response.Write("<h3> Upload catalog.zip and click import </h3>");
%>
