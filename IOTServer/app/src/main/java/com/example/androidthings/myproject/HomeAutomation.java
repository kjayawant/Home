package com.example.androidthings.myproject;

import android.util.Log;

import com.google.android.things.pio.Gpio;
import com.google.android.things.pio.PeripheralManagerService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by karis on 6/15/2017.
 */

public class HomeAutomation implements VoiceCommands {

    static final String TAG = VoiceCommands.class.getSimpleName();
    public String toBePrinted = "";

    public ArrayList<Appliance> allAppliances = new ArrayList<>();
    public ArrayList<String> allAppliancesString = new ArrayList<>();
    public ArrayList<Sensor> allSensors = new ArrayList<>();
    public ArrayList<String> allSensorsString = new ArrayList<>();
    PeripheralManagerService service = new PeripheralManagerService();

    HomeAutomation.Appliance light = new Appliance("BCM13", "Light");
    HomeAutomation.Appliance airConditioner = new HomeAutomation.Appliance("BCM19", "Air Conditioner");
    HomeAutomation.Sensor temperatureSensor = new HomeAutomation.Sensor("Temperature",80);

    public class Sensor {
        float value;
        String name;

        @Override
        public String toString() {
            return (name + ":" + value);
        }

        public Sensor(String name,float value) {
            this.name = name;
            this.value = value;
            allSensors.add(this);
        }
    }

    public class Appliance {
        Gpio pin;
        boolean status;
        String name;

        @Override
        public String toString() {
            String onOff;
            if (status == false) {
                onOff = "Off";
            } else {
                onOff = "On";
            }
            return (name + ":" + onOff);
        }

        public Appliance(String pinName, String name) {
            try {
                pin = service.openGpio(pinName);
                pin.setDirection(Gpio.DIRECTION_OUT_INITIALLY_LOW);
                this.name = name;
                allAppliances.add(this);
            } catch (IOException e) {
                Log.e(TAG, "Error on PeripheralIO API", e);

            }
        }
    }


    public void CommandIdentifier(String userCommand) {
        toBePrinted = "";

        //if sentence begins with "if" extract
        //look for "then"
        //temperature --> temp_sensor
        //(part after then) --> userCommand
        RecipeExtraction extractor = new RecipeExtraction(this, userCommand);
        toBePrinted = extractor.toBePrinted;
    }

    @Override
    public ArrayList<String> getDeviceStatus() {
        allAppliancesString.clear();
        for (Appliance iAppliance : allAppliances) {
            allAppliancesString.add(iAppliance.toString());
        }
        return allAppliancesString;
    }

    public ArrayList<String> getSensorStatus() {
        allSensorsString.clear();
        for (Sensor iSensor : allSensors) {
            allSensorsString.add(iSensor.toString());
        }
        return allSensorsString;
    }
}