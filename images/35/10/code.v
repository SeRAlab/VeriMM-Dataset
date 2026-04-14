module bfs (
    input clk,
    input rst,
    input start,
    input [2:0] start_node,
    output reg [15:0] traversal_order,
    output reg done
);
    reg [15:0] adjacency_list [0:7]; // Example graph with 8 nodes
    reg [3:0] queue [0:7]; // Queue for BFS
    reg [3:0] front, rear;
    reg [15:0] visited;
    reg [3:0] current_node;
    integer i;

    initial begin
        // Initialize adjacency list (example graph)
        adjacency_list[0] = 16'b0000000000001110; // Node 0 connected to nodes 1, 2, 3
        adjacency_list[1] = 16'b0000000000011100; // Node 1 connected to nodes 2, 3
        adjacency_list[2] = 16'b0000000000110000; // Node 2 connected to nodes 3, 4
        adjacency_list[3] = 16'b0000000001000000; // Node 3 connected to node 4
        adjacency_list[4] = 16'b0000000000000000; // Node 4 not connected to any
        adjacency_list[5] = 16'b0000000000000000; // Node 5 not connected to any
        adjacency_list[6] = 16'b0000000000000000; // Node 6 not connected to any
        adjacency_list[7] = 16'b0000000000000000; // Node 7 not connected to any
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            front <= 0;
            rear <= 0;
            visited <= 16'b0;
            traversal_order <= 16'b0;
            current_node <= 0;
            done <= 0;
        end else if (start) begin
            if (!done) begin
                if (front == rear) begin
                    // Queue empty, BFS complete
                    done <= 1;
                end else begin
                    // Process the current node
                    current_node <= queue[front];
                    visited[current_node] <= 1;
                    traversal_order <= traversal_order | (1 << current_node);
                    front <= front + 1;

                    // Enqueue adjacent nodes
                    for (i = 0; i < 16; i = i + 1) begin
                        if (adjacency_list[current_node][i] && !visited[i]) begin
                            queue[rear] <= i;
                            rear <= rear + 1;
                        end
                    end
                end
            end
        end else if (!done) begin
            queue[rear] <= start_node;
            rear <= rear + 1;
        end
    end
endmodule