/*
 * format - haXe File Formats
 *
 *  TIM File Format
 *  Copyright (C) 2009 Guillaume Gasnier
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

class Writer {

	var o : haxe.io.Output;

	public function new(output : haxe.io.Output) {
		o = output;
		o.bigEndian = false;
	}

	public function write(tim : TIM) {
    var magicNumber = Tools.magicNumber;
    var format = Tools.fromImageFormat(tim.header.imageFormat);
    
    writeInt(magicNumber);
    writeInt(format);
    if(TF_Paletted_4_BPP == tim.header.imageFormat 
      || TF_Paletted_8_BPP == tim.header.imageFormat) {
      
      var clutSize = tim.palettes.length + 12;
      writeInt(clutSize);
      o.writeUInt16(tim.header.paletteOrgX);
      o.writeUInt16(tim.header.paletteOrgY);
      o.writeUInt16(tim.header.clutColorsNum);
      o.writeUInt16(tim.header.clutNum);
      o.write(tim.palettes);
    }
    
    var imageSize = tim.image.length + 12;
    writeInt(imageSize);
    o.writeUInt16(tim.header.imageOrgX);
    o.writeUInt16(tim.header.imageOrgY);
    
    var imageWidth = tim.header.imageWidth;
    if(TF_Paletted_4_BPP == tim.header.imageFormat)
      imageWidth = Std.int(imageWidth / 4);
    if(TF_Paletted_8_BPP == tim.header.imageFormat)
      imageWidth = Std.int( imageWidth / 2);
    // case TF_TrueColor_16_BPP - imageWidth is already correct
    // case TF_TrueColor_24_BPP - TODO when supported
    o.writeUInt16(imageWidth);
    o.writeUInt16(tim.header.imageHeight);
    o.write(tim.image);
	}
	
 
	inline function writeInt( v : Int ) {
		#if haxe3
		o.writeInt32(v);
		#else
		o.writeUInt30(v);
		#end
	}

}
