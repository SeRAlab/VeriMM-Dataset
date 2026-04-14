module DFS (
    input clk,
    input rst,
    input [3:0] start_node,
    input [15:0] adj_matrix, // 4x4 adjacency matrix for a simple graph
    output reg [15:0] visited_nodes
);
    reg [3:0] stack [0:15]; // stack for DFS
    reg [3:0] top;           // stack pointer
    reg [15:0] visited;      // visited nodes
    reg [3:0] current_node;  // current node being explored
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            visited <= 0;
            top <= -1;
            visited_nodes <= 0;
        end else if (top == -1) begin
            // Start DFS
            stack[0] <= start_node;
            top <= 0;
        end else begin
            // Perform DFS
            current_node = stack[top];
            if (!visited[current_node]) begin
                visited[current_node] <= 1;
                visited_nodes = visited_nodes | (1 << current_node);
            end
            // Push unvisited adjacent nodes onto the stack
            for (i = 0; i < 4; i = i + 1) begin
                if (adj_matrix[current_node * 4 + i] && !visited[i]) begin
                    top <= top + 1;
                    stack[top] <= i;
                end
            end
            // Pop the stack
            if (top > -1) begin
                top <= top - 1;
            end
        end
    end
endmodule