module linked_list_traversal (
    input clk,
    input reset,
    input [7:0] node_data,
    input [7:0] next_node_address,
    output reg [7:0] current_data,
    output reg [7:0] next_address
);

    reg [7:0] current_node;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_data <= 8'b0;
            next_address <= 8'b0;
            current_node <= 8'b0;
        end else begin
            current_data <= node_data;
            next_address <= next_node_address;
            current_node <= next_node_address; // Move to the next node
        end
    end
endmodule