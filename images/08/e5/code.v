module thermal_sensor_calibration(  
    input [4:0] temp_input,  
    output [4:0] temp_output  
);  
    wire [5:0] temp_calibrated; // To hold the value after adding offset  
  
    assign temp_calibrated = temp_input + 5'd3; // Add offset of 3  
    assign temp_output = (temp_calibrated > 5'd31) ? 5'd31 : temp_calibrated[4:0]; // Limit to 31  
  
endmodule