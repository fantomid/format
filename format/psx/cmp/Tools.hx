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

class Tools {

  var bitMask: Int;
  var curByte: Int;
  var pos: Int;

	public function new() {
    bitMask = 0;
    curByte = 0;
    pos = 0;
	}
  
  private function readBitfield(src: haxe.io.BytesInput, bitfieldSize: Int) : Int {
    var curValue = 0;

    while (bitfieldSize > 0) 
    {
      if (bitMask == 0x80) 
      {
        curByte = src.readInt8();
        pos++;
      }

      if ((curByte & bitMask) != 0) 
      {
        curValue |= bitfieldSize;
      }

      bitfieldSize >>= 1;

      bitMask >>= 1;
      if (bitMask == 0) 
      {
        bitMask = 0x80;
      }
    }
    return curValue;  
  }

  public function packFile(src: haxe.io.Bytes) : haxe.io.Output {
    // TODO, parameters must be changed
    throw "Not implemented";

    var outputBuffer = new haxe.io.BytesOutput();
    outputBuffer.prepare(src.length);    
    
    return null;
  }
  
  public function depackFile(src: haxe.io.Input, filesSize: Array<Int>, depackedFileSize: Int) : Array<haxe.io.Bytes> {
  
    var input = new haxe.io.BytesInput(src.readAll()); // Entire file in buffer
    var dstPos: Int = 0;
    var tmp8K = haxe.io.Bytes.alloc(8*1024); // 8K circular buffer
    var tmp8Kpos = 0;
    var curBit = 0;
    var curValue = 0;
    var dstBuffer = new haxe.io.BytesOutput();
    dstBuffer.prepare(depackedFileSize);
    
    bitMask = 0x80;
    curByte = 0;
    tmp8Kpos = 1;
    
    while(true)
    {
      if ((pos>input.length) || (dstPos>depackedFileSize)) 
      {
        break;      
      }
      if (bitMask == 0x80) 
      {
        curByte = input.readInt8();
        pos++;
      }
      
      curBit = (curByte & bitMask);
      bitMask >>= 1;
      if (bitMask == 0) 
      {
        bitMask = 0x80;
      }
      
      if (curBit != 0) 
      {
        curValue = readBitfield(input, 0x80);
        tmp8K.set((tmp8Kpos & 0x1fff), curValue);
        dstBuffer.writeByte(curValue);
        tmp8Kpos++;
        dstPos++;
      } 
      else 
      {
        var position = 0;
        var length = 0;

        position = readBitfield(input, 0x1000);
        if (position == 0) 
        {
          break;
        }
        else
        {
          length = readBitfield(input, 0x08)+2;
          for (i in 0 ... length+1) 
          {
            curValue = tmp8K.get(((i + position) & 0x1fff));
            tmp8K.set((tmp8Kpos & 0x1fff), curValue);
            dstBuffer.writeByte(curValue);
            tmp8Kpos++;
            dstPos++;
          }
        }
      }
    }
    
    var outputArray = new Array<haxe.io.Bytes>();
    var outputBytes = dstBuffer.getBytes();
    var offset = 0;
    for(i in 0 ... filesSize.length)
    {
      var tim = outputBytes.sub(offset, filesSize[i]);
      offset = filesSize[i];
      
      outputArray[i] = tim;
    }
    return outputArray;
  }
}




