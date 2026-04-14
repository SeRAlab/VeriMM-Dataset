module slam_position_update (  
    input clk,  
    input rst,  
    input [3:0] current_position,  
    input [3:0] new_observation,  
    output reg [3:0] updated_position  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        updated_position <= 4'b0000;  
    end else begin  
        updated_position <= (current_position + new_observation) % 16;  
    end  
end  
endmodule