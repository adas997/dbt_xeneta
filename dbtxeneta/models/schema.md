{% docs desc_stg_ports %}

This table includes information about cargo ports:

 - /
 - /Attributes: PID: an integer ID for the port, which is unique, Port_code : 5-character port code, also unique key, Port name,  Region_id : Slug identifying which region the port belongs to, Country and  Country_code : Two-letter country code
 - /team : Data Engineer
 - /contact-us :

{% enddocs %}

{% docs desc_stg_region %}

This table includes information about a hierarchy of regions that company has defined, based on ocean container shipping routes and pricing patterns.
Regions have the following information:

 - /
 - /Attributes: Slug/Region_id - a machine-readable form of the region name, Region_name : Name of the region, Parent_region: Slug/Region_id describing which parent region the region belongs to in region hierarchy
 - /team : Data Engineer
 - /contact-us :

{% enddocs %}


{% docs desc_stg_rates %}

This table includes information about currency , exchange rates and valid date.

 - /team : Data Engineer
 - /contact-us :

{% enddocs %}


{% docs desc_final_fct %}

This is the Final Fact table. This table contains the median and average of price amount. The fact table shows aggregated price values if we have at least 5 different companies and 2 different suppliers providing 
data on the given lane, with given equipment type 

  
 - /team : Data Engineer
 - /contact-us :

{% enddocs %}