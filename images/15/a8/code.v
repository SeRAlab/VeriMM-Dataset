module thermal_sensor_calibration (  
    input wire clk,  
    input wire rst,  
    input wire [9:0] temp_input, // 10-bit input temperature  
    input wire [3:0] calibration_factor, // 4-bit calibration factor  
    output reg [9:0] temp_output // 10-bit calibrated temperature output  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        temp_output <= 10'b0;  
    end else begin  
        // Calibrated temperature calculation  
        temp_output <= temp_input + {6'b0, calibration_factor};  
    end  
end  
endmodule