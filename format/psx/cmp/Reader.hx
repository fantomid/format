/*
 * format - haXe File Formats
 *
 *  CMP File Format
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
package format.psx.cmp;
import format.psx.cmp.Data;
import format.psx.tim.Data;

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

	public function read() : CMP {

    var timsNum = readInt();
    var depackedFileSize = 0;
    var filesSize = new Array<Int>();
    for(i in 0 ... timsNum)
    {
      filesSize[i] = readInt();
      depackedFileSize += filesSize[i];
    }
      
    var tools = new format.psx.cmp.Tools();
    var outputArray = tools.depackFile(i, filesSize, depackedFileSize);
    
    var tims : Array<TIM> = null;
    if(outputArray.length > 0) 
    {
      tims = new Array<TIM>();
      for(i in 0 ... outputArray.length)
      {
        tims[i] = new format.psx.tim.Reader(new haxe.io.BytesInput(outputArray[i])).read();
        trace("array " + i + " size " + outputArray[i].length);
      }
    }

		return {
      timsNum: timsNum,
      tims: tims
    }
	}

}
