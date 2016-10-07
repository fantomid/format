/*
 * format - haXe File Formats
 *
 *  Wavefront OBJ File Format
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
package format.wavefront.obj;
import format.wavefront.mtl.Data;
import format.wavefront.mtl.Reader;

enum ObjDataType {
	ODT_Unknown;
	ODT_GeometricVertex;
	ODT_VertexNormal;
	ODT_TextureVertex;
  ODT_ParameterSpaceVertex;
	ODT_ElementPoint;
  ODT_ElementLine;
  ODT_ElementFace;
  ODT_ElementCurve;
  ODT_ElementCurve2d;
  ODT_ElementSurface;
	ODT_GroupingGroupName;
  ODT_GroupingSmoothingGroup;
  ODT_GroupingMergingGroup;
  ODT_GroupingObjectName;
  ODT_DisplayRenderAttributesBevelInterpolation;
  ODT_DisplayRenderAttributesColorInterpolation;
  ODT_DisplayRenderAttributesDissolveInterpolation;
  ODT_DisplayRenderAttributesLevelOfDetail;
  ODT_DisplayRenderAttributesMaterialName;
  ODT_DisplayRenderAttributesMaterialLibrary;
  ODT_DisplayRenderAttributesShadowCasting;
  ODT_DisplayRenderAttributesRayTracing;
  ODT_DisplayRenderAttributesCurveApproximationTechnique;
  ODT_DisplayRenderAttributesSurfaceApproximationTechnique;
}

class ObjData
{
  public var type : ObjDataType;
  
  public function toString() {
    return type+" -> ";
  }
  
}

class GeometricVertex extends ObjData {

  var x : Float;
  var y : Float;
  var z : Float;
  var w : Float;
  
  public function new(input: String)
  {
    this.type = ODT_GeometricVertex;
    var array = input.split(" ");
    if(array.length < 4)
      throw "Invalid number of geometric vertex values";
    
    this.x = Std.parseFloat(array[1]);
    this.y = Std.parseFloat(array[2]);
    this.z = Std.parseFloat(array[3]);
    
    this.w = 1.0;
    if(array.length == 5)
      this.w = Std.parseFloat(array[4]);
  }
  
  public override function toString() {
    return super.toString() + "GeometricVertex("+x+", "+y+", "+z+", "+w+")";
  }
}

class VertexNormal extends ObjData {
  var i : Float;
  var j : Float;
  var k : Float;
  
  public function new(input: String)
  {
    this.type = ODT_VertexNormal;
    var array = input.split(" ");
    if(array.length < 4)
      throw "Invalid number of vertex normal values";
    
    this.i = Std.parseFloat(array[1]);
    this.j = Std.parseFloat(array[2]);
    this.k = Std.parseFloat(array[3]);
  }
  
  public override function toString() {
    return super.toString() + "VertexNormal("+i+", "+j+", "+k+")";
  }
}

class TextureVertex extends ObjData {
  var u : Float;
  var v : Float;
  var w : Float;
  
  public function new(input: String)
  {
    this.type = ODT_TextureVertex;
    var array = input.split(" ");
    if(array.length < 2)
      throw "Invalid number of texture vertex values";
    
    this.u = Std.parseFloat(array[1]);
    this.v = 0.0;
    if(array.length >= 3)
      this.v = Std.parseFloat(array[2]);
    
    this.w = 0.0;
    if(array.length == 4)
      this.w = Std.parseFloat(array[3]);
  }
  
  public override function toString() {
    return super.toString() + "TextureVertex("+u+", "+v+", "+w+")";
  }
}

class ParameterSpaceVertex extends ObjData {
  var u : Float;
  var v : Float;
  var w : Float;
  
  public function new(input: String)
  {
    this.type = ODT_ParameterSpaceVertex;
    var array = input.split(" ");
    if(array.length < 2)
      throw "Invalid number of parameter space vertex values";
    
    this.u = Std.parseFloat(array[1]);
    
    this.v = 0.0;
    if(array.length >= 3)
      this.v = Std.parseFloat(array[2]);
    this.w = 1.0;
    if(array.length == 4)
      this.w = Std.parseFloat(array[3]);    
  }
  
  public override function toString() {
    return super.toString() + "ParameterSpaceVertex("+u+", "+v+", "+w+")";
  }
}

class Point extends ObjData {
  
  var points : Array<Int>;
  public function new(input: String)
  {
    this.type = ODT_ElementPoint;
    var array = input.split(" ");
    if(array.length < 2)
      throw "Invalid number of point vertex values";
    points = new Array();
    for(i in 1 ... array.length)
      points[i-1] = Std.parseInt(array[i]);
  }
  
  public override function toString() {
    return super.toString() + "Point( " + points.toString() + " )";
  }
}

class Line extends ObjData {
  
  var lineDesc : Array<String>;
  public function new(input: String)
  {
    this.type = ODT_ElementLine;
    var array = input.split(" ");
    if(array.length < 3)
      throw "Invalid number of line vertex values";
    lineDesc = new Array();
    for(i in 1 ... array.length)
      lineDesc[i] = array[i];    
  }
  
  public override function toString() {
    return super.toString() + "Line( " + lineDesc.toString() + " )";
  }
}

class Face extends ObjData {
  
  var faceDesc : Array<String>;
  public function new(input: String)
  {
    this.type = ODT_ElementFace;
    var array = input.split(" ");
    if(array.length < 4)
      throw "Invalid number of face vertex values";
    faceDesc = new Array();
    for(i in 1 ... array.length)
      faceDesc[i-1] = array[i];
  }
  
  public override function toString() {
    return super.toString() + "Face( " + faceDesc.toString() + " )";
  }
}

class Curve extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_ElementCurve;
  }
  
  public override function toString() {
    return super.toString() + "Curve()";
  }
}

class Curve2d extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_ElementCurve2d;
  }
  
  public override function toString() {
    return super.toString() + "Curve2d()";
  }
}

class Surface extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_ElementSurface;
  }
  
  public override function toString() {
    return super.toString() + "Surface()";
  }
}

class ObjectName extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_GroupingObjectName;
  }
  
  public override function toString() {
    return super.toString() + "ObjectName()";
  }
}

class GroupName extends ObjData {
  
  var groupName : Array<String>;
  public function new(input: String)
  {
    this.type = ODT_GroupingGroupName;
    groupName = input.split(" ");
  }
  
  public override function toString() {
    return super.toString() + "GroupName( "+ groupName.toString() +")";
  }
}

class SmoothingGroup extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_GroupingSmoothingGroup;
  }
  
  public override function toString() {
    return super.toString() + "SmoothingGroup()";
  }
}

class MergingGroup extends ObjData {
  
  public function new(input: String)
  {
    this.type = ODT_GroupingMergingGroup;
  }
  
  public override function toString() {
    return super.toString() + "MergingGroup()";
  }
}
  
class BevelInterpolation  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesBevelInterpolation;
  }
  
  public override function toString() {
    return super.toString() + "BevelInterpolation()";
  }
}
  
class ColorInterpolation  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesColorInterpolation;
  }
  
  public override function toString() {
    return super.toString() + "ColorInterpolation()";
  }
}

class DissolveInterpolation  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesDissolveInterpolation;
  }
  
  public override function toString() {
    return super.toString() + "DissolveInterpolation()";
  }
}

class LevelOfDetail  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesLevelOfDetail;
  }
  
  public override function toString() {
    return super.toString() + "LevelOfDetail()";
  }
}

class MaterialName  extends ObjData {
  var materialName : String;
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesMaterialName;
    var array = input.split(" ");
    if(array.length < 2)
      throw "Invalid number of material name values";    
    materialName = array[1];
  }
  
  public override function toString() {
    return super.toString() + "MaterialName( "+ materialName +" )";
  }
}

class MaterialLibrary  extends ObjData {
  var materialLibraryName : Array<String>;
  var materialLibrary : Array<MTL>;
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesMaterialLibrary;
    var array = input.split(" ");
    if(array.length < 2)
      throw "Invalid number of material library values";
    materialLibraryName = new Array();
    materialLibrary = new Array();
    for(i in 1 ... array.length)
    {
      materialLibraryName[i-1] = array[i];
      /* TODO Return null actually */
      var input_mtl = sys.io.File.read(materialLibraryName[i-1], true);
      if(input_mtl != null)
        materialLibrary[i-1] = new format.wavefront.mtl.Reader(input_mtl).read();

    }
  }
  
  public override function toString() {
    return super.toString() + "MaterialLibrary( "+ materialLibraryName +" )";
  }
}

class ShadowCasting  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesShadowCasting;
  }
  
  public override function toString() {
    return super.toString() + "ShadowCasting()";
  }
}

class RayTracing  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesRayTracing;
  }
  
  public override function toString() {
    return super.toString() + "RayTracing()";
  }
}

class CurveApproximationTechnique  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesCurveApproximationTechnique;
  }
  
  public override function toString() {
    return super.toString() + "CurveApproximationTechnique()";
  }
}

class SurfaceApproximationTechnique  extends ObjData {
  public function new(input: String)
  {
    this.type = ODT_DisplayRenderAttributesSurfaceApproximationTechnique;
  }
  
  public override function toString() {
    return super.toString() + "SurfaceApproximationTechnique()";
  }
}

typedef OBJ = {
  var group : GroupName;
  var name : ObjectName;
  /* TODO var material : MaterialName; */
	var vertices : Array<GeometricVertex>;
  var normals : Array<VertexNormal>;
  var textures : Array<TextureVertex>;
  var faces : Array<Face>;
}

typedef OBJS = {
  var materialLibrary : MaterialLibrary;
  var arrayObj : Array<OBJ>;
}

