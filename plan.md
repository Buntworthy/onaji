# Planning

## Data structures

For each image we will require the following things:

- Root directory
- Network and layer
- Relative path
- Thumbnail?
- Features
- Regions

To extract the above for each image we will need to specify:

- Root directory
- Network and layer
- Region proposal method

## Queries

We might make the following queries:

- Number of images: single/multiple
- Number of regions: single/multiple
- Regions to compare: fixed/all
- Distance aggregation: average/minimum
- Distance metric: cosine, L1, L2, etc

Typical probable queries:

- Find an overall similar image
	Whole image region vs whole image region
- Find an object
	Single sub-region vs all other image sub-regions
- Find similar composition
	Fixed set of sub-regions vs other image same fixed sub-regions
- Find  shared objects
	All sub-regions vs all other sub-regions

## Classes

### ImageData

Properties:

- Root
- Network
- Layer
- Path
- Features
- Regions

Methods:

- show
- showRegions(idx)

### Query

Data required for a query is only a set of features (and possibly some region)