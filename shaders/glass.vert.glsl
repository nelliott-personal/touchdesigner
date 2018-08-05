Shader "GLSL shader with refraction mapping" {
   Properties {
      _Cube ("Environment Map", Cube) = "" {}
   }
   SubShader {
      Pass {   
         GLSLPROGRAM
 
         // User-specified uniforms
         uniform samplerCube _Cube;   
 
         // The following built-in uniforms  
         // are also defined in "UnityCG.glslinc", 
         // i.e. one could #include "UnityCG.glslinc" 
         uniform vec3 _WorldSpaceCameraPos; 
            // camera position in world space
         uniform mat4 _Object2World; // model matrix
         uniform mat4 _World2Object; // inverse model matrix
 
         // Varyings         
         varying vec3 normalDirection;
         varying vec3 viewDirection;
 
         #ifdef VERTEX
 
         void main()
         {            
            mat4 modelMatrix = _Object2World;
            mat4 modelMatrixInverse = _World2Object; // unity_Scale.w 
               // is unnecessary because we normalize vectors
 
            normalDirection = normalize(vec3(
               vec4(gl_Normal, 0.0) * modelMatrixInverse));
            viewDirection = vec3(modelMatrix * gl_Vertex 
               - vec4(_WorldSpaceCameraPos, 1.0));
 
            gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
         }
 
         #endif
 
 
         #ifdef FRAGMENT
 
         void main()
         {
            float refractiveIndex = 1.5;
            vec3 refractedDirection = refract(normalize(viewDirection), 
               normalize(normalDirection), 1.0 / refractiveIndex);
            gl_FragColor = textureCube(_Cube, refractedDirection);
         }
 
         #endif
 
         ENDGLSL
      }
   }
}