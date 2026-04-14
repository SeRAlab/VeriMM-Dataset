module SLAM_Update(  
    input clk,  
    input rst,  
    input [7:0] curr_position,  
    input [7:0] map_update,  
    output reg [7:0] updated_position,  
    output reg [7:0] updated_map  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            updated_position <= 8'b0;  
            updated_map <= 8'b0;  
        end else begin  
            updated_position <= curr_position + map_update;  
            updated_map <= map_update; // For simplicity, we just update the map with the new data  
        end  
    end  
endmodule