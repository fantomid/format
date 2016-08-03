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

class Reader {

	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
		i.bigEndian = false;
	}
	
	inline function readInt() {
		#if haxe3
		return i.readInt32();
		#else
		return i.readUInt30();
		#end
	}
	
	public function read() : TIM {
  	if(!Tools.checkMagicNumber(readInt()))
			throw "TIM header expected";

    var format = readInt();
    var imageFormat = Tools.toImageFormat(format);
    
    var imageOrgX = -1;
    var imageOrgY = -1;
    var imageWidth = -1;
    var imageHeight = -1;
    var paletteOrgX = -1;
    var paletteOrgY = -1;
    var clutColorsNum = -1;
    var clutNum = -1;
    var palettes : haxe.io.Bytes = null;
    var data : haxe.io.Bytes = null;
    if(TF_Paletted_4_BPP == imageFormat || TF_Paletted_8_BPP == imageFormat)
    {
      var clutSize = readInt();
      paletteOrgX = i.readUInt16();
      paletteOrgY = i.readUInt16();
      clutColorsNum = i.readUInt16();
      clutNum = i.readUInt16();
      palettes = i.read(clutSize - 12);
    }

    var imageSize = readInt();
    imageOrgX = i.readUInt16();
    imageOrgY = i.readUInt16();
    imageWidth = i.readUInt16();
    
    if(TF_Paletted_4_BPP == imageFormat)
      imageWidth *= 4;
    if(TF_Paletted_8_BPP == imageFormat)
      imageWidth *= 2;
    // case TF_TrueColor_16_BPP - imageWidth is already correct
    // case TF_TrueColor_24_BPP - TODO when supported

    imageHeight = i.readUInt16();
    data = i.read(imageSize - 12);
    
		return {
			header: {
        imageFormat: imageFormat,
        imageOrgX: imageOrgX,
        imageOrgY: imageOrgY,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        paletteOrgX:  paletteOrgX,
        paletteOrgY: paletteOrgY,
        clutColorsNum: clutColorsNum,
        clutNum: clutNum
			},
      palettes: palettes,
			image: data
		}
	}

}
