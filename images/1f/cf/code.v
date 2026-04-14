module thermal_sensor_calibration (  
    input wire clk,  
    input wire rst,  
    input wire [11:0] raw_temp,  
    input wire [11:0] calibration_factor,  
    output reg [11:0] calibrated_temp  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            calibrated_temp <= 12'd0;  
        end else begin  
            calibrated_temp <= raw_temp + calibration_factor;  
        end  
    end  
endmodule