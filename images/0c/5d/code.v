module slam_update (  
    input clk,  
    input rst,  
    input [4:0] position_in,  
    input [7:0] map_update,  
    output reg [4:0] position_out,  
    output reg [7:0] map_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            position_out <= 5'b00000;  
            map_out <= 8'b00000000;  
        end else begin  
            position_out <= position_in;  
            map_out <= map_update;  
        end  
    end  
endmodule