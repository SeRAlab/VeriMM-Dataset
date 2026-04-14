module dfs_tree (
    input wire clk,
    input wire rst,
    input wire [3:0] start_node, // 4-bit encoded start node
    input wire [15:0] tree, // 16-bit representation of a binary tree
    output reg [3:0] visited_node,
    output reg done
);
    reg [3:0] stack [0:15]; // Stack for DFS
    reg [3:0] top; // Top of the stack
    reg [15:0] visited; // Visited nodes
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            visited <= 0;
            visited_node <= 0;
            done <= 0;
            stack[0] <= start_node; // Push start node onto stack
        end else begin
            if (top > 0) begin
                // Pop from stack
                top <= top - 1;
                visited_node <= stack[top];
                visited[stack[top]] <= 1; // Mark as visited
                // Push children onto stack (left child, right child)
                if (stack[top] * 2 < 16 && !visited[stack[top] * 2]) begin
                    stack[top] <= stack[top] * 2; // Left child
                    top <= top + 1;
                end
                if (stack[top - 1] * 2 + 1 < 16 && !visited[stack[top - 1] * 2 + 1]) begin
                    stack[top] <= stack[top - 1] * 2 + 1; // Right child
                    top <= top + 1;
                end
            end else begin
                done <= 1; // Traversal complete
            end
        end
    end
endmodule