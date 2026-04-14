module thermal_sensor_calibration(  
    input clk,  
    input reset,  
    input [7:0] temp_input,  // 8-bit input temperature  
    input [7:0] calibration_factor,  // 8-bit calibration factor  
    output reg [7:0] calibrated_temp  // 8-bit calibrated temperature output  
);  

    parameter MAX_TEMP = 100;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            calibrated_temp <= 0;  
        end else begin  
            calibrated_temp <= temp_input + calibration_factor;  
            if (calibrated_temp > MAX_TEMP)  
                calibrated_temp <= MAX_TEMP;  
        end  
    end  
endmodule