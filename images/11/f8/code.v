module linked_list_traversal (
    input clk,
    input reset,
    input [7:0] node_value,
    output reg [7:0] current_value
);
    reg [7:0] linked_list [0:4]; // A linked list with 5 nodes
    reg [2:0] index; // Index to traverse the linked list

    // Initialize linked list during reset
    always @(posedge reset) begin
        linked_list[0] <= 8'd1;
        linked_list[1] <= 8'd2;
        linked_list[2] <= 8'd3;
        linked_list[3] <= 8'd4;
        linked_list[4] <= 8'd5;
        index <= 3'd0;
    end

    // Traverse the linked list on each clock pulse
    always @(posedge clk) begin
        if (index < 5) begin
            current_value <= linked_list[index];
            index <= index + 1;
        end
    end
endmodule