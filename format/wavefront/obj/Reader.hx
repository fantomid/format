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
	
	public function read() : OBJ {
    var line : String;
    var tools = new format.wavefront.obj.Tools();
    var arrayObj : Array<OBJ> = new Array();
    var vertices : Array<GeometricVertex> = new Array();
    var normals : Array<VertexNormal> = new Array();
    var textures : Array<TextureVertex> = new Array();
    var faces : Array<Face> = new Array();
    var group : GroupName = null;
    var name : ObjectName = null;
    try {
      var bNewObj = false;
      var obj : OBJ = null;
      while(true)
      {
        line = i.readLine();
        var trimLine = StringTools.ltrim(line);
        trimLine = StringTools.rtrim(trimLine);
        if(trimLine.length > 0)
        {
          var objData:Dynamic = tools.decode(trimLine);
          if(objData != null)
          {
            if(objData.type == ODT_GeometricVertex)
              vertices.push(objData);
            else
              if(objData.type == ODT_VertexNormal)
                normals.push(objData);
            else
              if(objData.type == ODT_TextureVertex)
                textures.push(objData);
            else
              if(objData.type == ODT_ElementFace)
                textures.push(objData);
            else
              if(objData.type == ODT_GroupingGroupName)
                group = objData;
            else
              if(objData.type == ODT_GroupingObjectName)
                name = objData;
            else
              trace("Doesn't take care of " + objData.type);
            trace (objData.toString());
          }
        }
      }
    }
    catch(EndOfFile: haxe.io.Eof)
    {
      trace("End of file");
    }

		return {
      group : group,
      name : name,
      vertices : vertices,
      normals : normals,
      textures : textures,
      faces : faces
    };
	}
}
