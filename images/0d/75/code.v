module rrt_node_manager (
    input clk,
    input reset,
    input [7:0] new_x,
    input [7:0] new_y,
    input add_node,
    input traverse,
    output reg [7:0] current_x,
    output reg [7:0] current_y,
    output reg [7:0] node_count
);
    reg [7:0] nodes_x [0:255];
    reg [7:0] nodes_y [0:255];
    reg [7:0] idx;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            idx <= 0;
            node_count <= 0;
            current_x <= 0;
            current_y <= 0;
        end else begin
            if (add_node && node_count < 256) begin
                nodes_x[node_count] <= new_x;
                nodes_y[node_count] <= new_y;
                node_count <= node_count + 1;
            end
            if (traverse) begin
                current_x <= nodes_x[idx];
                current_y <= nodes_y[idx];
                idx <= (idx + 1) % node_count; // Cycle through nodes
            end
        end
    end
endmodule