<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:pattern id="required-fields">
    <sch:rule context="doc">
      <sch:assert test="field[@name = 'url']">Für jeden Datensatz ist eine URL hinterlegt</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:rule context="doc">
      <sch:report id="publication-date-in-future" test="xs:int(field[@name = 'publicationYear']) gt xs:int(format-date(current-date(), '[Y0001]')) + 2">Das Datum der Veröffentlichung liegt weit in der Zukunft</sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema>
