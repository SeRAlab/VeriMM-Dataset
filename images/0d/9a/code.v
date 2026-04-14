module dfs_tree (
    input clk,
    input reset,
    input new_node,
    output reg [2:0] current_node
);
    reg [2:0] stack [0:7]; // Stack for DFS
    reg [2:0] stack_ptr;
    
    initial begin
        current_node = 3'b000; // Start at root
        stack_ptr = 0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 3'b000; // Reset to root
            stack_ptr <= 0;
        end else if (new_node) begin
            stack[stack_ptr] <= current_node; // Push current node to stack
            stack_ptr <= stack_ptr + 1;
            if (current_node < 3'b111) // Check if there are more nodes to explore
                current_node <= current_node + 1; // Move to next node
            else
                stack_ptr <= stack_ptr - 1; // Pop from stack
        end else if (stack_ptr > 0) begin
            stack_ptr <= stack_ptr - 1; // Pop from stack
            current_node <= stack[stack_ptr]; // Set current node to the top of the stack
        end
    end
endmodule