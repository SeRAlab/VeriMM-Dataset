module bfs (
    input wire clk,
    input wire rst,
    input wire [4:0] start_node,
    input wire [0:24*25-1] adj_matrix, // 25x25 adjacency matrix flattened
    output reg [0:24] visited_nodes // 25-bit vector to indicate visited nodes
);
    reg [4:0] queue [0:24]; // Queue for BFS
    reg [4:0] front, rear; // Queue pointers
    reg [4:0] current_node;
    reg [4:0] i;
    reg [4:0] next_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            visited_nodes <= 25'b0;
            front <= 0;
            rear <= 0;
            next_count <= 0;
        end else if (next_count < 25) begin
            if (front == rear) begin // Queue is empty
                current_node = start_node;
                visited_nodes[current_node] <= 1'b1; // Visit the start node
                queue[rear] <= current_node;
                rear <= rear + 1;
            end else begin
                current_node = queue[front];
                front <= front + 1;
                for (i = 0; i < 25; i = i + 1) begin
                    if (adj_matrix[current_node * 25 + i] && !visited_nodes[i]) begin
                        visited_nodes[i] <= 1'b1; // Mark node as visited
                        queue[rear] <= i; // Enqueue the node
                        rear <= rear + 1;
                    end
                end
            end
            next_count <= next_count + 1;
        end
    end
endmodule