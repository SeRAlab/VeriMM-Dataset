module BFS (
    input clk,
    input reset,
    input [15:0] adjacency_matrix, // 4x4 matrix for 4 nodes
    input [1:0] start_node, // 2-bit input for start node (0-3)
    output reg [7:0] visited_order // 8-bit output for visited order (up to 4 nodes)
);
    reg [3:0] queue; // Queue to hold nodes to visit
    reg [3:0] visited; // Visited nodes
    integer i, front, rear;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            visited <= 4'b0000;
            queue <= 4'b0000;
            visited_order <= 8'b00000000;
            front <= 0;
            rear <= 0;
        end else begin
            if (front <= rear) begin
                // BFS Logic
                if (queue[front]) begin
                    visited[front] <= 1;
                    visited_order <= {visited_order[3:0], front};
                    front <= front + 1;

                    // Enqueue adjacent unvisited nodes
                    for (i = 0; i < 4; i = i + 1) begin
                        if (adjacency_matrix[front*4 + i] && !visited[i]) begin
                            queue[rear] <= i;
                            rear <= rear + 1;
                        end
                    end
                end
            end else begin
                // Enqueue the starting node
                queue[0] <= start_node;
                rear <= 1;
            end
        end
    end
endmodule