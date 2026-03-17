<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OracleClient" %>
<%
    try {
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
        using (var conn = new OracleConnection(connStr)) {
            conn.Open();
            using (var cmd = new OracleCommand("SELECT TABLE_NAME || '.' || COLUMN_NAME || ' (' || DATA_TYPE || ')' FROM USER_TAB_COLUMNS", conn)) {
                var r = cmd.ExecuteReader();
                while(r.Read()) {
                    Response.Write(r[0].ToString() + "<br/>\n");
                }
            }
        }
#pragma warning restore 618
    } catch(Exception ex) {
        Response.Write("ERROR: " + ex.Message);
    }
%>
