<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<html:html>
<body>
  <h3>Struts Tiles Example</h3>
  <ul>
  <li>
  <html:link page="/page-by-insert-tag.jsp">
    Defining a Page with tiles:insert tag.
  </html:link>
  </li>
  <li>
  <html:link page="/page-by-definition-tag.jsp">
    Defining A Page with tiles:definition tag.
  </html:link>
  </li>
  <li>
  <html:link page="/page-by-tiles-definition.jsp">
    Defining A Page with tiles-defs.xml
  </html:link>
  </li>
</body>
</html:html>