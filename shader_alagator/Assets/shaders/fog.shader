Shader "lesson/fog"
//sorting of shaders in shafr menu
{
    Properties  
  {
  	  _Texture("Texture", 2D) = "black"{}
	  //our Varabile name is _Texture?
	  //our Display name is Texture 
	  //it is a 2D texture 
	  _NormalMap("Normal", 2D) = "black"{}
	//  defuly untextered colour is black
	//uses rbg colour value to create xyz depth to the material 
	//bump map unity this materuak nbeeds to be marked as a normal kmap0 
	// so that it can e used corectly 
	_Colour("Tint", Color) = (0,0,0,0)
	//rgba in the colour, red, green, blue, alpha
	//variable in CG
	_FogColour ("fog colour", Color) = (0,0,0,0)
  }


  //you can have multiple subshaders 
  //these run at different GPU levels on diff platforms
  SubShader
  {
  Tags 
  {
  	  "RenderType" = "Opaque"
  }
  //tags are key value parts, inside a subshader tags are used to detiermine the rendering order 
  //and other paramters of a subshader 
  //rendering tags catergorise shaders into several predeffined groups 


  
  CGPROGRAM //this is the start of our C for Graphics 
  #pragma surface MainColour Lambert  finalcolor:FogColour vertex:Vert
  
  // surface of our modle is affected by the main colour function 
  //the material is a lambert 
  //lamber is a flast shaded material that has no speclar  highlight s / 
  //sampler2D _NormalMap ;
  sampler2D _Texture; 
  //this connects out _texture Varabile that is the the propertys 
  //section to our 2d Texture 
  sampler2D _NormalMap; //connects our normalmap varable from propertys to the _normalmap 
 
	fixed4 _Colour;  
	//reffers to the input _colour in the properites sexrion 
	//fixed 4 is 3 small things
	// height pericerion : Float = 32 bits massive
	//medium percision: half = 16 -6000 to +6000
	//low percission = 11 bits range -2 to +2 
	fixed4 _FogColour; 
 
 struct Input 
  {
  	  float2 uv_Texture; 
	  //this is refferce to our our uv map
	  //uv maps are wrapping of a modle 
	  //used to denore the axes of a 3d object 
	  //structs have semicolens on the end 
	  float2 uv_NormalMap; 
	  //uv map link toi the _NormalMap
	  half fog;
	  
  }; 

  void Vert(inout appdata_full v, out Input data)
  {
  UNITY_INITIALIZE_OUTPUT(Input, data); 
  float4 hpos = UnityObjectToClipPos(v.vertex); 
  hpos.xy /= hpos.w ;
  data.fog = min(1, dot(hpos.xy, hpos.xy) *0.5);
  }

  void FogColour(Input IN, SurfaceOutput o, inout fixed4 colour)
  {
  	  fixed3 fogColour = _FogColour.rgb; 
	  #ifdef UNITY_PASS_FORWARDD
	  fogColour = 0; 
	  #endif 
	  colour.rgb = lerp(colour.rgb, fogColour, IN.fog);
  }

  void MainColour(Input IN, inout SurfaceOutput o)
  {
	o.Albedo = tex2D(_Texture, IN.uv_Texture).rgb *_Colour; 
	//Albedo is in reffernce to the surface image of =our modle 
	// RGB=red green blue duh 
	//we are setting the models surface to the colour of our texture2d 
	//and matching the texture to our modles UV mapping
	o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)); 
	//_normalmap is in reffernce to the bumomao in properites 
	//unoackNormal is requiered because the file is compressed 
	//we nbeed ti decompress and get the true value from the image 
	//bump maps are visibile when light reflects off
	//the light is bounced iff at aflkes accirdung to the image of RGB//XYZ values
	//this creates the illusion of depth
  }
  
  ENDCG //this is the end of our C for Graphics Language
  }
  Fallback "diffuse" //if all else fails standard shader (lambert and texture)
  } 