module thermal_sensor_calibration(  
    input clk,  
    input [9:0] temp_input,  
    input [3:0] calibration_factor,  
    output reg [9:0] calibrated_temp  
);  
    always @(posedge clk) begin  
        calibrated_temp <= temp_input + calibration_factor;  
    end  
endmodule