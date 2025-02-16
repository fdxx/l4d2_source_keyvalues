#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <l4d2_source_keyvalues>

Address
	g_pMatchExtL4D;

Handle
	g_hSDKGetAllMissions,
	g_hSDKGetAllModes,
	g_hSDKGetGameModeInfo;

public void OnPluginStart()
{
	Init();
	RegAdminCmd("sm_skv_test1", Cmd_Test1_PrintAllKeyValues, ADMFLAG_ROOT);
	RegAdminCmd("sm_skv_test2", Cmd_Test2_PrintTrueSubKeyName, ADMFLAG_ROOT);
	RegAdminCmd("sm_skv_test3", Cmd_Test3_PrintTrueValue, ADMFLAG_ROOT);
	RegAdminCmd("sm_skv_test4", Cmd_Test4_OtherTest, ADMFLAG_ROOT);
	RegAdminCmd("sm_skv_test5", Cmd_Test5, ADMFLAG_ROOT);
}

Action Cmd_Test5(int client, int args)
{
	
	SourceKeyValues kv = SourceKeyValues("test5");
	kv.SetString("key1", "value1");
	kv.SetString("key2", "value2");
	kv.SetString("key3", "val\\nue3");

	char buffer[256];
	kv.GetString("key3", buffer, sizeof(buffer));
	PrintToServer("key3Value = %s", buffer);

	SourceKeyValues key2 = kv.FindKey("key2");
	int keySymbol = key2.GetNameSymbol();
	PrintToServer("key2 keySymbol = %i", keySymbol);

	BuildPath(Path_SM, buffer, sizeof(buffer), "data/test5.txt");
	if (kv.SaveToFile(buffer))
		PrintToServer("Save to file succeeded: %s", buffer);

	kv.deleteThis();

	
	kv = SourceKeyValues("");
	kv.UsesEscapeSequences(true);
	if (kv.LoadFromFile(buffer))
	{
		kv.GetString("key3", buffer, sizeof(buffer));
		PrintToServer("key3Value = %s", buffer); // \n test

		kv.SetString("key4/key4sub", "key4Value");
		
		key2 = kv.FindKeyFromSymbol(keySymbol); 
		key2.GetString(NULL_STRING, buffer, sizeof(buffer));
		PrintToServer("key2Value = %s", buffer);
	}

	kv.deleteThis();


	kv = SourceKeyValues("");
	if (kv.LoadFromFile("scripts/melee/melee_manifest.txt", "GAME")) // valve path
	{
		PrintAllKeyValues(kv);

		BuildPath(Path_SM, buffer, sizeof(buffer), "data/melee_manifest.txt");
		if (kv.SaveToFile(buffer))
			PrintToServer("Save to file succeeded: %s", buffer);
	}

	kv.deleteThis();
	return Plugin_Handled;
}

Action Cmd_Test1_PrintAllKeyValues(int client, int args)
{
	SourceKeyValues kvAll = GetAllMissionsAndModes();
	PrintAllKeyValues(kvAll);

	if (kvAll.SaveToFile("AllMissionsAndModes.txt"))
		PrintToServer("Save to file succeeded: AllMissionsAndModes.txt");

	return Plugin_Handled;
}

void PrintAllKeyValues(SourceKeyValues root)
{
	char sName[128], sValue[256];
	int type;

	for (SourceKeyValues kv = root.GetFirstSubKey(); !kv.IsNull(); kv = kv.GetNextKey())
	{
		kv.GetName(sName, sizeof(sName));

		if (!kv.GetFirstSubKey().IsNull())
		{
			PrintToServer("------ sub %s ------", sName);
			PrintAllKeyValues(kv);
		}
		else
		{
			type = kv.GetDataType(NULL_STRING);
			switch (type)
			{
				case TYPE_INT:
					PrintToServer("%s = %i", sName, kv.GetInt(NULL_STRING));
				case TYPE_FLOAT:
					PrintToServer("%s = %f", sName, kv.GetFloat(NULL_STRING));
				case TYPE_PTR:
					PrintToServer("%s = 0x%x", sName, kv.GetPtr(NULL_STRING));
				case TYPE_STRING:
				{
					kv.GetString(NULL_STRING, sValue, sizeof(sValue), "N/A");
					PrintToServer("%s = %s", sName, sValue); 
				}
				default:
					PrintToServer("%s type = %i, skip getting value", sName, type); 
			}
		}
	}
}

Action Cmd_Test2_PrintTrueSubKeyName(int client, int args)
{
	SourceKeyValues kvModes = GetAllModes();

	char sName[128];
	for (SourceKeyValues sub = kvModes.GetFirstTrueSubKey(); !sub.IsNull(); sub = sub.GetNextTrueSubKey())
	{
		sub.GetName(sName, sizeof(sName));
		PrintToServer("sub = %s", sName);
	}

	if (kvModes.SaveToFile("AllModes.txt"))
		PrintToServer("Save to file succeeded: AllModes.txt");

	return Plugin_Handled;
}

