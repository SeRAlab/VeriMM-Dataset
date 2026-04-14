module bfs(
    input clk,
    input reset,
    input enable,
    input [1:0] start_node,
    output reg [3:0] visited,
    output reg [3:0] order
);
    reg [3:0] queue;
    reg [1:0] current;
    reg [3:0] adjacency_matrix [0:3]; // 4x4 adjacency matrix
    integer i, j;

    initial begin
        adjacency_matrix[0] = 4'b0110; // Node 0 connected to 1 and 2
        adjacency_matrix[1] = 4'b1001; // Node 1 connected to 0 and 3
        adjacency_matrix[2] = 4'b1000; // Node 2 connected to 0
        adjacency_matrix[3] = 4'b0001; // Node 3 connected to 1
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            visited <= 4'b0000;
            order <= 4'b0000;
            queue <= 4'b0000;
            current <= 0;
        end else if (enable) begin
            if (visited[start_node] == 0) begin
                visited[start_node] <= 1;
                order <= order | (1 << start_node);
                queue <= queue | (1 << start_node);
                current <= start_node;
            end else begin
                for (i = 0; i < 4; i = i + 1) begin
                    if (adjacency_matrix[current][i] && !visited[i]) begin
                        visited[i] <= 1;
                        order <= order | (1 << i);
                        queue <= queue | (1 << i);
                    end
                end
                current <= queue[3:0]; // Move to next node (BFS level)
                queue <= queue >> 1; // Simulate queue operation
            end
        end
    end
endmodule