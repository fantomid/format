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
package format.tim;

import format.tim.Data;
import haxe.io.Bytes;

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
    
    trace("clut size: " + image.palettes.length);
    trace("buffer size: " + image.buffer.length);
  }
  
	private static function getRGBAPixel(color: Int) : Int{
		var red: Int = (color & 0x1f) << 3; // R
    red <<= 24;
		var green: Int = ((color >> 5) & 0x1f) << 3; // G
    green <<= 16;
		var blue: Int = ((color >> 10) & 0x1f) << 3; // B
    blue <<= 8;
		var alpha: Int = if(color == 0) 0; else 0xff; // A
    
    return red | green | blue | alpha;
	}
  
	private static function getBGRAPixel(color: Int) : Int{
		var red: Int = (color & 0x1f) << 3; // R
    red <<= 24;
		var green: Int = ((color >> 5) & 0x1f) << 3; // G
    green <<= 16;
		var blue: Int = ((color >> 10) & 0x1f) << 3; // B
    blue <<= 8;
		var alpha: Int = if(color == 0) 0; else 0xff; // A
    
    return blue | green | red | alpha;
	}
  
	/* TODO PixelFormat
    private static function getPixel(color: Int, format: PixelFormat) : Bytes{
		var pixel:Bytes = new 
    var red: Int = (color & 0x1f) << 3; // R
    red <<= 24;
		var green: Int = ((color >> 5) & 0x1f) << 3; // G
    green <<= 16;
		var blue: Int = ((color >> 10) & 0x1f) << 3; // B
    blue <<= 8;
		var alpha: Int = if(color == 0) 0; else 0xff; // A
    
    return blue | green | red | alpha;
	}*/
  
  /**
   * Extracts full pixel data in Blue-Green-Red-Alpha pixel format.
   * @param Tim data.
   * @pixelFmt Pixel format
   * @return BGRA pixel data.
   */
   // TODO
  private static function extractFull(data: TIM, pixelFmt: PixelFormat):Bytes
  {
    var bytes:Bytes = Bytes.alloc(data.header.imageWidth * data.header.imageHeight);
    
    return bytes;
  }
  
  /**
   * Extracts full pixel data in Blue-Green-Red-Alpha pixel format.
   * @param Tim data.
   * @return BGRA pixel data.
   */
   // TODO
  public static function extractFullBGRA(data: TIM):Bytes
  {
    return extractFull(data, PixelFormat_BGRA);
  }
  
  /**
   * Extracts full pixel data in Red-Green-Blue-Alpha pixel format.
   * @param Tim data.
   * @return RGBA pixel data.
   */
   // TODO
  public static function extractFullRGBA(data:TIM):Bytes
  {
    var size = data.header.imageWidth * data.header.imageHeight;
    var bytes:Bytes = Bytes.alloc(size * 4);
    
    trace("bytes length: " + bytes.length);
    
    if(data.header.imageFormat == TF_TrueColor_16_BPP)
    {
      for(index in 0...size) 
      {
        var color = data.buffer.getUInt16(index*2);
        var pixel = getRGBAPixel(color);
        
        //putPixel(pixels.data, i*4, c);
        bytes.setInt32(index*4, pixel);
      }
    }
	else 
  {
    if(data.header.imageFormat == TF_Paletted_8_BPP) 
    {
      for(index in 0...size) 
      {
        var c1c2 = data.buffer.getUInt16(index*2);
        var pixel1 = getRGBAPixel(data.palettes.get(c1c2 & 0xff));
        var pixel2 = getRGBAPixel(data.palettes.get((c1c2 >> 8) & 0xff));
        
        //putPixel(pixels.data, i*8+0, palette[ p & 0xff ]);
        //putPixel(pixels.data, i*8+4, palette[ (p>>8) & 0xff ]);
        bytes.setInt32(index*8+0, pixel1);
        bytes.setInt32(index*8+4, pixel2);
      }
    }
    else 
    {
      if( data.header.imageFormat == TF_Paletted_4_BPP) 
      {
        var height = 0;
        var width = 0;
        var index_buffer = 0;
        var index_image_buffer = 0;
        do
        {
          width = 0;
          do
          {
          trace("index_image_buffer: " + (index_image_buffer));
          trace("index_buffer: " + (index_buffer));
          
            var c1c2c3c4 = data.buffer.getUInt16(index_buffer);
            var pixel1RGBA = getRGBAPixel(data.palettes.get(c1c2c3c4 & 0xf));
            
            var pixel2 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 4) & 0xf));
            var pixel3 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 8) & 0xf));
            var pixel4 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 12) & 0xf));
            
            bytes.setInt32(index_image_buffer+0, pixel1);
            bytes.setInt32(index_image_buffer+4, pixel2);
            bytes.setInt32(index_image_buffer+8, pixel3);
            bytes.setInt32(index_image_buffer+12, pixel4);            
            index_image_buffer+= 16;
            index_buffer += 2;
            width += 4;

          trace("p1 " + StringTools.hex(pixel1, 8) + " - p2 " + StringTools.hex(pixel2, 8) 
            + " - p3 " + StringTools.hex(pixel3, 8) + " - p4 " + StringTools.hex(pixel4, 8));
          }
          while(width < data.header.imageWidth);
          height++;
        }
        while(height < data.header.imageHeight);
          
        /*for(index in 0...data.buffer.length-1) 
        {
          var c1c2c3c4 = data.buffer.getUInt16(index*2);
          trace("index: " + index*2 + " palette index " 
            + (c1c2c3c4 & 0xf) + " " + ((c1c2c3c4 >> 4) & 0xf) + " " 
            + ((c1c2c3c4 >> 8) & 0xf) + " " + ((c1c2c3c4 >> 12) & 0xf));
          trace("colors: " 
            + data.palettes.get(c1c2c3c4 & 0xf) + " " + data.palettes.get((c1c2c3c4 >> 4) & 0xf) + " " 
            + data.palettes.get((c1c2c3c4 >> 8) & 0xf) + " " + data.palettes.get((c1c2c3c4 >> 12) & 0xf));
          var pixel1 = getRGBAPixel(data.palettes.get(c1c2c3c4 & 0xf));
          var pixel2 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 4) & 0xf));
          var pixel3 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 8) & 0xf));
          var pixel4 = getRGBAPixel(data.palettes.get((c1c2c3c4 >> 12) & 0xf));*/
        /*for( var i = 0; i < entries; i++ ) {
          var p = data.getUint16(offset+i*2, true);

          putPixel(pixels.data, i*16+ 0, palette[ p & 0xf ]);
          putPixel(pixels.data, i*16+ 4, palette[ (p>>4) & 0xf ]);
          putPixel(pixels.data, i*16+ 8, palette[ (p>>8) & 0xf ]);
          putPixel(pixels.data, i*16+12, palette[ (p>>12) & 0xf ]);
        }*/
        /*  trace("index: " + (index*16+0) + " p1 " + StringTools.hex(pixel1, 8) + " " + (index*16+4) + " p2 " + StringTools.hex(pixel2, 8) 
            + " " + (index*16+8) + " p3 " + StringTools.hex(pixel3, 8) + " " + (index*16+12) + " p4 " + StringTools.hex(pixel4, 8));
          bytes.setInt32(index*16+0, pixel1);
          bytes.setInt32(index*16+4, pixel2);
          bytes.setInt32(index*16+8, pixel3);
          bytes.setInt32(index*16+12, pixel4);
        }*/
      }
    }
	}
    return bytes;
  }  
}




