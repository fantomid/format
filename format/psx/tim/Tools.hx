/*
 * format - haXe File Formats
 *
 *  TIM File Format
 *  Copyright (C) 2016 Guillaume Gasnier
 *
 * Copyright (c) 2009, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	- Redistributions of source code must retain the above copyright
 *	  notice, this list of conditions and the following disclaimer.
 *	- Redistributions in binary form must reproduce the above copyright
 *	  notice, this list of conditions and the following disclaimer in the
 *	  documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package format.psx.tim;

import format.psx.tim.Data;
import haxe.io.Bytes;

import format.png.Data;
import format.png.Tools;

enum PixelFormat {
	PixelFormat_RGBA;
  PixelFormat_BGRA;
}

class Tools {
  static public var magicNumber = 0x10;
  static var paletted_4_BPP = 0x08;
  static var paletted_8_BPP = 0x09;
  static var trueColor_16_BPP = 0x02;
  static var trueColor_24_BPP = 0x03;
  
  static public function checkMagicNumber(magic: Int) : Bool {
    if(magicNumber == magic)
      return true;
    else
      return false;
  }
  
  static public function toImageFormat(format: Int) : TIMFormat {
    if(paletted_4_BPP == format)
      return TF_Paletted_4_BPP;
    if(paletted_8_BPP == format)
      return TF_Paletted_8_BPP;
    if(trueColor_16_BPP == format)
      return TF_TrueColor_16_BPP;
    if(trueColor_24_BPP == format)
      return TF_TrueColor_24_BPP;
    throw "unknown TIM image format: " + format;
  }
  
  static public function fromImageFormat(imageFormat: TIMFormat) : Int {
    if(TF_Paletted_4_BPP == imageFormat)
      return paletted_4_BPP;
    if(TF_Paletted_8_BPP == imageFormat)
      return paletted_8_BPP;
    if(TF_TrueColor_16_BPP == imageFormat)
      return trueColor_16_BPP;
    if(TF_TrueColor_24_BPP == imageFormat)
      return trueColor_24_BPP;
    throw "unknown TIM image format: " + imageFormat;
  }
  
  static public function dumpHeader(image: TIM) : Void {
    trace("format: " + image.header.imageFormat);
    trace("image Org (X, Y): (" + image.header.imageOrgX + "," 
      + image.header.imageOrgY + ")");
    trace("width: " + image.header.imageWidth);
    trace("height: " + image.header.imageHeight);
    trace("palette Org (X,Y): (" + image.header.paletteOrgX + "," 
      + image.header.paletteOrgY + ")");
    trace("colors by clut: " + image.header.clutColorsNum);
    trace("clut number: " + image.header.clutsNum);
    
    if(image.header.imageFormat == TF_Paletted_4_BPP || image.header.imageFormat == TF_Paletted_8_BPP)
    {
      trace("clut size: " + image.palettes.length);
    }
    trace("buffer size: " + image.buffer.length);
  }
  
  private static function getPixels(data: TIM, indexBuffer: Int, pixelFmt: PixelFormat) : Bytes {
    var pixels: Bytes;
    var pixelData = data.buffer.getUInt16(indexBuffer);
    if(data.header.imageFormat == TF_Paletted_4_BPP)
    {
      pixels = Bytes.alloc(16);
      var pixel1 = getPixel(data.palettes.getUInt16(pixelData & 0xf), pixelFmt);
      var pixel2 = getPixel(data.palettes.getUInt16((pixelData >> 4) & 0xf), pixelFmt);
      var pixel3 = getPixel(data.palettes.getUInt16((pixelData >> 8) & 0xf), pixelFmt);
      var pixel4 = getPixel(data.palettes.getUInt16((pixelData >> 12) & 0xf), pixelFmt);
      
      pixels.blit(0, pixel1, 0, pixel1.length);
      pixels.blit(4, pixel2, 0, pixel2.length);
      pixels.blit(8, pixel3, 0, pixel3.length);
      pixels.blit(12, pixel4, 0, pixel4.length);
     
      return pixels;      
    }
    else
    {
      if(data.header.imageFormat == TF_Paletted_8_BPP)
      {
        pixels = Bytes.alloc(8);
        var pixel1 = getPixel(data.palettes.getUInt16(pixelData & 0xff), pixelFmt);
        var pixel2 = getPixel(data.palettes.getUInt16((pixelData >> 8) & 0xff), pixelFmt);

        pixels.blit(0, pixel1, 0, pixel1.length);
        pixels.blit(4, pixel2, 0, pixel2.length);

        return pixels;
      }
      else
      {
        if(data.header.imageFormat == TF_TrueColor_16_BPP)
        {
          pixels = Bytes.alloc(4);
          var pixel1 = getPixel(pixelData, pixelFmt);

          for(i in 0...pixel1.length)
          {
            pixels.set(i, pixel1.get(i));
          }
          
          return pixels;
        }
        else
          throw "Invalid TIM image format";        
      }
    }
  }
  
  private static function getPixel(color: Int, format: PixelFormat) : Bytes{
		var pixel:Bytes;
    var red: Int = (color & 0x1f) << 3; // R
		var green: Int = ((color >> 5) & 0x1f) << 3; // G
		var blue: Int = ((color >> 10) & 0x1f) << 3; // B
		var alpha: Int = if(color == 0) 0; else 0xff; // A
    
    if(format == PixelFormat_RGBA || format == PixelFormat_BGRA)
    {
      pixel = Bytes.alloc(4);
      
      if(format == PixelFormat_RGBA)
      {
        pixel.set(0, red);
        pixel.set(1, green);
        pixel.set(2, blue);
        pixel.set(3, alpha);
      }
      else
      {
          pixel.set(0, blue);
          pixel.set(1, green);
          pixel.set(2, red);
          pixel.set(3, alpha);
      }
     
      return pixel;
    }
    else
      throw "Invalid pixel format";
	}
  
  /**
   * Extracts full pixel data: 4 bytes by pixel.
   * @param Tim data.
   * @pixelFmt Pixel format
   * @return pixel data.
   */
  private static function extractFull(data: TIM, pixelFmt: PixelFormat):Bytes
  {
    var bytes:Bytes = Bytes.alloc(data.header.imageWidth * data.header.imageHeight * 4);
    var height = 0;
    var width = 0;
    var index_buffer = 0;
    var index_image_buffer = 0;
    do
    {
      width = 0;
      do
      {
        var pixels = getPixels(data, index_buffer, pixelFmt);
        for(i in 0...pixels.length)
        {
          bytes.set(index_image_buffer++, pixels.get(i));
        }
        
        index_buffer += 2;
        if(data.header.imageFormat == TF_Paletted_4_BPP)
        {
          width += 4;
        }
        else
        {
          if(data.header.imageFormat == TF_Paletted_8_BPP)
          {
            width += 2;
          }
          else
          {
            width ++;
          }
        }
      }
      while(width < data.header.imageWidth);
      height++;
    }
    while(height < data.header.imageHeight);
   
    return bytes;
  }
  
  /**
   * Extracts full pixel data in Blue-Green-Red-Alpha pixel format.
   * @param Tim data.
   * @return BGRA pixel data.
   */
  public static function extractFullBGRA(data: TIM):Bytes
  {
    return extractFull(data, PixelFormat_BGRA);
  }
  
  /**
   * Extracts full pixel data in Red-Green-Blue-Alpha pixel format.
   * @param Tim data.
   * @return RGBA pixel data.
   */
  public static function extractFullRGBA(data:TIM):Bytes
  {
    return extractFull(data, PixelFormat_RGBA);
  }
  
  /**
   * Export to PNG data.
   * @param Tim data.
   * @return PNG data.
   */
  public static function exportToPNG(data:TIM):format.png.Data
  {
    var tim_bytes = extractFullBGRA(data);
    var png_data = format.png.Tools.build32BGRA(data.header.imageWidth, data.header.imageHeight, tim_bytes);
    return png_data;
  }    
}




