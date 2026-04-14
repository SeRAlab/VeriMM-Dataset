module dfs_tree (  
    input clk,  
    input rst,  
    input traverse,  
    input [3:0] node_in,  
    output reg [3:0] current_node,  
    output reg [15:0] stack_out  
);  
    reg [15:0] stack;  
    reg [3:0] top;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_node <= 4'b0000;  
            stack <= 16'b0;  
            top <= 4'b0000;  
        end else if (traverse) begin  
            stack[top] <= current_node;  
            top <= top + 1;  
            current_node <= node_in - 1;  
        end else begin  
            if (current_node == 0) begin  
                top <= top - 1;  
                current_node <= stack[top];  
                stack_out <= stack;  
            end else begin  
                current_node <= current_node + 1;  
            end  
        end  
    end  
endmodule