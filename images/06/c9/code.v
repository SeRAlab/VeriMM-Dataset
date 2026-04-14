module thermal_sensor_calibration(  
    input wire clk,  
    input wire rst,  
    input wire [11:0] raw_data,   // 12-bit raw sensor data  
    input wire [11:0] calibration_value, // 12-bit calibration value  
    output reg [11:0] calibrated_data // output calibrated data  
);  

    reg [11:0] last_calibrated_value;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            calibrated_data <= 12'b0;  
            last_calibrated_value <= 12'b0;  
        end else begin  
            calibrated_data <= raw_data + calibration_value;  
            last_calibrated_value <= calibrated_data;  
        end  
    end  
endmodule