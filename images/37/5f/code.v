module dfs (
    input clk,
    input reset,
    input [3:0] node_value, // current node value
    input move_left,        // move to left child
    input move_right,       // move to right child
    output reg [15:0] path  // output path taken
);

    reg [15:0] stack [0:15]; // stack for DFS
    reg [3:0] sp;             // stack pointer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;          // reset stack pointer
            path <= 0;       // reset path
        end else begin
            if (move_left) begin
                stack[sp] <= node_value; // push current node
                path <= {path[14:0], 1'b1}; // add to path
                sp <= sp + 1; // increment stack pointer
            end else if (move_right) begin
                stack[sp] <= node_value; // push current node
                path <= {path[14:0], 1'b0}; // add to path
                sp <= sp + 1; // increment stack pointer
            end
        end
    end

endmodule