using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

public static class GenLuaClassList 
{
#if UNITY_EDITOR
    [MenuItem("Tools/GenLuaClassList", false, 100)]
    public static void Build()
    {
        var src = Path.GetFullPath("LuaScripts") + "/";
        var files = Directory.GetFiles(src, "*.lua", SearchOption.AllDirectories);
        //Debug.Log("File Count = " + files[0]);
        var builder = new StringBuilder();
        builder.AppendLine("-------------------------------------------------------------------------------");
        builder.AppendLine("--");
        builder.AppendLine("-- 这个文件是所有的功能模块对应的lua文件列表 ");
        builder.AppendLine("-- 由工具自动生成,请勿手工修改");
        builder.AppendLine("--");
        builder.AppendLine("-------------------------------------------------------------------------------");
        builder.AppendLine();
        builder.AppendLine("LuaClassList = ");
        builder.AppendLine("{");

        var tipBuilder = new StringBuilder();
        tipBuilder.AppendLine("---@class LuaClass");


        var datatableExt = new List<string>();
        for (int i = 0; i < files.Length; i++)
        {
            
            var fileName = Path.GetFileNameWithoutExtension(files[i]);
            var lowName = fileName.ToLower();
            var filePath = files[i].Replace(".lua", "").Replace(src, "").Replace("\\", ".");
            builder.AppendFormat("    {0} = \"{1}\",\n", lowName, filePath);

            if (lowName.EndsWith("datatableextension"))
            {
                datatableExt.Add(lowName);
            }

            tipBuilder.AppendFormat("---@field {0} {0}\n", fileName);
        }
        builder.AppendLine("}");
        builder.AppendLine();

        tipBuilder.AppendLine("local LuaClass = {}");

        builder.AppendLine("DatatableExtension = ");
        builder.AppendLine("{");
        for (int i = 0; i < datatableExt.Count; i++)
        {
            builder.AppendFormat("    {0} = LuaClassList.{1},\n", datatableExt[i], datatableExt[i]);
        }
        builder.AppendLine("}");
        builder.AppendLine();

        builder.AppendLine("LuaClass = {}");

        File.WriteAllText(src + "Core/LuaClassList.lua", builder.ToString());
        File.WriteAllText(src + "Core/LuaClassTips.lua", tipBuilder.ToString()); 

        Debug.Log("GenLuaClassList 操作完成");
    }
#endif
}
