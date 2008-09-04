<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-so-encap.xsl,v 1.1 2007/10/17 18:37:03 phil Exp $
-
- Copyright (c) 2004-2005, Juniper Networks, Inc.
- All rights reserved.
-
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:junos="http://xml.juniper.net/junos/*/junos"
  xmlns:xnm="http://xml.juniper.net/xnm/1.1/xnm"
  xmlns:jcs="http://xml.juniper.net/junos/commit-scripts/1.0">

  <xsl:import href="../import/junos.xsl"/>

  <!--
  - This example adds a default encapsulation to sonet interfaces
  - not configured as aggregate interfaces.  Note that "$tag" is passed
  - to jcs:emit-change as "transient-change", so this change
  - will not be visible in the candidate configuration.
  - 
  - This sort of thing would normally be done using configuration
  - groups, but they won't handle the test for [sonet-options aggregate].
  - The motivation for this is to avoid setting the encapsulation
  - an an aggregated interface.
  -
  - Another way of implemented this would be to put the intended
  - sonet configuration in a configuration group that's applied
  - at the [interfaces] level.  Then this change could be simply
  - to add an "apply-groups-except sonet-group" statement to
  - aggregate interfaces.  This allows the details of the configuration
  - data to remain in the configuration file, and allows the commit script
  - to manipulate the data, rather than contain it.
  -->
  <xsl:template match="configuration">
    <xsl:for-each select="interfaces/interface[starts-with(name, 'so-')
                                            and not(sonet-options/aggregate)]">
      <xsl:call-template name="jcs:emit-change">
        <xsl:with-param name="tag" select="'transient-change'"/>
        <xsl:with-param name="content">
          <encapsulation>cisco-hdlc</encapsulation>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
