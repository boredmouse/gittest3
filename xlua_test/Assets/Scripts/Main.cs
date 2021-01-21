using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

public class Main : MonoBehaviour
{
    public static Main Instance;



    public Action<float> _luaUpdate = null;

    public Action<float> _luaFixedUpdate = null;

    public Action _luaLateUpdate = null;

    public Action _quit = null;

    private LuaEnv _luaEnv;

    void Awake()
    {
        Instance = this;
        DontDestroyOnLoad(this);
    }
    // Start is called before the first frame update
    void Start()
    {
#if UNITY_EDITOR
        GenLuaClassList.Build();
#endif
        if (_luaEnv != null)
        {
            _luaEnv.Dispose();
            _luaEnv = null;
        }
        _luaEnv = new LuaEnv();
        _luaEnv.AddLoader(Loader);
        _luaEnv.DoString("require 'Main'");

    }

    // Update is called once per frame
    void Update()
    {
        _luaEnv.Tick();
        if (_luaUpdate == null)
        {
            _luaUpdate = _luaEnv.Global.GetInPath<Action<float>>("__G__UPDATE__");
        }
        _luaUpdate(Time.deltaTime);
    }

    void FixedUpdate()
    {
        if (_luaFixedUpdate == null)
        {
            _luaFixedUpdate = _luaEnv.Global.GetInPath<Action<float>>("__G__FIXEDUPDATE__");
        }
        _luaFixedUpdate(Time.fixedDeltaTime);
    }

    void LateUpdate()
    {
        if (_luaLateUpdate == null)
        {
            _luaLateUpdate = _luaEnv.Global.GetInPath<Action>("__G__LATEUPDATE__");
        }
        _luaLateUpdate();
    }

    void OnApplicationQuit()
    {
        if (_luaEnv != null)
        {
            _quit = _luaEnv.Global.GetInPath<Action>("__G__QUIT__");
            _quit();
        }
    }

    byte[] Loader(ref string filePath)
    {
        if (filePath == "emmy_core")
        {
            return null;
        }
        string srcFullPath = Path.GetFullPath("LuaScripts");
        string targetFilePath = string.Format("{0}/{1}", srcFullPath, filePath).Replace('.', '/') + ".lua";
        if (File.Exists(targetFilePath))
        {
            return File.ReadAllBytes(targetFilePath);
        }
        else
        {
            Debug.LogError("FilePath is error:" + targetFilePath);
        }
        return null;
    }
    

}
