module thermal_sensor_calibration (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] temp_in,  
    output reg [7:0] temp_out  
);  
    parameter OFFSET = 8'd5; // Calibration offset  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            temp_out <= 8'b0;  
        end else begin  
            temp_out <= temp_in + OFFSET;  
        end  
    end  
endmodule