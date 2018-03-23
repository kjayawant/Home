package com.example.androidthings.myproject;

import android.util.Log;

import java.io.IOException;

/**
 * Created by karishma on 6/30/2017.
 */

public class RecipeExtraction {
    static final String TAG = RecipeExtraction.class.getSimpleName();

    String recipe;
    String ifSubstring;
    String thenSubstring;
    String number;
    boolean onOff;
    HomeAutomation home;
    boolean condition = false;
    String toBePrinted = "";
    int found = 0;

    public RecipeExtraction(HomeAutomation home, String recipe) {
        this.home = home;
        this.recipe = recipe;
        dissectRecipe();
    }

    public int convertStringToNumber(String number) {
        //convert text to number routine
        return Integer.parseInt(number);
    }


    public void dissectRecipe() {
        thenSubstring = recipe;
        if (recipe.startsWith("if ")) {
            try {
                ifSubstring = recipe.substring(3, recipe.indexOf(" then "));
                thenSubstring = recipe.substring(recipe.indexOf(" then "));

                for (HomeAutomation.Sensor iSensor : home.allSensors) {
                    if (ifSubstring.contains(iSensor.name.toLowerCase())) {
                        found = 1;
                        if (ifSubstring.contains("is greater than")) {
                            number = ifSubstring.substring(ifSubstring.indexOf("is greater than") + 16);
                            int num = convertStringToNumber(number);
                            condition = iSensor.value > num;
                        } else if (ifSubstring.contains("is equal to")) {
                            number = ifSubstring.substring(ifSubstring.indexOf("is equal to") + 12);
                            int num = convertStringToNumber(number);
                            condition = iSensor.value == num;
                        } else if (ifSubstring.contains("is less than")) {
                            number = ifSubstring.substring(ifSubstring.indexOf("is less than") + 13);
                            int num = convertStringToNumber(number);
                            condition = iSensor.value < num;
                        }
                         if(condition == false) {
                             toBePrinted = "Condition not satisfied";
                             return;
                         }
                         break;
                    }
                }
            }
            catch (StringIndexOutOfBoundsException e){
                toBePrinted = "Invalid command";
                return;
            }
            if (found == 0) {
                toBePrinted = "Sensor not found";
                return;
            }
        } else
            condition = true;
        found = 0;
        if (thenSubstring.contains("turn on") || thenSubstring.contains("switch on")) {
            onOff = true;
            toBePrinted = "on";
        } else if (thenSubstring.contains("turn off") || thenSubstring.contains("switch off")) {
            onOff = false;
            toBePrinted = "off";
        } else {
            toBePrinted = "Invalid Command";
            return;
        }
        if (condition == true) {
            for (HomeAutomation.Appliance iAppliance : home.allAppliances) {
                if (thenSubstring.contains(iAppliance.name.toLowerCase())) {
                    found = 1;
                    try {
                        iAppliance.pin.setValue(onOff);
                        iAppliance.status = onOff;
                        toBePrinted = iAppliance.name + " " + toBePrinted;
                    } catch (IOException e) {
                        Log.e(TAG, "Error on PeripheralIO API", e);
                    }
                    break;
                }
            }
            if (found == 0) {
                toBePrinted = "Device not found";
                return;
            }
        }
    }
}