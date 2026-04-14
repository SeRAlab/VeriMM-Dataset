module dfs_tree #(parameter SIZE = 15) (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [3:0] current_node,  
    output reg [SIZE-1:0] visited_nodes  
);  
    reg [3:0] stack [0:SIZE-1];  
    reg [3:0] sp; // stack pointer  
    reg [3:0] node;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            visited_nodes <= 0;  
            sp <= 0;  
        end else if (start) begin  
            // Push current node onto stack  
            if (sp < SIZE) begin  
                stack[sp] <= current_node;  
                sp <= sp + 1;  
            end  
        end else if (sp > 0) begin  
            sp <= sp - 1; // pop from stack  
            node = stack[sp];  
            visited_nodes[node] <= 1'b1; // mark node as visited  
            // Push left and right children onto stack  
            if (2 * node + 1 < SIZE) begin  
                stack[sp] <= 2 * node + 1;  
                sp <= sp + 1;  
            end  
            if (2 * node + 2 < SIZE) begin  
                stack[sp] <= 2 * node + 2;  
                sp <= sp + 1;  
            end  
        end  
    end  
endmodule