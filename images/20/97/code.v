module linked_list_traversal(
    input clk,
    input rst,
    input traverse,
    output reg [7:0] current_value
);
    reg [7:0] list [0:4]; // Linked list of 5 nodes
    reg [2:0] current_node; // Pointer to the current node

    initial begin
        // Initialize the linked list values
        list[0] = 8'd10; 
        list[1] = 8'd20; 
        list[2] = 8'd30; 
        list[3] = 8'd40; 
        list[4] = 8'd50; 
        current_node = 3'd0; // Start at first node
        current_value = 8'd0; // Initial output value
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_node <= 3'd0; // Reset to first node
            current_value <= 8'd0; // Reset output value
        end else if (traverse) begin
            if (current_node < 3'd4) begin
                current_node <= current_node + 1; // Move to the next node
            end
            current_value <= list[current_node]; // Output current node value
        end
    end
endmodule