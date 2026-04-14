module SLAM_Module(  
    input [3:0] sensor_data,  
    input [1:0] direction,  
    input clk,  
    input rst,  
    output reg [3:0] position  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            position <= 4'b0000;  
        end else begin  
            case (direction)  
                2'b00: position <= position + sensor_data; // Move North  
                2'b01: position <= position + sensor_data; // Move East  
                2'b10: position <= position - sensor_data; // Move South  
                2'b11: position <= position - sensor_data; // Move West  
                default: position <= position;  
            endcase  
        end  
    end  
endmodule