module DFS_Tree(
    input clk,
    input reset,
    input [7:0] current_node,
    input go_left,
    input go_right,
    output reg [7:0] output_node
);
    
    reg [7:0] stack[0:15]; // Stack for DFS, can hold up to 16 nodes
    reg [3:0] top; // Stack pointer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            output_node <= 8'b0;
        end else begin
            if (go_left || go_right) begin
                // Push current_node onto the stack
                stack[top] <= current_node;
                top <= top + 1;
                // Traverse left or right
                if (go_left) begin
                    // Assuming the left child is current_node - 1
                    output_node <= current_node - 1;
                end else if (go_right) begin
                    // Assuming the right child is current_node + 1
                    output_node <= current_node + 1;
                end
            end else if (top > 0) begin
                // Pop from stack
                top <= top - 1;
                output_node <= stack[top];
            end
        end
    end
endmodule