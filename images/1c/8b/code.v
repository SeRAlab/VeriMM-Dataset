module linked_list_traversal (
    input clk,
    input rst,
    input [4:0] head,
    input start_traversal,
    output reg [4:0] current_value
);
    reg [4:0] nodes[0:4]; // Array of linked list nodes (5 nodes for simplicity)
    reg [2:0] index;

    // Initialize the linked list nodes
    initial begin
        nodes[0] = 5'd1; // Node 0
        nodes[1] = 5'd2; // Node 1
        nodes[2] = 5'd3; // Node 2
        nodes[3] = 5'd4; // Node 3
        nodes[4] = 5'd5; // Node 4
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            index <= 3'd0; // Reset the index
            current_value <= 5'd0; // Reset the current value
        end else if (start_traversal) begin
            if (index < 3'd5) begin
                current_value <= nodes[index]; // Output current node value
                index <= index + 3'd1; // Move to the next node
            end
        end
    end
endmodule