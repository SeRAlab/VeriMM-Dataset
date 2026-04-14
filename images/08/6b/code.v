module linked_list_traversal(
    input clk,
    input rst,
    input [7:0] node_data,
    input [7:0] next_node,
    output reg [7:0] current_data
);
    reg [7:0] current_node;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_node <= 8'b0;
            current_data <= 8'b0;
        end else begin
            current_node <= next_node;
            current_data <= node_data;
        end
    end
endmodule