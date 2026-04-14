module linked_list_traversal (
    input clk,
    input reset,
    input [31:0] node_data,
    input node_valid,
    output reg [31:0] node_count
);
    reg [31:0] current_node;
    reg [31:0] next_node;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            node_count <= 0;
            current_node <= 0;
        end else if (node_valid) begin
            current_node <= node_data;
            node_count <= node_count + 1;
        end
    end
endmodule