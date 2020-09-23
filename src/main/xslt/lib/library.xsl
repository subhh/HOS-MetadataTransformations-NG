<!DOCTYPE xsl:transform [<!ENTITY datatypeUri "https://openscience.hamburg.de/vocab/datatype#">]>
<xsl:transform version="3.0" expand-text="yes"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:library="tag:david.maus@sub.uni-hamburg.de,2020:Transform:Library"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="library:identifier" as="element(dc:identifier)?">
    <xsl:param name="type"  as="xs:string" required="yes"/>
    <xsl:param name="value" as="xs:string" required="yes"/>

    <xsl:choose>
      <xsl:when test="$type = 'ORCID'">
        <dc:identifier rdf:datatype="&datatypeUri;ORCID">
          <xsl:value-of select="substring(normalize-space($value), string-length($value) - 18)"/>
        </dc:identifier>
      </xsl:when>

      <xsl:when test="$type = ('DOI', 'URN')">
        <dc:identifier rdf:datatype="&datatypeUri;{$type}">
          <xsl:value-of select="normalize-space($value)"/>
        </dc:identifier>
      </xsl:when>
      <xsl:when test="$type = ('PURL', 'URL')">
        <xsl:choose>
          <xsl:when test="matches($value, '^https?://(dx\.|)doi.org/10')">
            <xsl:call-template name="library:identifier">
              <xsl:with-param name="type"  as="xs:string">DOI</xsl:with-param>
              <xsl:with-param name="value" as="xs:string" select="substring-after($value, 'doi.org/')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
              <xsl:value-of select="normalize-space($value)"/>
            </dc:identifier>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
          <xsl:value-of select="normalize-space($value)"/>
        </dc:identifier>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:function name="library:normalize-language" as="xs:string">
    <xsl:param name="language" as="xs:string?"/>

    <xsl:variable name="translate" as="element(translate)+">

      <!-- Special -->
      <translate source="mul" target="multi"/>

      <!-- ISO 639-1 -->
      <translate source="aa" target="aa"/>
      <translate source="ab" target="ab"/>
      <translate source="af" target="af"/>
      <translate source="ak" target="ak"/>
      <translate source="sq" target="sq"/>
      <translate source="am" target="am"/>
      <translate source="ar" target="ar"/>
      <translate source="an" target="an"/>
      <translate source="hy" target="hy"/>
      <translate source="as" target="as"/>
      <translate source="av" target="av"/>
      <translate source="ae" target="ae"/>
      <translate source="ay" target="ay"/>
      <translate source="az" target="az"/>
      <translate source="ba" target="ba"/>
      <translate source="bm" target="bm"/>
      <translate source="eu" target="eu"/>
      <translate source="be" target="be"/>
      <translate source="bn" target="bn"/>
      <translate source="bh" target="bh"/>
      <translate source="bi" target="bi"/>
      <translate source="bo" target="bo"/>
      <translate source="bs" target="bs"/>
      <translate source="br" target="br"/>
      <translate source="bg" target="bg"/>
      <translate source="my" target="my"/>
      <translate source="ca" target="ca"/>
      <translate source="cs" target="cs"/>
      <translate source="ch" target="ch"/>
      <translate source="ce" target="ce"/>
      <translate source="zh" target="zh"/>
      <translate source="cu" target="cu"/>
      <translate source="cv" target="cv"/>
      <translate source="kw" target="kw"/>
      <translate source="co" target="co"/>
      <translate source="cr" target="cr"/>
      <translate source="cy" target="cy"/>
      <translate source="cs" target="cs"/>
      <translate source="da" target="da"/>
      <translate source="de" target="de"/>
      <translate source="dv" target="dv"/>
      <translate source="nl" target="nl"/>
      <translate source="dz" target="dz"/>
      <translate source="el" target="el"/>
      <translate source="en" target="en"/>
      <translate source="eo" target="eo"/>
      <translate source="et" target="et"/>
      <translate source="eu" target="eu"/>
      <translate source="ee" target="ee"/>
      <translate source="fo" target="fo"/>
      <translate source="fa" target="fa"/>
      <translate source="fj" target="fj"/>
      <translate source="fi" target="fi"/>
      <translate source="fr" target="fr"/>
      <translate source="fr" target="fr"/>
      <translate source="fy" target="fy"/>
      <translate source="ff" target="ff"/>
      <translate source="ka" target="ka"/>
      <translate source="de" target="de"/>
      <translate source="gd" target="gd"/>
      <translate source="ga" target="ga"/>
      <translate source="gl" target="gl"/>
      <translate source="gv" target="gv"/>
      <translate source="el" target="el"/>
      <translate source="gn" target="gn"/>
      <translate source="gu" target="gu"/>
      <translate source="ht" target="ht"/>
      <translate source="ha" target="ha"/>
      <translate source="he" target="he"/>
      <translate source="hz" target="hz"/>
      <translate source="hi" target="hi"/>
      <translate source="ho" target="ho"/>
      <translate source="hr" target="hr"/>
      <translate source="hu" target="hu"/>
      <translate source="hy" target="hy"/>
      <translate source="ig" target="ig"/>
      <translate source="is" target="is"/>
      <translate source="io" target="io"/>
      <translate source="ii" target="ii"/>
      <translate source="iu" target="iu"/>
      <translate source="ie" target="ie"/>
      <translate source="ia" target="ia"/>
      <translate source="id" target="id"/>
      <translate source="ik" target="ik"/>
      <translate source="is" target="is"/>
      <translate source="it" target="it"/>
      <translate source="jv" target="jv"/>
      <translate source="ja" target="ja"/>
      <translate source="kl" target="kl"/>
      <translate source="kn" target="kn"/>
      <translate source="ks" target="ks"/>
      <translate source="ka" target="ka"/>
      <translate source="kr" target="kr"/>
      <translate source="kk" target="kk"/>
      <translate source="km" target="km"/>
      <translate source="ki" target="ki"/>
      <translate source="rw" target="rw"/>
      <translate source="ky" target="ky"/>
      <translate source="kv" target="kv"/>
      <translate source="kg" target="kg"/>
      <translate source="ko" target="ko"/>
      <translate source="kj" target="kj"/>
      <translate source="ku" target="ku"/>
      <translate source="lo" target="lo"/>
      <translate source="la" target="la"/>
      <translate source="lv" target="lv"/>
      <translate source="li" target="li"/>
      <translate source="ln" target="ln"/>
      <translate source="lt" target="lt"/>
      <translate source="lb" target="lb"/>
      <translate source="lu" target="lu"/>
      <translate source="lg" target="lg"/>
      <translate source="mk" target="mk"/>
      <translate source="mh" target="mh"/>
      <translate source="ml" target="ml"/>
      <translate source="mi" target="mi"/>
      <translate source="mr" target="mr"/>
      <translate source="ms" target="ms"/>
      <translate source="mk" target="mk"/>
      <translate source="mg" target="mg"/>
      <translate source="mt" target="mt"/>
      <translate source="mn" target="mn"/>
      <translate source="mi" target="mi"/>
      <translate source="ms" target="ms"/>
      <translate source="my" target="my"/>
      <translate source="na" target="na"/>
      <translate source="nv" target="nv"/>
      <translate source="nr" target="nr"/>
      <translate source="nd" target="nd"/>
      <translate source="ng" target="ng"/>
      <translate source="ne" target="ne"/>
      <translate source="nl" target="nl"/>
      <translate source="nn" target="nn"/>
      <translate source="nb" target="nb"/>
      <translate source="no" target="no"/>
      <translate source="ny" target="ny"/>
      <translate source="oc" target="oc"/>
      <translate source="oj" target="oj"/>
      <translate source="or" target="or"/>
      <translate source="om" target="om"/>
      <translate source="os" target="os"/>
      <translate source="pa" target="pa"/>
      <translate source="fa" target="fa"/>
      <translate source="pi" target="pi"/>
      <translate source="pl" target="pl"/>
      <translate source="pt" target="pt"/>
      <translate source="ps" target="ps"/>
      <translate source="qu" target="qu"/>
      <translate source="rm" target="rm"/>
      <translate source="ro" target="ro"/>
      <translate source="ro" target="ro"/>
      <translate source="rn" target="rn"/>
      <translate source="ru" target="ru"/>
      <translate source="sg" target="sg"/>
      <translate source="sa" target="sa"/>
      <translate source="si" target="si"/>
      <translate source="sk" target="sk"/>
      <translate source="sk" target="sk"/>
      <translate source="sl" target="sl"/>
      <translate source="se" target="se"/>
      <translate source="sm" target="sm"/>
      <translate source="sn" target="sn"/>
      <translate source="sd" target="sd"/>
      <translate source="so" target="so"/>
      <translate source="st" target="st"/>
      <translate source="es" target="es"/>
      <translate source="sq" target="sq"/>
      <translate source="sc" target="sc"/>
      <translate source="sr" target="sr"/>
      <translate source="ss" target="ss"/>
      <translate source="su" target="su"/>
      <translate source="sw" target="sw"/>
      <translate source="sv" target="sv"/>
      <translate source="ty" target="ty"/>
      <translate source="ta" target="ta"/>
      <translate source="tt" target="tt"/>
      <translate source="te" target="te"/>
      <translate source="tg" target="tg"/>
      <translate source="tl" target="tl"/>
      <translate source="th" target="th"/>
      <translate source="bo" target="bo"/>
      <translate source="ti" target="ti"/>
      <translate source="to" target="to"/>
      <translate source="tn" target="tn"/>
      <translate source="ts" target="ts"/>
      <translate source="tk" target="tk"/>
      <translate source="tr" target="tr"/>
      <translate source="tw" target="tw"/>
      <translate source="ug" target="ug"/>
      <translate source="uk" target="uk"/>
      <translate source="ur" target="ur"/>
      <translate source="uz" target="uz"/>
      <translate source="ve" target="ve"/>
      <translate source="vi" target="vi"/>
      <translate source="vo" target="vo"/>
      <translate source="cy" target="cy"/>
      <translate source="wa" target="wa"/>
      <translate source="wo" target="wo"/>
      <translate source="xh" target="xh"/>
      <translate source="yi" target="yi"/>
      <translate source="yo" target="yo"/>
      <translate source="za" target="za"/>
      <translate source="zh" target="zh"/>
      <translate source="zu" target="zu"/>

      <!-- ISO-693-2 -->
      <translate source="aar" target="aa"/>
      <translate source="abk" target="ab"/>
      <translate source="afr" target="af"/>
      <translate source="aka" target="ak"/>
      <translate source="alb" target="sq"/>
      <translate source="amh" target="am"/>
      <translate source="ara" target="ar"/>
      <translate source="arg" target="an"/>
      <translate source="arm" target="hy"/>
      <translate source="asm" target="as"/>
      <translate source="ava" target="av"/>
      <translate source="ave" target="ae"/>
      <translate source="aym" target="ay"/>
      <translate source="aze" target="az"/>
      <translate source="bak" target="ba"/>
      <translate source="bam" target="bm"/>
      <translate source="baq" target="eu"/>
      <translate source="bel" target="be"/>
      <translate source="ben" target="bn"/>
      <translate source="bih" target="bh"/>
      <translate source="bis" target="bi"/>
      <translate source="tib" target="bo"/>
      <translate source="bos" target="bs"/>
      <translate source="bre" target="br"/>
      <translate source="bul" target="bg"/>
      <translate source="bur" target="my"/>
      <translate source="cat" target="ca"/>
      <translate source="cze" target="cs"/>
      <translate source="cha" target="ch"/>
      <translate source="che" target="ce"/>
      <translate source="chi" target="zh"/>
      <translate source="chu" target="cu"/>
      <translate source="chv" target="cv"/>
      <translate source="cor" target="kw"/>
      <translate source="cos" target="co"/>
      <translate source="cre" target="cr"/>
      <translate source="wel" target="cy"/>
      <translate source="cze" target="cs"/>
      <translate source="dan" target="da"/>
      <translate source="ger" target="de"/>
      <translate source="div" target="dv"/>
      <translate source="dut" target="nl"/>
      <translate source="dzo" target="dz"/>
      <translate source="gre" target="el"/>
      <translate source="eng" target="en"/>
      <translate source="epo" target="eo"/>
      <translate source="est" target="et"/>
      <translate source="baq" target="eu"/>
      <translate source="ewe" target="ee"/>
      <translate source="fao" target="fo"/>
      <translate source="per" target="fa"/>
      <translate source="fij" target="fj"/>
      <translate source="fin" target="fi"/>
      <translate source="fre" target="fr"/>
      <translate source="fre" target="fr"/>
      <translate source="fry" target="fy"/>
      <translate source="ful" target="ff"/>
      <translate source="geo" target="ka"/>
      <translate source="ger" target="de"/>
      <translate source="gla" target="gd"/>
      <translate source="gle" target="ga"/>
      <translate source="glg" target="gl"/>
      <translate source="glv" target="gv"/>
      <translate source="gre" target="el"/>
      <translate source="grn" target="gn"/>
      <translate source="guj" target="gu"/>
      <translate source="hat" target="ht"/>
      <translate source="hau" target="ha"/>
      <translate source="heb" target="he"/>
      <translate source="her" target="hz"/>
      <translate source="hin" target="hi"/>
      <translate source="hmo" target="ho"/>
      <translate source="hrv" target="hr"/>
      <translate source="hun" target="hu"/>
      <translate source="arm" target="hy"/>
      <translate source="ibo" target="ig"/>
      <translate source="ice" target="is"/>
      <translate source="ido" target="io"/>
      <translate source="iii" target="ii"/>
      <translate source="iku" target="iu"/>
      <translate source="ile" target="ie"/>
      <translate source="ina" target="ia"/>
      <translate source="ind" target="id"/>
      <translate source="ipk" target="ik"/>
      <translate source="ice" target="is"/>
      <translate source="ita" target="it"/>
      <translate source="jav" target="jv"/>
      <translate source="jpn" target="ja"/>
      <translate source="kal" target="kl"/>
      <translate source="kan" target="kn"/>
      <translate source="kas" target="ks"/>
      <translate source="geo" target="ka"/>
      <translate source="kau" target="kr"/>
      <translate source="kaz" target="kk"/>
      <translate source="khm" target="km"/>
      <translate source="kik" target="ki"/>
      <translate source="kin" target="rw"/>
      <translate source="kir" target="ky"/>
      <translate source="kom" target="kv"/>
      <translate source="kon" target="kg"/>
      <translate source="kor" target="ko"/>
      <translate source="kua" target="kj"/>
      <translate source="kur" target="ku"/>
      <translate source="lao" target="lo"/>
      <translate source="lat" target="la"/>
      <translate source="lav" target="lv"/>
      <translate source="lim" target="li"/>
      <translate source="lin" target="ln"/>
      <translate source="lit" target="lt"/>
      <translate source="ltz" target="lb"/>
      <translate source="lub" target="lu"/>
      <translate source="lug" target="lg"/>
      <translate source="mac" target="mk"/>
      <translate source="mah" target="mh"/>
      <translate source="mal" target="ml"/>
      <translate source="mao" target="mi"/>
      <translate source="mar" target="mr"/>
      <translate source="may" target="ms"/>
      <translate source="mac" target="mk"/>
      <translate source="mlg" target="mg"/>
      <translate source="mlt" target="mt"/>
      <translate source="mon" target="mn"/>
      <translate source="mao" target="mi"/>
      <translate source="may" target="ms"/>
      <translate source="bur" target="my"/>
      <translate source="nau" target="na"/>
      <translate source="nav" target="nv"/>
      <translate source="nbl" target="nr"/>
      <translate source="nde" target="nd"/>
      <translate source="ndo" target="ng"/>
      <translate source="nep" target="ne"/>
      <translate source="dut" target="nl"/>
      <translate source="nno" target="nn"/>
      <translate source="nob" target="nb"/>
      <translate source="nor" target="no"/>
      <translate source="nya" target="ny"/>
      <translate source="oci" target="oc"/>
      <translate source="oji" target="oj"/>
      <translate source="ori" target="or"/>
      <translate source="orm" target="om"/>
      <translate source="oss" target="os"/>
      <translate source="pan" target="pa"/>
      <translate source="per" target="fa"/>
      <translate source="pli" target="pi"/>
      <translate source="pol" target="pl"/>
      <translate source="por" target="pt"/>
      <translate source="pus" target="ps"/>
      <translate source="que" target="qu"/>
      <translate source="roh" target="rm"/>
      <translate source="rum" target="ro"/>
      <translate source="rum" target="ro"/>
      <translate source="run" target="rn"/>
      <translate source="rus" target="ru"/>
      <translate source="sag" target="sg"/>
      <translate source="san" target="sa"/>
      <translate source="sin" target="si"/>
      <translate source="slo" target="sk"/>
      <translate source="slo" target="sk"/>
      <translate source="slv" target="sl"/>
      <translate source="sme" target="se"/>
      <translate source="smo" target="sm"/>
      <translate source="sna" target="sn"/>
      <translate source="snd" target="sd"/>
      <translate source="som" target="so"/>
      <translate source="sot" target="st"/>
      <translate source="spa" target="es"/>
      <translate source="alb" target="sq"/>
      <translate source="srd" target="sc"/>
      <translate source="srp" target="sr"/>
      <translate source="ssw" target="ss"/>
      <translate source="sun" target="su"/>
      <translate source="swa" target="sw"/>
      <translate source="swe" target="sv"/>
      <translate source="tah" target="ty"/>
      <translate source="tam" target="ta"/>
      <translate source="tat" target="tt"/>
      <translate source="tel" target="te"/>
      <translate source="tgk" target="tg"/>
      <translate source="tgl" target="tl"/>
      <translate source="tha" target="th"/>
      <translate source="tib" target="bo"/>
      <translate source="tir" target="ti"/>
      <translate source="ton" target="to"/>
      <translate source="tsn" target="tn"/>
      <translate source="tso" target="ts"/>
      <translate source="tuk" target="tk"/>
      <translate source="tur" target="tr"/>
      <translate source="twi" target="tw"/>
      <translate source="uig" target="ug"/>
      <translate source="ukr" target="uk"/>
      <translate source="urd" target="ur"/>
      <translate source="uzb" target="uz"/>
      <translate source="ven" target="ve"/>
      <translate source="vie" target="vi"/>
      <translate source="vol" target="vo"/>
      <translate source="wel" target="cy"/>
      <translate source="wln" target="wa"/>
      <translate source="wol" target="wo"/>
      <translate source="xho" target="xh"/>
      <translate source="yid" target="yi"/>
      <translate source="yor" target="yo"/>
      <translate source="zha" target="za"/>
      <translate source="chi" target="zh"/>
      <translate source="zul" target="zu"/>

      <!-- Andere -->
      <translate source="deu" target="de"/>

    </xsl:variable>

    <xsl:value-of select="if ($translate[@source = $language]) then $translate[@source = $language][1]/@target else 'other'"/>

  </xsl:function>

</xsl:transform>
