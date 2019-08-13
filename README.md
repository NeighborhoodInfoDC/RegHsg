# RegHsg
Regional Housing Framework


## Impact Estimates

The `Prog/impact-estimates` directory contains the code used to clean parcel-level data and genererate estimates for the number of housing units that could be added by 

* filling in vacant lots per the current zoning code

* adding units to underutilized lots

* increasing density via upzoning around transit and activity zones.


Jurisdictions included in this analysis are Arlington County, Fairfax County, Montgomery County (including Rockville and Fairfax), and the District of Columbia.

### Process Description

Many of processes are done individually for each county. The soft sites and upzoning analyses involve combining the parcel data for all jurisdictions.

#### 01_preclean

The purpose of these programs is to combine Black Knight parcel level data with other local data sources.

#### 02_clean

The purpose of these programs is to:

* Re-categorize land use based on county land use codes, to establish uniform categories across jurisdictions,
* Collapse condos and other parcels so that each observation in the dataset represents one unique address.
* Clean the variables needed to provide density and zoning estimates.

#### 03_postclean

This step exists only for Montgomery County. The purpose is to:

* Use county data sources to determine the correct lot size and zoning designation
* Identify which parcels are in Rockville or Gaithersburg

#### 04_vacant-lots

The purpose of these programs is to calculate the maximum number of units that can be built on each lot per the current zoning code. Through this process, we identify which vacant lots are zoned for multifamily and how many units can be built on each of these lots.

This step outputs a `max-units` dataset which will be used in the soft sites. 

#### 05_combine-parcels

The purpose of this program is to combine the cleaned parcel data to be used in the upzoning analysis.

#### 06_clean-node-geographies

The purpose of this program is to walk through the geospatial data cleaning process that combines and buffers transit stops and activity zones to be used in the upzoning analysis.

#### 07_soft-sites

The purpose of this program is to calculate how many parcels are underutilized- have fewer units than the max allowed under the zoning code.

#### 08_upzoning

The purpose of this program is to determine how many units could be produced if areas surrounding transit and activity centers were upzoned and therefor could have increased density.


### Output

`.html` files are output into the `Prog/impact-estimates/output` directory, and are categorized by step in the process.
