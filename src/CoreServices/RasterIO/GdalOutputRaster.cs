// Copyright 2010-2011 Green Code LLC
// All rights reserved.
//
// The copyright holders license this file under the New (3-clause) BSD
// License (the "License").  You may not use this file except in
// compliance with the License.  A copy of the License is available at
//
//   http://www.opensource.org/licenses/bsd-license.php
//
// and is included in the NOTICE.txt file distributed with this work.
//
// Contributors:
//   James Domingo, Green Code LLC

using OSGeo.GDAL;
using GdalBand = OSGeo.GDAL.Band;
using System;
using System.Collections.Generic;

namespace Landis.SpatialModeling.CoreServices.RasterIO
{
    public class GdalOutputRaster<TPixel> : OutputRaster, IOutputRaster<TPixel>
        where TPixel : Pixel, new()
    {
        private TPixel bufferPixel;
        public TPixel BufferPixel {
            get {
                return bufferPixel;
            }
        }

        private Dataset dataset;
        private IOutputBand[] rasterBands;
 
        static IDictionary<string, Driver> extToDriver; // maps file extension to GDAL driver

        static GdalOutputRaster()
        {
            GdalSystem.Initialize();

            extToDriver = new Dictionary<string, Driver>(StringComparer.InvariantCultureIgnoreCase);
            extToDriver[".bin"] = Gdal.GetDriverByName("ENVI");
            extToDriver[".bmp"] = Gdal.GetDriverByName("BMP");
            extToDriver[".img"] = Gdal.GetDriverByName("HFA");
            extToDriver[".tif"] = Gdal.GetDriverByName("GTiff");
        }

        public GdalOutputRaster(string     path,
                                Dimensions dimensions)
            : base(path, dimensions)
        {
            // Fetch extension from path.
            // Get the GDAL driver associated with that extension.
            string extension = System.IO.Path.GetExtension(path);
            if (extension == null)
                throw new ArgumentNullException("path argument is null");
            if (extension == string.Empty)
                throw new ArgumentException("path has no extension");
            Driver driver;
            if (! extToDriver.TryGetValue(extension, out driver))
                throw new ApplicationException(string.Format("Unknown file extension: \"{0}\"", extension));

            bufferPixel = new TPixel();
            int nBands = bufferPixel.Count;

            // Determine the minimum data type to hold all the pixel's bands
            DataType dataType = GdalDataType.FromTypeCode(bufferPixel[1].TypeCode);
            for (int bandNum = 2; bandNum <= nBands; ++bandNum) {
                dataType = GdalDataType.Union(dataType, GdalDataType.FromTypeCode(bufferPixel[bandNum].TypeCode));
            }

            rasterBands = new IOutputBand[nBands];
            string[] options = { };

            // call driver.Create( ... dimensions ... , # of bands , data type );
            dataset = driver.Create(path, dimensions.Columns, dimensions.Rows, nBands, dataType, options);

            System.Console.WriteLine("dataset created: {0}", dataset.GetDescription());

            for (int i = 0; i < nBands; ++i) {
                int bandNum = i + 1;
                rasterBands[i] = NewOutputBand(dataType, dataset.GetRasterBand(bandNum), bufferPixel[bandNum]);
            }
        }


        public void WriteBufferPixel()
        {
            foreach (IOutputBand rasterBand in rasterBands) {
                 rasterBand.WriteValueFromBufferPixel();
            }
        }


        public static IOutputBand NewOutputBand(DataType  dataType,
                                                GdalBand  gdalBand,
                                                PixelBand pixelBand)
        {
            switch (dataType) {
                case DataType.GDT_Byte:
                    return NewByteBand(gdalBand, pixelBand);

                case DataType.GDT_Int16:
                    return NewShortBand(gdalBand, pixelBand);

                case DataType.GDT_Int32:
                    return NewIntBand(gdalBand, pixelBand);

                case DataType.GDT_Float32:
                    return NewFloatBand(gdalBand, pixelBand);

                case DataType.GDT_Float64:
                    return NewDoubleBand(gdalBand, pixelBand);

                default:
                    throw new ArgumentException("dataType is not byte, short, int, float, double");
            }
        }


        public static OutputBand<byte> NewByteBand(GdalBand  gdalBand,
                                                   PixelBand pixelBand)
        {
            RasterBandWriter<byte> rasterBandWriter = RasterBandWriters.NewByteWriter(gdalBand);

            switch (pixelBand.TypeCode) {
                case TypeCode.Byte:
                    return new OutputBand<byte>(rasterBandWriter, new PixelBandGetter<byte, byte>(pixelBand, Convert.ToByte));

                case TypeCode.SByte:
                    return new OutputBand<byte>(rasterBandWriter, new PixelBandGetter<sbyte, byte>(pixelBand, Convert.ToByte));

                default:
                    throw new ArgumentException("pixelBand.TypeCode is not byte or sbyte");
            }
        }


        public static OutputBand<short> NewShortBand(GdalBand  gdalBand,
                                                     PixelBand pixelBand)
        {
            RasterBandWriter<short> rasterBandWriter = RasterBandWriters.NewShortWriter(gdalBand);

            switch (pixelBand.TypeCode) {
                case TypeCode.Byte:
                    return new OutputBand<short>(rasterBandWriter, new PixelBandGetter<byte, short>(pixelBand, Convert.ToInt16));

                case TypeCode.SByte:
                    return new OutputBand<short>(rasterBandWriter, new PixelBandGetter<sbyte, short>(pixelBand, Convert.ToInt16));

                case TypeCode.UInt16:
                    return new OutputBand<short>(rasterBandWriter, new PixelBandGetter<ushort, short>(pixelBand, Convert.ToInt16));

                case TypeCode.Int16:
                    return new OutputBand<short>(rasterBandWriter, new PixelBandGetter<short, short>(pixelBand, Convert.ToInt16));

                default:
                    throw new ArgumentException("pixelBand.TypeCode is not byte, sbyte, ushort, short");
            }
        }


        public static OutputBand<int> NewIntBand(GdalBand  gdalBand,
                                                 PixelBand pixelBand)
        {
            RasterBandWriter<int> rasterBandWriter = RasterBandWriters.NewIntWriter(gdalBand);

            switch (pixelBand.TypeCode) {
                case TypeCode.Byte:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<byte, int>(pixelBand, Convert.ToInt32));

                case TypeCode.SByte:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<sbyte, int>(pixelBand, Convert.ToInt32));

                case TypeCode.UInt16:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<ushort, int>(pixelBand, Convert.ToInt32));

