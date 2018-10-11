<xsl:stylesheet
  xmlns:x="http://www.w3.org/2001/XMLSchema"
  xmlns:d="http://schemas.microsoft.com/sharepoint/dsp"
  xmlns:cmswrt="http://schemas.microsoft.com/WebParts/v3/Publishing/runtime"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  version="1.0" exclude-result-prefixes="x d xsl msxsl cmswrt">

  <xsl:output method="html" indent="no"/>
  <xsl:template match="/">
    <xsl:variable name="Rows" select="/dsQueryResponse/Rows/Row"/>
    <xsl:variable name="dvt_RowCount" select="count($Rows)"/>
    <xsl:variable name="dvt_IsEmpty" select="$dvt_RowCount = 0"/>

    <xsl:choose>
      <xsl:when test="$dvt_IsEmpty">
        <xsl:call-template name="dvt_3.empty"/>
      </xsl:when>

      <xsl:otherwise>
        <style>
          #xltTable{ width:100%; border:0; font-family:"Segoe UI,Helvetica,Verdana" } #xltTable, #xltTable th, #xltTable td { border: 2px solid gray; border-collapse: collapse; } table#xltTable th { background-color: lightgray; color: black; text-align: center; } #xltTable tr:nth-child(odd) { background:rgba(255, 255, 255, 1); font-size:14px; } #xltTable tr:nth-child(even) { background:rgba(242, 242, 242, 1); font-size:14px; } #xltTable tr.colorGreen { background-color:rgba(169, 208, 142, 1)!important; font-weight:bold; font-size:15px!important; } #xltTable th, #xltTable td { padding: 8px 2px; text-align: center; } #xltTable td.nature > img { width:100px; height:100px; }
        </style>

        <table id="xltTable" border="0" width="100%" cellpadding="2" cellspacing="0">
          <tr>
            <th>Nom</th>
            <th>Valeur</th>
            <th>Avatar</th>
            <th>Equipe</th>
          </tr>
          <xsl:for-each select="$Rows">
            <xsl:sort select="@ID" order="descending" data-type="number"/>
            <xsl:if test="@ID > 0">
              <tr>
                <td>
                  <xsl:value-of select="@Title"/>
                </td>
                <td>
                  <xsl:value-of select="@VALEUR"/>
                </td>
                <td class="nature">
                  <img src="{@Avatar}"/>
                </td>
                <td>
                  <xsl:value-of select="@EQUIPE"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="dvt_3.empty">
    <xsl:variable name="dvt_ViewEmptyText">There are no items to show in this view.</xsl:variable>
    <table border="0" width="100%">
      <tr>
        <td class="ms-vb">
          <xsl:value-of select="$dvt_ViewEmptyText"/>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>