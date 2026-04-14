module linked_list_traversal(
    input clk,
    input reset,
    input [4:0] list_data, // Data for 5 nodes [0:4]
    input [4:0] next_ptr,   // Pointer to next node [0:4]
    output reg [0:0] current_data // Current node data output
);
    reg [2:0] current_node; // 3 bits to address 5 nodes (0 to 4)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 3'b000; // Start at first node
            current_data <= 1'b0;    // Initialize output
        end else begin
            current_data <= list_data[current_node]; // Output current node's data
            if (next_ptr[current_node]) begin
                current_node <= current_node + 1; // Move to next node
            end
        end
    end
endmodule