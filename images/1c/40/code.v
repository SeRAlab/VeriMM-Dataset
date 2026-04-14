module RRT_Node (  
    input clk,  
    input reset,  
    input [3:0] command,  
    input [15:0] new_node,  
    output reg [15:0] current_node  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_node <= 16'b0;  
        end else begin  
            case (command)  
                4'b0001: current_node <= new_node; // Add new node  
                4'b0010: current_node <= current_node; // Move to the current node (no operation)  
                default: current_node <= current_node; // Default case  
            endcase  
        end  
    end  
endmodule