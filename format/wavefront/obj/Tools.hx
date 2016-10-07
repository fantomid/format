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
import format.wavefront.obj.Data;

class Tools {
    var objsMap : Map<String, String -> ObjData>;
    var decodeVertexDataStrings : Array<String> = ["vp", "vn", "vt", "v"];
    var decodeElementsStrings : Array<String> = ["curv2", "curv", "surf", "f", "l", "p"];
    var decodeGroupingStrings : Array<String> = ["mg", "g", "o", "s"];
    var decodeDisplayOrRenderAttributesStrings : Array<String> = ["shadow_obj", "trace_obj", "c_interp", "d_interp", "usemtl", "mtllib", "bevel", "ctech", "stech", "lod"];
	public function new() {
    objsMap = new Map();
    // Vertex datas
    objsMap.set("v", createGeometricVertex);
    objsMap.set("vp", createParameterSpaceVertex);
    objsMap.set("vn", createVertexNormal);
    objsMap.set("vt", createTextureVertex);

    // Elements
    objsMap.set("curv2", createCurve2d);
    objsMap.set("curv", createCurve);
    objsMap.set("surf", createSurface);
    objsMap.set("f", createFace);
    objsMap.set("l", createLine);
    objsMap.set("p", createPoint);
    
    // Grouping
    objsMap.set("mg", createMergingGroup);
    objsMap.set("g", createGroupName);
    objsMap.set("o", createObjectName);
    objsMap.set("s", createSmoothingGroup);
    
    // Display or render attributes
    objsMap.set("shadow_obj", createShadowCasting);
    objsMap.set("trace_obj", createRayTracing);
    objsMap.set("c_interp", createColorInterpolation);
    objsMap.set("d_interp", createDissolveInterpolation);
    objsMap.set("usemtl", createMaterialName);
    objsMap.set("mtllib", createMaterialLibrary);
    objsMap.set("bevel", createBevelInterpolation);
    objsMap.set("ctech", createCurveApproximationTechnique);
    objsMap.set("stech", createSurfaceApproximationTechnique);
    objsMap.set("lod", createLevelOfDetail);
  }

  public function decode(data: String) : ObjData
  {
    var objData = decodeGrouping(data);
    if(objData == null)
    {
      objData = decodeDisplayOrRenderAttributes(data);
      if(objData == null)
      {
        objData = decodeVertexData(data);
        if(objData == null)
          objData = decodeElements(data);
      }
    }
      
    return objData;
  }
  
  private function createObjData(objId: String, data: String) : ObjData
  {
    var objData : ObjData = null;
    var fctCreate : String -> ObjData = objsMap.get(objId);
    if(fctCreate != null)
      objData = fctCreate (data);
    return objData;
  }
  
  private function decodeVertexData(data: String) : ObjData
  {
    var objData : ObjData = null;
    for(idx in 0 ... decodeVertexDataStrings.length)
    {
      if(StringTools.startsWith(data, decodeVertexDataStrings[idx]))
      {
        objData = createObjData(decodeVertexDataStrings[idx], data);
        break;
      }
    }

    return objData;
  }

  private function decodeGrouping(data: String) : ObjData
  {
    var objData : ObjData = null;
    for(idx in 0 ... decodeGroupingStrings.length)
    {
      if(StringTools.startsWith(data, decodeGroupingStrings[idx]))
      {
        objData = createObjData(decodeGroupingStrings[idx], data);
        break;
      }
    }

    return objData;
  }
  
  private function decodeElements(data: String) : ObjData
  {
    var objData : ObjData = null;
    for(idx in 0 ... decodeElementsStrings.length)
    {
      if(StringTools.startsWith(data, decodeElementsStrings[idx]))
      {
        objData = createObjData(decodeElementsStrings[idx], data);
        break;
      }
    }    
    
    return objData;
  }
  
  private function decodeDisplayOrRenderAttributes(data: String) : ObjData
  {
    var objData : ObjData = null;
    for(idx in 0 ... decodeDisplayOrRenderAttributesStrings.length)
    {
      if(StringTools.startsWith(data, decodeDisplayOrRenderAttributesStrings[idx]))
      {
        objData = createObjData(decodeDisplayOrRenderAttributesStrings[idx], data);
        break;
      }
    }    
    
    return objData;
  }
  
  private function createGeometricVertex(data: String) : GeometricVertex
  {
    return new GeometricVertex(data);
  }
  
  private function createParameterSpaceVertex(data: String) : ObjData
  {
    return new ParameterSpaceVertex(data);
  }
  
  private function createVertexNormal(data: String) : VertexNormal
  {
    return new VertexNormal(data);
  }
  
  private function createTextureVertex(data: String) : TextureVertex
  {
    return new TextureVertex(data);
  }
  
  private function createSmoothingGroup(data: String) : ObjData
  {
    return new SmoothingGroup(data);
  }
  
  private function createObjectName(data: String) : ObjData
  {
    return new ObjectName(data);
  }

  private function createGroupName(data: String) : ObjData
  {
    return new GroupName(data);
  }

  private function createMergingGroup(data: String) : ObjData
  {
    return new MergingGroup(data);
  }
  
  private function createPoint(data: String) : ObjData
  {
    return new Point(data);
  }
  
  private function createLine(data: String) : ObjData
  {
    return new Line(data);
  }
  
  private function createFace(data: String) : ObjData
  {
    return new Face(data);
  } 

  private function createSurface(data: String) : ObjData
  {
    return new Surface(data);
  } 

  private function createCurve(data: String) : ObjData
  {
    return new Curve(data);
  }
  
  private function createCurve2d(data: String) : ObjData
  {
    return new Curve2d(data);
  }
  
  private function createNotImplemented(data: String) : ObjData
  {
    throw "Not implemented";
    return null;
  }
  
  private function createBevelInterpolation(data: String) : ObjData
  {
    return new BevelInterpolation(data);
  }
  
  private function createColorInterpolation(data: String) : ObjData
  {
    return new ColorInterpolation(data);
  }
  
  private function createDissolveInterpolation(data: String) : ObjData
  {
    return new DissolveInterpolation(data);
  }

  private function createLevelOfDetail(data: String) : ObjData
  {
    return new LevelOfDetail(data);
  }

  private function createMaterialName(data: String) : ObjData
  {
    return new MaterialName(data);
  }
  
  private function createMaterialLibrary(data: String) : ObjData
  {
    return new MaterialLibrary(data);
  }
  
  private function createShadowCasting(data: String) : ObjData
  {
    return new ShadowCasting(data);
  } 

  private function createRayTracing(data: String) : ObjData
  {
    return new RayTracing(data);
  }

  private function createCurveApproximationTechnique(data: String) : ObjData
  {
    return new CurveApproximationTechnique(data);
  }   

  private function createSurfaceApproximationTechnique(data: String) : ObjData
  {
    return new SurfaceApproximationTechnique(data);
  }   
}




