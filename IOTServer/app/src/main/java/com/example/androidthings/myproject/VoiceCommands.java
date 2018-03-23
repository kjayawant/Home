package com.example.androidthings.myproject;

import java.util.ArrayList;

/**
 * Created by karis on 6/3/2017.
 */

interface VoiceCommands {

    void CommandIdentifier(String userCommand);
    ArrayList<String> getDeviceStatus();
    ArrayList<String> getSensorStatus();
}
