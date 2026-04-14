module bfs_traversal (
    input clk,
    input rst,
    input [3:0] current_node,
    output reg [3:0] visited_node,
    output reg done
);
    reg [3:0] queue [0:15]; // Queue for BFS
    reg [4:0] head, tail; // Indices for head and tail of the queue
    reg [3:0] next_node;

    initial begin
        head = 0;
        tail = 0;
        done = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            done <= 0;
        end else if (!done) begin
            if (head < tail) begin
                visited_node <= queue[head];
                head <= head + 1;
                // Enqueue children
                if (current_node[0]) begin
                    queue[tail] <= current_node[1:0]; // left child
                    tail <= tail + 1;
                end
                if (current_node[2]) begin
                    queue[tail] <= current_node[3:2]; // right child
                    tail <= tail + 1;
                end
            end else begin
                done <= 1; // BFS complete
            end
        end
    end
endmodule