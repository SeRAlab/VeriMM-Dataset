module linked_list_traversal (
    input clk,
    input reset,
    input [31:0] node_value, // Value at the current node
    input [31:0] next_node,  // Address/identifier of the next node
    output reg [31:0] out_value, // Output value of the current node
    output reg done // Indicates traversal completion
);

    reg [31:0] current_node;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 0;
            out_value <= 0;
            done <= 0;
        end else if (current_node == 0) begin
            current_node <= node_value; // Start traversal
            out_value <= current_node;
            done <= 0;
        end else if (next_node != 0) begin
            current_node <= next_node; // Move to the next node
            out_value <= current_node;
            done <= 0;
        end else begin
            done <= 1; // End of the list
        end
    end
endmodule