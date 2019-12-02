Shader "Lesson/Albedo"
//sorting of shaders in shafr menu
{
    Properties  
  {
  	  _Texture("Texture", 2D) = "black"{}
	  //our Varabile name is _Texture?
	  //our Display name is Texture 
	  //it is a 2D texture 
	//  defuly untextered colour is black
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
  #pragma surface MainColour Lambert 
  
  // surface of our modle is affected by the main colour function 
  //the material is a lambert 
  //lamber is a flast shaded material that has no speclar  highlight s / 

  sampler2D _Texture; 
  //this connects out _texture Varabile that is the the propertys 
  //section to our 2d Texture 
  struct Input 
  {
  	  float2 uv_Texture; 
	  //this is refferce to our our uv map
	  //uv maps are wrapping of a modle 
	  //used to denore the axes of a 3d object 
	  //structs have semicolens on the end 
	  
  }; 

  void MainColour(Input IN, inout SurfaceOutput o)
  {
	o.Albedo = tex2D(_Texture, IN.uv_Texture).rgb; 
	//Albedo is in reffernce to the surface image of =our modle 
	// RGB=red green blue duh 
	//we are setting the models surface to the colour of our texture2d 
	//and matching the texture to our modles UV mapping
  }
  
  ENDCG //this is the end of our C for Graphics Language
  }
  Fallback "diffuse" //if all else fails standard shader (lambert and texture)
  } 