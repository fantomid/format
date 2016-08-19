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

class Tools {

	static var polygonType_Unknown_00 = 0x00;
	static var polygonType_Flat_Tris_Face_Color = 0x01;
	static var polygonType_Textured_Tris_Face_Color = 0x02;
	static var polygonType_Flat_Quad_Face_Color = 0x03;
	static var polygonType_Textured_Quad_Face_Color = 0x04;
	static var polygonType_Flat_Tris_Vertex_Color = 0x05;
	static var polygonType_Textured_Tris_Vertex_Color = 0x06;
	static var polygonType_Flat_Quad_Vertex_Color = 0x07;
	static var polygonType_Textured_Quad_Vertex_Color = 0x08;
	static var polygonType_Sprite_Top_Anchor = 0x0A;
	static var polygonType_Sprite_Bottom_Anchor = 0x0B;
 
  static public function toPolygonType(polygonType: Int) : PRMPolygonType {
    if(polygonType_Unknown_00 == polygonType)
      return PT_Unknown_00;
    if(polygonType_Flat_Tris_Face_Color == polygonType)
      return PT_FlatTrisFaceColor;
    if(polygonType_Textured_Tris_Face_Color == polygonType)
      return PT_TexturedTrisFaceColor;
    if(polygonType_Flat_Quad_Face_Color == polygonType)
      return PT_FlatQuadFaceColor;
    if(polygonType_Textured_Quad_Face_Color == polygonType)
      return PT_TexturedQuadFaceColor;
    if(polygonType_Flat_Tris_Vertex_Color == polygonType)
      return PT_FlatTrisVertexColor;
    if(polygonType_Textured_Tris_Vertex_Color == polygonType)
      return PT_TexturedTrisVertexColor;
    if(polygonType_Flat_Quad_Vertex_Color == polygonType)
      return PT_FlatQuadVertexColor;
    if(polygonType_Textured_Quad_Vertex_Color == polygonType)
      return PT_TexturedQuadVertexColor;
    if(polygonType_Sprite_Top_Anchor == polygonType)
      return PT_SpriteTopAnchor;
    if(polygonType_Sprite_Bottom_Anchor == polygonType)
      return PT_SpriteBottomAnchor;
    throw "unknown PRM polygon type: " + polygonType;
  }
  
  static public function fromPolygonType(polygonType: PRMPolygonType) : Int {
    if(PT_Unknown_00 == polygonType)
      return polygonType_Unknown_00;
    if(PT_FlatTrisFaceColor == polygonType)
      return polygonType_Flat_Tris_Face_Color;
    if(PT_TexturedTrisFaceColor == polygonType)
      return polygonType_Textured_Tris_Face_Color;
    if(PT_FlatQuadFaceColor == polygonType)
      return polygonType_Flat_Quad_Face_Color;
    if(PT_TexturedQuadFaceColor == polygonType)
      return polygonType_Textured_Quad_Face_Color;
    if(PT_FlatTrisVertexColor == polygonType)
      return polygonType_Flat_Tris_Vertex_Color;
    if(PT_TexturedTrisVertexColor == polygonType)
      return polygonType_Textured_Tris_Vertex_Color;
    if(PT_FlatQuadVertexColor == polygonType)
      return polygonType_Flat_Quad_Vertex_Color;
    if(PT_TexturedQuadVertexColor == polygonType)
      return polygonType_Textured_Quad_Vertex_Color;
    if(PT_SpriteTopAnchor == polygonType)
      return polygonType_Sprite_Top_Anchor;
    if(PT_SpriteBottomAnchor == polygonType)
      return polygonType_Sprite_Bottom_Anchor;
    throw "unknown PRM polygon type: " + polygonType;
  }

}




