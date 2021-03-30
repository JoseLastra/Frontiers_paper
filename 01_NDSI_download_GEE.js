/////////////////////////////////////////////////////
//Frontiers snow paper: Mocho-Choshuenco
//Author: José A. Lastra
//creation date: 2020.07.15
//update: 2021.03.01
////////////////////////////////////////////////////
//Qa application function L8

var maskQa1 = function (image) {
  //save snow pixels
  var quality = image.select('pixel_qa');
  var m00 = quality.eq(324);
  var m01 = quality.eq(328);
  //var m02 = quality.eq(336); snow, low cloud confidence
  var m03 = quality.eq(352);
 // var m04 = quality.eq(368); snow/ice, cloud
  var m05 = quality.eq(388);
  //var m06 = quality.eq(392); cloud shadow, medium confidence
  //var m07 = quality.eq(400);snow ice, medium cloud confidence
  //var m08 = quality.eq(432);snow ice,cloud ,medium cloud confidence
  var m09 = quality.eq(480);
  //var m10 = quality.eq(836); water, low confidence cloud
  var m11 = quality.eq(840);
  //var m12 = quality.eq(848);
  var m13 = quality.eq(864); 
  //var m14 = quality.eq(880); snow or cloud
  var m15 = quality.eq(900);
  var m16 = quality.eq(904);
  //var m17 = quality.eq(912);
  var m18 = quality.eq(928);
  //var m19 = quality.eq(944); snow or cloud
  var m20 = quality.eq(992);
  var m21 = quality.eq(386);
  var m22 = quality.eq(416);
  var m23 = quality.eq(1348);
  var m24 = quality.eq(1350);
  var m25 = quality.eq(1352);
  //mask
  var mask = m00.or(m01)//.or(m02)
  .or(m03)//.or(m04)
  .or(m05)//.or(m06)
  //.or(m07).or(m08)
  .or(m09)//.or(m10)
  .or(m11)//.or(m12)
  .or(m13)//.or(m14)
  .or(m15).or(m16)
  //.or(m17).or(m19)
  .or(m18).or(m20).or(m21).or(m22)
  .or(m23).or(m24).or(m25).not();
  return image.updateMask(mask);
};

//Qa application function QA L457
var maskQa2 = function (image) {
  var quality = image.select('pixel_qa');
  var cloud01 = quality.eq(68);
  var cloud02 = quality.eq(72);
  //var cloud03 = quality.eq(80); snow ice
  var cloud04 = quality.eq(96);
  //var cloud05 = quality.eq(112); snow ice
  var cloud06 = quality.eq(130);
  var cloud07 = quality.eq(132);
  var cloud08 = quality.eq(136);
  //var cloud09 = quality.eq(144); snow ice
  var cloud10 = quality.eq(160);
  //var cloud11 = quality.eq(176); snow ice
  var cloud12 = quality.eq(224);

  var mask = cloud01.or(cloud02)//.or(cloud03)
  .or(cloud04)//.or(cloud05)
  .or(cloud06).or(cloud07).or(cloud08)//.or(cloud09)
  .or(cloud10)//.or(cloud11)
  .or(cloud12).not();
  return image.updateMask(mask);
};


//NDSI function
var NDSI = function(image) {
  var crop = image.clip(aoi)
  var ndsi = crop.multiply(0.0001).normalizedDifference(['green', 'swir1']).rename('NDSI');
  return image.addBands(ndsi);
};

/////////////////////////////////////////////
//Tier 1 collections
var landsat8 = landsat_8.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat7 = landsat_7.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat5 = landsat_5.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat4 = landsat_4.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

//Tier 2 collections
var landsat8T2 = landsat_8T2.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat7T2 = landsat_7T2.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat5T2 = landsat_5T2.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');

var landsat4T2 = landsat_4T2.filterBounds(aoi)
.filterDate('1984-01-01', '2019-12-31');


//Tier 1
 // select and rename bands
        var landsat8k = landsat8.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['aerosol', 'blue', 'green','red', 'nir', 'swir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa1);
        var landsat5k = landsat5.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);
         var landsat4k = landsat4.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);
        var landsat7k = landsat7.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);
            
//Tier 2
 // select and rename bands
        var landsat8kT2 = landsat8T2.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['aerosol', 'blue', 'green','red', 'nir', 'swir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa1);
        var landsat5kT2 = landsat5T2.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);
        var landsat4kT2 = landsat4T2.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);
        var landsat7kT2 = landsat7T2.select(
                ['B1', 'B2', 'B3','B4', 'B5', 'B6','B7', 'pixel_qa'], // old names
                ['blue', 'green','red', 'nir', 'swir1', 'tir1','swir2', 'pixel_qa'] // new names
            ).map(maskQa2);

/////////////////////////////////////////////////////
////////////////////////////////////////////////////
//Merge collections

var collection = landsat4k.merge(landsat5k).merge(landsat5kT2).merge(landsat7k)
.merge(landsat7kT2).merge(landsat8k).merge(landsat8kT2);
print(collection,'full collection');

//Nuevas colecciones con funciones aplicadas
var LandsatSR = collection
.map(NDSI)
.sort('system:time_start');

// filter collection considering pixels with data

var num_pixeles = ee.Number(110000); // Consider a minimum of 80% of pixel for the entire AOI (Total 552000)

var coleccion = LandsatSR.map(function(img) {
            var esc1 = img.select("swir1").clip(aoi);
            var total_area = esc1.reduceRegion({
              reducer: ee.Reducer.count(),
              geometry: aoi,
              scale: 30,
              maxPixels: 3e9});
          var meta = total_area.get("swir1");
          return img.set('ANPIXEL', meta)})
         .filterMetadata('ANPIXEL', 'not_less_than',num_pixeles);

  

print(coleccion,'filter surface reflectance collection');

var exportCollection = coleccion.select(["NDSI"]).toBands().clip(aoi);

/////////////////////////////////////////////////////////////////////////////////////
// Exporting data

//get band names
// full collection
var names_full= collection.aggregate_array('LANDSAT_ID');


//clean collection
var band_names = coleccion.aggregate_array('LANDSAT_ID');
print(band_names,'bands');


// Clean colecction feature collection
var fc = ee.FeatureCollection(band_names.map(function(point) {
  return ee.Feature(null, {'value': point});
}));


//Export list


//clean collection
Export.table.toDrive(fc,
"lista_cleanCollection", //my task
"snow", //my export folder 
"list_cleanCollection_names",  //file name
"CSV");

//Export stack
Export.image.toDrive({
  image: exportCollection,
  description: 'Landsat_SnowBrick',
  scale: 30,
  region:aoi,
  folder:'snow',
  maxPixels: 9e9,
  fileFormat: 'GeoTIFF',
  formatOptions: {
    cloudOptimized: true
  }
});