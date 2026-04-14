module thermal_sensor_calibration(  
    input [9:0] temperature_input,  
    output [9:0] calibrated_output  
);  
    assign calibrated_output = temperature_input + 10'b0000000001; // Adding a constant value of 1 for calibration  
endmodule