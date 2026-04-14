module rrt_node_addition(  
    input clk,  
    input rst,  
    input [7:0] new_node_x,  
    input [7:0] new_node_y,  
    input [7:0] existing_node_x,  
    input [7:0] existing_node_y,  
    output reg node_added  
);  
    parameter DIST_THRESHOLD = 20;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            node_added <= 0;  
        end else begin  
            if (((new_node_x - existing_node_x)**2 + (new_node_y - existing_node_y)**2) <= DIST_THRESHOLD**2) begin  
                node_added <= 1;  
            end else begin  
                node_added <= 0;  
            end  
        end  
    end  
endmodule