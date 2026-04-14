module thermal_sensor_calibration(  
    input wire clk,  
    input wire [15:0] raw_temp,  
    input wire [7:0] calibration_factor,  
    output reg [15:0] calibrated_temp  
);  
    always @(posedge clk) begin  
        calibrated_temp <= raw_temp + calibration_factor;  
    end  
endmodule