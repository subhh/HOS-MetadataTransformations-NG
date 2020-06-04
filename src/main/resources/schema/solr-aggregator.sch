<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern id="required-fields">
    <sch:rule context="doc">
      <sch:assert test="field[@name = 'url']">Für jeden Datensatz ist eine URL hinterlegt</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
