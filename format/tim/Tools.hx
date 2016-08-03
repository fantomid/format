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

class Tools {
  static var magicNumber = 0x10;
  static var paletted_4_BPP = 0x08;
  static var paletted_8_BPP = 0x09;
  static var trueColor_16_BPP = 0x02;
  static var trueColor_24_BPP = 0x03;
  
  static public function checkMagicNumber(magic : Int) : Bool {
    if(magicNumber == magic)
      return true;
    else
      return false;
  }
  
  static public function getImageFormat(format : Int) : TIMFormat {
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
  
  static public function dumpHeader(image : TIM) : Void {
    trace("format: " + image.header.format);
    trace("image Org (X, Y): (" + image.header.imageOrgX + "," 
      + image.header.imageOrgY + ")");
    trace("width: " + image.header.imageWidth);
    trace("height: " + image.header.imageHeight);
    trace("palette Org (X,Y): (" + image.header.paletteOrgX + "," 
      + image.header.paletteOrgY + ")");
    trace("colors by clut: " + image.header.clutColorsNum);
    trace("clut number: " + image.header.clutNum);
  }
}




