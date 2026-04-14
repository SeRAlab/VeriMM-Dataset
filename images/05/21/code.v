module SLAM_Module (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] sensor_reading,  
    output reg [4:0] position_estimate  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        position_estimate <= 5'b00000;  
    end else begin  
        position_estimate <= position_estimate + sensor_reading;  
    end  
end  
endmodule