                case TypeCode.Int16:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<short, int>(pixelBand, Convert.ToInt32));

                case TypeCode.UInt32:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<uint, int>(pixelBand, Convert.ToInt32));

                case TypeCode.Int32:
                    return new OutputBand<int>(rasterBandWriter, new PixelBandGetter<int, int>(pixelBand, Convert.ToInt32));

                default:
                    throw new ArgumentException("pixelBand.TypeCode is not byte, sbyte, ushort, short, uint, int");
            }
        }


        public static OutputBand<float> NewFloatBand(GdalBand  gdalBand,
                                                     PixelBand pixelBand)
        {
            RasterBandWriter<float> rasterBandWriter = RasterBandWriters.NewFloatWriter(gdalBand);

            switch (pixelBand.TypeCode) {
                case TypeCode.Byte:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<byte, float>(pixelBand, Convert.ToSingle));

                case TypeCode.SByte:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<sbyte, float>(pixelBand, Convert.ToSingle));

                case TypeCode.UInt16:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<ushort, float>(pixelBand, Convert.ToSingle));

                case TypeCode.Int16:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<short, float>(pixelBand, Convert.ToSingle));

                case TypeCode.UInt32:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<uint, float>(pixelBand, Convert.ToSingle));

                case TypeCode.Int32:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<int, float>(pixelBand, Convert.ToSingle));

                case TypeCode.Single:
                    return new OutputBand<float>(rasterBandWriter, new PixelBandGetter<float, float>(pixelBand, Convert.ToSingle));

                default:
                    throw new ArgumentException("pixelBand.TypeCode is not byte, sbyte, ushort, short, uint, int, float");
            }
        }


        public static OutputBand<double> NewDoubleBand(GdalBand  gdalBand,
                                                       PixelBand pixelBand)
        {
            RasterBandWriter<double> rasterBandWriter = RasterBandWriters.NewDoubleWriter(gdalBand);

            switch (pixelBand.TypeCode) {
                case TypeCode.Byte:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<byte, double>(pixelBand, Convert.ToDouble));

                case TypeCode.SByte:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<sbyte, double>(pixelBand, Convert.ToDouble));

                case TypeCode.UInt16:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<ushort, double>(pixelBand, Convert.ToDouble));

                case TypeCode.Int16:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<short, double>(pixelBand, Convert.ToDouble));

                case TypeCode.UInt32:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<uint, double>(pixelBand, Convert.ToDouble));

                case TypeCode.Int32:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<int, double>(pixelBand, Convert.ToDouble));

                case TypeCode.Single:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<float, double>(pixelBand, Convert.ToDouble));

                case TypeCode.Double:
                    return new OutputBand<double>(rasterBandWriter, new PixelBandGetter<double, double>(pixelBand, Convert.ToDouble));

                default:
                    throw new ArgumentException("pixelBand.TypeCode is not byte, sbyte, ushort, short, uint, int, float, double");
            }
        }

        protected override void Dispose(bool disposeManaged)
        {
            foreach (IOutputBand rasterBand in rasterBands) {
                if (rasterBand != null)
                    rasterBand.Flush();
            }
            if (dataset != null)
                dataset.Dispose();
            base.Dispose(disposeManaged);
        }
    }
}
