module bfs_traversal (
    input clk,
    input rst,
    input [7:0] node_value,
    input valid,
    output reg [7:0] bfs_output,
    output reg done
);
    reg [7:0] queue [0:15]; // Simple queue for BFS, max 16 elements
    reg [3:0] head, tail;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            done <= 0;
        end else if (valid && count < 16) begin
            // Enqueue
            queue[tail] <= node_value;
            tail <= (tail + 1) % 16;
            count <= count + 1;
        end else if (count > 0) begin
            // Dequeue
            bfs_output <= queue[head];
            head <= (head + 1) % 16;
            count <= count - 1;
            if (count == 1) begin
                done <= 1; // Mark done when only one element is left
            end else begin
                done <= 0;
            end
        end
    end
endmodule