Action Cmd_Test3_PrintTrueValue(int client, int args)
{
	SourceKeyValues kvMissions = GetAllMissions();

	char sName[128], sValue[256];
	int type;
	SourceKeyValues sub = kvMissions.FindKey("L4D2C1/modes/versus/1");

	if (!sub.IsNull())
	{
		for (SourceKeyValues kv = sub.GetFirstValue(); !kv.IsNull(); kv = kv.GetNextValue())
		{
			kv.GetName(sName, sizeof(sName));

			type = kv.GetDataType(NULL_STRING);
			switch (type)
			{
				case TYPE_INT:
					PrintToServer("%s = %i", sName, kv.GetInt(NULL_STRING));
				case TYPE_FLOAT:
					PrintToServer("%s = %f", sName, kv.GetFloat(NULL_STRING));
				case TYPE_PTR:
					PrintToServer("%s = 0x%x", sName, kv.GetPtr(NULL_STRING));
				case TYPE_STRING:
				{
					kv.GetString(NULL_STRING, sValue, sizeof(sValue));
					PrintToServer("%s = %s", sName, sValue); 
				}
				default:
					PrintToServer("%s type = %i, skip getting value", sName, type); 
			}
		}
	}

	if (kvMissions.SaveToFile("AllMissions.txt"))
		PrintToServer("Save to file succeeded: AllMissions.txt");

	return Plugin_Handled;
}

Action Cmd_Test4_OtherTest(int client, int args)
{
	char sValue[128];
	SourceKeyValues kv = GetGameModeInfo("coop");

	PrintToServer("pAdr = 0x%x", kv.GetPtr("Missions/L4D2C2"));
	PrintToServer("iValue = %i", kv.GetInt("x360presence:/play:credits"));

	kv.SetString("NewStringKey", "StringValue");
	kv.GetString("NewStringKey", sValue, sizeof(sValue));
	PrintToServer("NewStringKey value = %s", sValue);

	SourceKeyValues NewStringKey = kv.FindKey("NewStringKey");
	if (!NewStringKey.IsNull())
	{
		NewStringKey.SetStringValue("StringValue_modify");
		NewStringKey.GetString(NULL_STRING, sValue, sizeof(sValue));
		PrintToServer("NewStringKey value = %s", sValue);
	}

	SourceKeyValues newSub = kv.FindKey("NewSub", true);
	if (!newSub.IsNull())
	{
		newSub.SetName("NewSub_modify");
		newSub.GetName(sValue, sizeof(sValue));
		PrintToServer("NewSub_modify name = %s", sValue);

		newSub.SetInt("NewIntKey", 111);
		SourceKeyValues NewIntKey = newSub.FindKey("NewIntKey");
		if (!NewIntKey.IsNull())
		{
			NewIntKey.SetName("NewIntKey_modify");
			NewIntKey.GetName(sValue, sizeof(sValue));
			PrintToServer("NewIntKey_modify name = %s", sValue);
			PrintToServer("NewIntKey_modify Value = %i", NewIntKey.GetInt(NULL_STRING));
		}

		newSub.SetFloat("NewFloatKey", 1.123);
		PrintToServer("NewFloatKey = %f", newSub.GetFloat("NewFloatKey"));

		int iValue = newSub.GetInt("testInt", -1);
		if (iValue == -1) PrintToServer("testInt");

		float fValue = newSub.GetFloat("testFloat");
		if (fValue == 0.0) PrintToServer("testFloat");

		strcopy(sValue, sizeof(sValue), "string");
		newSub.GetString("testString", sValue, sizeof(sValue));
		if (sValue[0] == '\0') PrintToServer("testString");
	}

	if (kv.SaveToFile("ModeModify.txt"))
		PrintToServer("Save to file succeeded: ModeModify.txt");
		
	return Plugin_Handled;
}

SourceKeyValues GetAllMissionsAndModes()
{
	return LoadFromAddress(g_pMatchExtL4D + view_as<Address>(4), NumberType_Int32);
}

SourceKeyValues GetAllMissions()
{
	return SDKCall(g_hSDKGetAllMissions, g_pMatchExtL4D);
}

SourceKeyValues GetAllModes()
{
	return SDKCall(g_hSDKGetAllModes, g_pMatchExtL4D);
}

SourceKeyValues GetGameModeInfo(const char[] sModeName)
{
	return SDKCall(g_hSDKGetGameModeInfo, g_pMatchExtL4D, sModeName);
}

void Init()
{
	char buffer[256];

	strcopy(buffer, sizeof(buffer), "l4d2_source_keyvalues_test");
	GameData hGameData = new GameData(buffer);
	if (hGameData == null)
		SetFailState("Failed to load \"%s.txt\" gamedata.", buffer);

	strcopy(buffer, sizeof(buffer), "g_pMatchExtL4D");
	g_pMatchExtL4D = hGameData.GetAddress(buffer);
	if (g_pMatchExtL4D == Address_Null)
		SetFailState("Failed to GetAddress: %s", buffer);

	strcopy(buffer, sizeof(buffer), "MatchExtL4D::GetAllMissions");
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, buffer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKGetAllMissions = EndPrepSDKCall();
	if (g_hSDKGetAllMissions == null)
		SetFailState("Failed to create SDKCall: %s", buffer);

	strcopy(buffer, sizeof(buffer), "MatchExtL4D::GetAllModes");
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, buffer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKGetAllModes = EndPrepSDKCall();
	if (g_hSDKGetAllModes == null)
		SetFailState("Failed to create SDKCall: %s", buffer);

	strcopy(buffer, sizeof(buffer), "MatchExtL4D::GetGameModeInfo");
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, buffer);
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKGetGameModeInfo = EndPrepSDKCall();
	if (g_hSDKGetGameModeInfo == null)
		SetFailState("Failed to create SDKCall: %s", buffer);
	
	delete hGameData;
}


