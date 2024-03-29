#if defined _l4d2_source_keyvalues_included
 #endinput
#endif
#define _l4d2_source_keyvalues_included

enum /* DataType */
{
	TYPE_NONE = 0,
	TYPE_STRING,
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_PTR,
	TYPE_WSTRING,
	TYPE_COLOR,
	TYPE_UINT64,
	TYPE_NUMTYPES,
}

#define INVALID_KEY_SYMBOL (-1)

// See link for instructions: https://github.com/alliedmodders/hl2sdk/blob/l4d2/public/tier1/KeyValues.h
methodmap SourceKeyValues
{
	public native SourceKeyValues(const char[] name); // Need call deleteThis().
	public native void deleteThis();
	public native void UsesEscapeSequences(bool state);
	public native bool LoadFromFile(const char[] file, const char[] pathID = NULL_STRING);

	public native bool IsNull();
	public native void GetName(char[] name, int maxlength);
	public native void SetName(const char[] setName);
	public native int GetNameSymbol();
	public native any GetDataType(const char[] key);
	public native void GetString(const char[] key, char[] value, int maxlength, const char[] defvalue = "");
	public native void SetString(const char[] key, const char[] value);
	public native void SetStringValue(const char[] value);
	public native int GetInt(const char[] key, int defvalue = 0);
	public native void SetInt(const char[] key, int value);
	public native float GetFloat(const char[] key, float defvalue = 0.0);
	public native void SetFloat(const char[] key, float value);
	public native Address GetPtr(const char[] key, Address defvalue = Address_Null);
	public native SourceKeyValues FindKey(const char[] key, bool bCreate = false);
	public native SourceKeyValues FindKeyFromSymbol(int keySymbol);
	public native SourceKeyValues GetFirstSubKey();
	public native SourceKeyValues GetNextKey();
	public native SourceKeyValues GetFirstTrueSubKey();
	public native SourceKeyValues GetNextTrueSubKey();
	public native SourceKeyValues GetFirstValue();
	public native SourceKeyValues GetNextValue();
	public native bool SaveToFile(const char[] file, const char[] pathID = NULL_STRING);
}

public SharedPlugin __pl_l4d2_source_keyvalues = 
{
	name = "l4d2_source_keyvalues",
	file = "l4d2_source_keyvalues.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_l4d2_source_keyvalues_SetNTVOptional()
{
	MarkNativeAsOptional("SourceKeyValues.SourceKeyValues");
	MarkNativeAsOptional("SourceKeyValues.deleteThis");
	MarkNativeAsOptional("SourceKeyValues.UsesEscapeSequences");
	MarkNativeAsOptional("SourceKeyValues.LoadFromFile");
	MarkNativeAsOptional("SourceKeyValues.IsNull");
	MarkNativeAsOptional("SourceKeyValues.GetName");
	MarkNativeAsOptional("SourceKeyValues.SetName");
	MarkNativeAsOptional("SourceKeyValues.GetNameSymbol");
	MarkNativeAsOptional("SourceKeyValues.GetDataType");
	MarkNativeAsOptional("SourceKeyValues.GetString");
	MarkNativeAsOptional("SourceKeyValues.SetString");
	MarkNativeAsOptional("SourceKeyValues.SetStringValue");
	MarkNativeAsOptional("SourceKeyValues.GetInt");
	MarkNativeAsOptional("SourceKeyValues.SetInt");
	MarkNativeAsOptional("SourceKeyValues.GetFloat");
	MarkNativeAsOptional("SourceKeyValues.SetFloat");
	MarkNativeAsOptional("SourceKeyValues.GetPtr");
	MarkNativeAsOptional("SourceKeyValues.FindKey");
	MarkNativeAsOptional("SourceKeyValues.FindKeyFromSymbol");
	MarkNativeAsOptional("SourceKeyValues.GetFirstSubKey");
	MarkNativeAsOptional("SourceKeyValues.GetNextKey");
	MarkNativeAsOptional("SourceKeyValues.GetFirstTrueSubKey");
	MarkNativeAsOptional("SourceKeyValues.GetNextTrueSubKey");
	MarkNativeAsOptional("SourceKeyValues.GetFirstValue");
	MarkNativeAsOptional("SourceKeyValues.GetNextValue");
	MarkNativeAsOptional("SourceKeyValues.SaveToFile");
}
#endif
