module linked_list_traversal(
    input clk,
    input [7:0] node_value,
    input [7:0] next_node, // 0 indicates null
    output reg [7:0] current_value
);
    reg [7:0] current_node;

    always @(posedge clk) begin
        if (current_node == 0) begin
            current_node <= node_value; // Start traversal
        end else if (next_node != 0) begin
            current_value <= current_node;
            current_node <= next_node; // Move to next node
        end else begin
            current_value <= current_node; // Last node
        end
    end
endmodule