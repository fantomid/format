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
import format.psx.prm.Tools;

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
    var num_polygons = header.polygonCount;
    if(num_polygons > 0)
      polygons = new Array();
    trace("number of polygons " + num_polygons);
    for(i in 0...num_polygons)
    {
      var header = new PolygonHeader(input);
      var polygon = Tools.createPolygonFrom(header, input);
      polygons.push(polygon);
    }
  }
  
  public function toString() {
    return "vertices " + header.vertexCount +
      " polygons " + header.polygonCount +
      " array vertices count " + vertices.length;
  }  
}

class Polygon
{
  var header : PolygonHeader;
}

class UnknownPolygon extends Polygon
{
  var unknown : haxe.io.Bytes; // 7 unknown UInt16

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.unknown = input.read(14);
  }
} 

class FlatTrisFaceColorPolygon extends Polygon
{
  var indices : Array<Int>; // 3 UInt16
  var unknown : haxe.io.Bytes; // 1 unknown UInt16
  var color : Int; // 1 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 3)
    {
      this.indices[i] = input.readUInt16();
    }    
    this.unknown = input.read(2);
    this.color = Tools.readInt(input);
  }  
}

class TexturedTrisFaceColorPolygon extends Polygon
{
  var indices : Array<Int>; // 3 UInt16
  var texture : Int; // 1 UInt16
  var unknown : haxe.io.Bytes; // 2 unknown UInt16
  var uv : Array<TexUV>; // 3 TexUV
  var unknown2 : haxe.io.Bytes; // 1 unknown UInt16
  var color : Int; // 1 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 3)
    {
      this.indices[i] = input.readUInt16();
    }
    this.texture = input.readUInt16();
    this.unknown = input.read(4);
    this.uv = new Array();
    for(i in 0 ... 3)
    {
      this.uv[i] = new TexUV(input);
    }
    this.unknown2 = input.read(2);
    this.color = Tools.readInt(input);
  }
}

class FlatQuadFaceColorPolygon extends Polygon
{
  var indices : Array<Int>; // 4 UInt16
  var color : Int; // 1 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 4)
    {
      this.indices[i] = input.readUInt16();
    }
    this.color = Tools.readInt(input);
  }
}

class TexturedQuadFaceColorPolygon extends Polygon
{
  var indices : Array<Int>; // 4 UInt16
  var texture : Int; // 1 UInt16
  var unknown : haxe.io.Bytes; // 2 unknown UInt16
  var uv : Array<TexUV>; // 4 TexUV
  var unknown2 : haxe.io.Bytes; // 1 unknown UInt16
  var color : Int; // UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 4)
    {
      this.indices[i] = input.readUInt16();
    }
    this.texture = input.readUInt16();
    this.unknown = input.read(4);
    this.uv = new Array();
    for(i in 0 ... 4)
    {
      this.uv[i] = new TexUV(input);
    }
    this.unknown2 = input.read(2);
    this.color = Tools.readInt(input);
  }
}

class FlatTrisVertexColorPolygon extends Polygon
{
  var indices : Array<Int>; // 3 UInt16
  var unknown : haxe.io.Bytes; // 1 unknown UInt16
  var colors : Array<Int>; // 3 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 3)
    {
      this.indices[i] = input.readUInt16();
    }
    this.unknown = input.read(2);
    this.colors = new Array();
    for(i in 0 ... 3)
    {
      this.colors[i] = Tools.readInt(input);
    }
  }
}

class TexturedTrisVertexColorPolygon extends Polygon
{
  var indices : Array<Int>; // 3 UInt16
  var texture : Int; // 1 UInt16
  var unknown : haxe.io.Bytes; // 2 unknown UInt16
  var uv : Array<TexUV>; // 3 TexUV
  var unknown2 : haxe.io.Bytes; // 1 Unknown UInt16
  var colors : Array<Int>; // 3 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 3)
    {
      this.indices[i] = input.readUInt16();
    }
    this.texture = input.readUInt16();
    this.unknown = input.read(4);
    this.uv = new Array();
    for(i in 0 ... 3)
    {
      this.uv[i] = new TexUV(input);
    }
    this.unknown2 = input.read(2);
    this.colors = new Array();
    for(i in 0 ... 3)
    {
      this.colors[i] = Tools.readInt(input);
    }
  }
}

class FlatQuadVertexColorPolygon extends Polygon
{
  var indices : Array<Int>; // 4 UInt16
  var colors : Array<Int>; // 4 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 4)
    {
      this.indices[i] = input.readUInt16();
    }
    this.colors = new Array();
    for(i in 0 ... 4)
    {
      this.colors[i] = Tools.readInt(input);
    }
  }
}

class TexturedQuadVertexColorPolygon extends Polygon
{
  var indices : Array<Int>; // 4 UInt16
  var texture : Int; // 1 UInt16
  var unknown : haxe.io.Bytes; // 2 unknown UInt16
  var uv : Array<TexUV>; // 4 TexUV
  var unknown2 : haxe.io.Bytes; // 2 unknown UInt8
  var colors : Array<Int>; // 4 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.indices = new Array();
    for(i in 0 ... 4)
    {
      this.indices[i] = input.readUInt16();
    }
    this.texture = input.readUInt16();
    this.unknown = input.read(4);
    this.uv = new Array();
    for(i in 0 ... 4)
    {
      this.uv[i] = new TexUV(input);
    }
    this.unknown2 = input.read(2);
    this.colors = new Array();
    for(i in 0 ... 4)
    {
      this.colors[i] = Tools.readInt(input);
    }
  }
}

class SpriteTopAnchorPolygon extends Polygon
{
	var index : Int; // 1 UInt16
	var width : Int; // 1 UInt16
	var height : Int; // 1 UInt16
	var texture : Int; // 1 UInt16
	var color : Int; // 1 UInt32

  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    this.header = header;
    this.index = input.readUInt16();
    this.width = input.readUInt16();
    this.height = input.readUInt16();
    this.texture = input.readUInt16();
    this.color = Tools.readInt(input);
  }
}
	
class SpriteBottomAnchorPolygon extends SpriteTopAnchorPolygon
{
  public function new(header: PolygonHeader, input: haxe.io.Input)
  {
    super(header, input);
  }
}

class Vector3 {

  var x : Int; // Int32
  var y : Int; // Int32
  var z : Int; // Int32
  
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

  var u : Int; // UInt8
  var v : Int; // UInt8
  
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
  public var name(default, null): haxe.io.Bytes; // 15 bytes
  var skip1: Int; // 1 byte
  public var vertexCount(default, null): Int; // 1 UInt16
  var skip14: haxe.io.Bytes; // 14 bytes
  public var polygonCount(default, null): Int; // 1 UInt16
  var skip20: haxe.io.Bytes; // 20 bytes
  public var index1(default, null): Int; // 1 UInt16
  var skip28: haxe.io.Bytes; // 28 bytes
  public var origin(default, null): Vector3;
  var skip20b: haxe.io.Bytes; // 20 bytes
  public var position(default, null): Vector3;
  var skip16: haxe.io.Bytes; // 16 bytes
  
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

class PolygonHeader {

  public var type(default, null) : Int; // UInt16
	public var subtype(default, null) : Int; // UInt16
  
  public function new(input: haxe.io.Input)
  {
    this.type = input.readUInt16();
    this.subtype = input.readUInt16();
  }
}
