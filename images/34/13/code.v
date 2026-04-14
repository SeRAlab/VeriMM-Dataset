module thermal_sensor_calibration (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] raw_temp,  
    input wire [7:0] calibration_factor,  
    input wire [7:0] threshold,  
    output reg [7:0] calibrated_temp  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        calibrated_temp <= 8'b0;  
    end else begin  
        if (raw_temp > threshold) begin  
            calibrated_temp <= raw_temp + calibration_factor;  
        end else begin  
            calibrated_temp <= raw_temp;  
        end  
    end  
end  
endmodule