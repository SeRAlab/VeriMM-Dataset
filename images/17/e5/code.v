module thermal_sensor_calibration (  
    input wire clk,  
    input wire reset,  
    input wire [11:0] raw_temp,  
    input wire [3:0] cal_factor,  
    output reg [11:0] calibrated_temp  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            calibrated_temp <= 12'b0;  
        end else begin  
            calibrated_temp <= raw_temp + cal_factor;  
        end  
    end  
endmodule