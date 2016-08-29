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

enum PRMPolygonType {
	PT_Unknown_00;
	PT_FlatTrisFaceColor;
	PT_TexturedTrisFaceColor;
	PT_FlatQuadFaceColor;
	PT_TexturedQuadFaceColor;
	PT_FlatTrisVertexColor;
	PT_TexturedTrisVertexColor;
	PT_FlatQuadVertexColor;
	PT_TexturedQuadVertexColor;
	PT_SpriteTopAnchor;
	PT_SpriteBottomAnchor;
}

typedef PRM = {
  var objectsNum : Int;
  var objects : Array<Object>;
}

class Object {
  var header : ObjectHeader;
  var vertices : Array<Vertex>;
  var polygons : Array<Polygon>;
  
  public function new(input: haxe.io.Input)
  {
    this.header = new ObjectHeader(input);
    var num_vertices = header.vertexCount;
    if(num_vertices > 0)
      vertices = new Array();
    for(i in 0...num_vertices)
    {
      var v = new Vertex(input);
      vertices.push(v);
    }
    this.polygons = null;
  }
  
  public function toString() {
    return "vertrices " + header.vertexCount +
      " polygons " + header.polygonCount +
      " array vertrices count " + vertices.length;
  }  
}

class Polygon
{
  var header : PolygonHeader;
}

class UnknownPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('unknown', Struct.uint16(), 7)
*/
  var unknown : haxe.io.Bytes; // array of 7 unknown UInt16
  // = 7 UInt16
} 

class FlatTrisFaceColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 3),
	Struct.uint16('unknown'),
	Struct.uint32('color')
*/
  var indices : Array<Int>; // 3 UInt16
  var unknown : haxe.io.Bytes; // 1 unknown UInt16
  var color : Int; // UInt32
  // = 6 UInt16
}

class TexturedTrisFaceColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 3),
	Struct.uint16('texture'),
	Struct.array('unknown', Struct.uint16(), 2), // 4
	Struct.array('uv', Wipeout.UV, 3), // 6
	Struct.array('unknown2', Struct.uint16(), 1),
	Struct.uint32('color')
*/
  var indices : Array<Int>; // 3 UInt16
  var texture : Int;
  var unknown : haxe.io.Bytes; // 2 unknown UInt16
  var uv : Array<TexUV>; // 3 TexUV
  // = 14 UInt16
}

class FlatQuadFaceColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 4),
	Struct.uint32('color')
*/
  // = 6 UInt16
}

class TexturedQuadFaceColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 4),
	Struct.uint16('texture'),
	Struct.array('unknown', Struct.uint16(), 2),
	Struct.array('uv', Wipeout.UV, 4),
	Struct.array('unknown2', Struct.uint16(), 1),
	Struct.uint32('color')
*/
  // = 14 UInt16
}

class FlatTrisVertexColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 3),
	Struct.uint16('unknown'),
	Struct.array('colors',Struct. uint32(), 3)
*/
  // = 10 UInt16
}

class TexturedTrisVertexColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 3),
	Struct.uint16('texture'),
	Struct.array('unknown', Struct.uint16(), 2), // 4
	Struct.array('uv', Wipeout.UV, 3), // 6
	Struct.array('unknown2', Struct.uint16(), 1),
	Struct.array('colors', Struct.uint32(), 3) // ?
*/
  // = 16 UInt16
}

class FlatQuadVertexColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 4),
	Struct.array('colors', Struct.uint32(), 4)
*/
  // = 12 UInt16
}

class TexturedQuadVertexColorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.array('indices', Struct.uint16(), 4),
	Struct.uint16('texture'),
	Struct.array('unknown', Struct.uint16(), 2),
	Struct.array('uv', Wipeout.UV, 4),
	Struct.array('unknown2', Struct.uint8(), 2),
	Struct.array('colors', Struct.uint32(), 4)
*/
 // = 20 UInt16
}

class SpriteTopAnchorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.uint16('index'),
	Struct.uint16('width'),
	Struct.uint16('height'),
	Struct.uint16('texture'),
	Struct.uint32('color')
*/
  // = 6 UInt16
}
	
class SpriteBottomAnchorPolygon extends Polygon
{
/*
	Struct.struct('header', Wipeout.PolygonHeader),
	Struct.uint16('index'),
	Struct.uint16('width'),
	Struct.uint16('height'),
	Struct.uint16('texture'),
	Struct.uint32('color')
*/
  // = 6 UInt16
}

class Vector3 {
/*
	Struct.int32('x'),
	Struct.int32('y'),
	Struct.int32('z')
*/
  var x : Int;
  var y : Int;
  var z : Int;
  
  public function new(input: haxe.io.Input)
  {
    this.x = Tools.readInt(input);
    this.y = Tools.readInt(input);
    this.z = Tools.readInt(input);
  }

  public function toString() {
    return "Vector3("+x+","+y+","+z+")";
  }  
}

class Vertex {
/*
	Struct.int16('x'),
	Struct.int16('y'),
	Struct.int16('z'),
	Struct.int16('padding')
*/
  var x : Int; // Int16
  var y : Int; // Int16
  var z : Int; // Int16
  var padding : Int; // Int16
  
  public function new(input: haxe.io.Input)
  {
    this.x = input.readInt16();
    this.y = input.readInt16();
    this.z = input.readInt16();
    this.padding = input.readInt16();
  }
  
  public function toString() {
    return "Vertex("+x+","+y+","+z+")";
  }  
}

class TexUV {
/*
	Struct.uint8('u'),
	Struct.uint8('v')
*/
  var u : Int;
  var v : Int;
  
  public function new(input: haxe.io.Input)
  {
    this.u = input.readByte();
    this.v = input.readByte();
  }
  
  public function toString() {
    return "UV("+u+","+v+")";
  }  
}

class ObjectHeader {
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
  public var name(default, null): haxe.io.Bytes;
  var skip1: Int;
  public var vertexCount(default, null): Int;
  var skip14: haxe.io.Bytes;
  public var polygonCount(default, null): Int;
  var skip20: haxe.io.Bytes;
  public var index1(default, null): Int;
  var skip28: haxe.io.Bytes;
  public var origin(default, null): Vector3;
  var skip20b: haxe.io.Bytes;
  public var position(default, null): Vector3;
  var skip16: haxe.io.Bytes;
  
  public function new(input: haxe.io.Input)
  {
    this.name = input.read(Tools.s_ObjectNameNbBytes);
    this.skip1 = input.readByte();
    this.vertexCount = input.readUInt16();
    this.skip14 = input.read(14);
    this.polygonCount = input.readUInt16();
    this.skip20 = input.read(20);
    this.index1 = input.readUInt16();
    this.skip28 = input.read(28);
    this.origin = new Vector3(input);
    this.skip20b = input.read(20);
    this.position = new Vector3(input);
    this.skip16  = input.read(16);
  }
}

typedef PolygonHeader = {
/*
	Struct.uint16('type'),
	Struct.uint16('subtype')
*/
  var type : Int; 
	var subtype : Int;
}
