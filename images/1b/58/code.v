module bfs_tree (
    input clk,
    input reset,
    input [3:0] node_in,
    output reg [3:0] node_out
);
    reg [15:0] queue; // Assuming a maximum of 16 nodes in the tree
    reg [3:0] head, tail;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            queue <= 0;
            head <= 0;
            tail <= 0;
            node_out <= 0;
        end else begin
            // Add the incoming node to the queue
            if (head < 16) begin
                queue[head] <= node_in;
                head <= head + 1;
            end
            
            // Output the current node
            if (tail < head) begin
                node_out <= queue[tail];
                tail <= tail + 1;
            end
        end
    end
endmodule