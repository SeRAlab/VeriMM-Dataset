module thermal_sensor_calibration (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] raw_temp,  
    input wire [7:0] cal_factor,  
    output reg [7:0] calibrated_temp  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            calibrated_temp <= 8'b0;  
        end else begin  
            calibrated_temp <= raw_temp + cal_factor;  
        end  
    end  
endmodule