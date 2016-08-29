/*
 * format - haXe File Formats
 *
 *  PRM File Format
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
package format.psx.prm;
import format.psx.prm.Data;
import format.psx.prm.Tools;

class Reader {

	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
		i.bigEndian = true;
	}
	
	inline function readInt() {
		#if haxe3
		return i.readInt32();
		#else
		return i.readUInt30();
		#end
	}
	
	public function read() : PRM {

    var objectsNum = 0;
    var objects : Array<Object> = new Array();
    try {
      /*while(true)
      {*/
        var object : Object = new Object(i);
        objects.push(object);
        objectsNum++;
      //}
      trace(object.toString());
    }
    catch(EndOfFile: haxe.io.Eof)
    {
      
    }
/*
	Struct.string('name', 15),
	Struct.skip(1),
	Struct.uint16('vertexCount'),
	Struct.skip(14),
	Struct.uint16('polygonCount'),
	Struct.skip(20),
	Struct.uint16('index1'),
	Struct.skip(28),
	Struct.struct('origin', Wipeout.Vector3),
	Struct.skip(20),
	Struct.struct('position', Wipeout.Vector3),
	Struct.skip(16)
*/
  var name : String;
  var skip1: haxe.io.Bytes;
  var vertexCount : Int;
  var skip14: haxe.io.Bytes;
  var polygonCount : Int;
  var skip20: haxe.io.Bytes;
  var index1 : Int;
  var skip28: haxe.io.Bytes;
  var origin : Vector3;
  var skip20b: haxe.io.Bytes;
  var position : Vector3;
  var skip16: haxe.io.Bytes;    
/*
	var initialOffset = offset;

	var header = Wipeout.ObjectHeader.readStructs(buffer, offset, 1)[0];
	offset += Wipeout.ObjectHeader.byteLength;
	
	var vertices = Wipeout.Vertex.readStructs(buffer, offset, header.vertexCount);
	offset += Wipeout.Vertex.byteLength * header.vertexCount;

	var polygons = [];
	for( var i = 0; i < header.polygonCount; i++ ) {
		// Peek into the header first to select the right Polygon type
		var polygonHeader = Wipeout.PolygonHeader.readStructs(buffer, offset, 1)[0];

		var PolygonType = Wipeout.Polygon[polygonHeader.type];
		var polygon = PolygonType.readStructs(buffer, offset, 1)[0];
		offset += PolygonType.byteLength;

		polygons.push(polygon);
*/    

		return {
      objectsNum: objectsNum,
      objects: objects
    }
	}

}
