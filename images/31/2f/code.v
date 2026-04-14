module bfs(
    input clk,
    input reset,
    input [3:0] start_node,
    input start_traversal,
    output reg [3:0] visited_node,
    output reg traversal_done
);

    reg [3:0] queue [0:14];
    reg [3:0] front, rear;
    reg [3:0] visited [0:14];
    reg [3:0] visit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            front <= 0;
            rear <= 0;
            visit_count <= 0;
            traversal_done <= 0;
            visited_node <= 4'bx;
        end else if (start_traversal && visit_count == 0) begin
            queue[rear] <= start_node;
            rear <= rear + 1;
            visited[visit_count] <= start_node;
            visit_count <= visit_count + 1;
        end else if (front < rear) begin
            visited_node <= queue[front];
            front <= front + 1;

            // Enqueue children if they are within bounds
            if (queue[front - 1] * 2 + 1 < 15) begin
                queue[rear] <= queue[front - 1] * 2 + 1;
                rear <= rear + 1;
            end
            if (queue[front - 1] * 2 + 2 < 15) begin
                queue[rear] <= queue[front - 1] * 2 + 2;
                rear <= rear + 1;
            end

            // Mark the node as visited
            visited[visit_count] <= visited_node;
            visit_count <= visit_count + 1;
        end else begin
            traversal_done <= 1; // BFS Traversal complete
        end
    end
endmodule