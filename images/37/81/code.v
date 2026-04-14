module dfs_traversal (
    input clk,
    input rst,
    input [2:0] index,
    output reg [7:0] node_value
);
    reg [7:0] tree [0:6]; // Array to represent binary tree
    initial begin
        // Initializing the binary tree with some values
        tree[0] = 8'd1;    // Root
        tree[1] = 8'd2;    // Left child of Root
        tree[2] = 8'd3;    // Right child of Root
        tree[3] = 8'd4;    // Left child of Node 2
        tree[4] = 8'd5;    // Right child of Node 2
        tree[5] = 8'd6;    // Left child of Node 3
        tree[6] = 8'd7;    // Right child of Node 3
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            node_value <= 8'd0; // Reset output
        end else begin
            if (index < 7)
                node_value <= tree[index]; // Output the value of the current index
            else
                node_value <= 8'd0; // Out of bounds
        end
    end
endmodule