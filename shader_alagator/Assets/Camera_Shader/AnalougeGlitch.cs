
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
[AddComponentMenu("iMAGE eFFECTS/aNALOGUE gLITCH")]
public class AnalougeGlitch : MonoBehaviour
{

    #region Public Properties 
    //scanline jiutter 
    [SerializeField, Range(0, 1)]
    float _scanLineJitter;
    public float ScanLineJitter
    {
    get {return  _scanLineJitter;}
    set {  _scanLineJitter = value;} 
    }
    //vert jump 
    [SerializeField, Range(0, 1)]
    float _verticalJump;
public float VerticalJump
{
    get { return _verticalJump; }
    set { _verticalJump = value; }
}


//horizontal shake 
[SerializeField, Range(0, 1)]
float _horizontalShake;
    public float HorizontalShake
{
    get { return _horizontalShake; }
    set { _horizontalShake = value; }
}

//color drift
[SerializeField, RangeAttribute (0,1)]
    float _colorDrift;
    public float ColorDrift
{
    get { return _colorDrift; }
    set { _colorDrift = value; }
}





#endregion

#region Private Properties 
[SerializeField]
Shader _shader;
Material _material;
float _verticalJumpTime;


#endregion

    #region MonoBehavior Functions 
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }

        float sl_thresh = Mathf.Clamp01(1 - _scanLineJitter * 1.2f);
        float sl_disp = 0.002f + Mathf.Pow(_scanLineJitter, 3) * 0.05f;

        Vector2 vj = new Vector2(_verticalJump, _verticalJumpTime);
        _verticalJumpTime += Time.deltaTime * _verticalJump * 11.3f;

        _material.SetVector("_ScanLineJitter", new Vector2(sl_disp, sl_thresh));

        _material.SetVector("_VerticalJump", vj);

        _material.SetFloat("_HorizontalShake", _horizontalShake * 0.2F);

        Vector2 cd = new Vector2(_colorDrift * 0.04f, Time.time * 606.11f);
        _material.SetVector("_ColorDrift", cd);
        Graphics.Blit(source, destination, _material);

    }
#endregion


}
