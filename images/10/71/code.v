module bfs (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [3:0] start_node, // node to start BFS
    input wire [15:0] adjacency_list, // adjacency list representation
    output reg [15:0] visited_nodes, // visited nodes as a bit vector
    output reg done // signal to indicate completion
);

    reg [3:0] queue [0:15]; // queue for BFS
    reg [3:0] head, tail;
    reg [15:0] visited;
    reg [3:0] current_node;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            visited <= 0;
            visited_nodes <= 0;
            done <= 0;
        end else if (start) begin
            // Initialize BFS
            queue[tail] <= start_node;
            tail <= tail + 1;
            visited[start_node] <= 1;
            done <= 0;
        end else if (head < tail) begin
            // Perform BFS
            current_node = queue[head];
            visited_nodes[current_node] <= 1; // mark as visited
            head <= head + 1;

            // Enqueue adjacent nodes
            for (i = 0; i < 16; i = i + 1) begin
                if (adjacency_list[current_node * 16 + i] && !visited[i]) begin
                    queue[tail] <= i; // enqueue
                    tail <= tail + 1;
                    visited[i] <= 1; // mark as visited
                end
            end
        end else begin
            done <= 1; // BFS is done
        end
    end
endmodule