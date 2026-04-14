module linked_list_traversal(
    input clk,
    input reset,
    input start,
    output reg [7:0] current_value,
    output reg done
);
    // Define the linked list structure
    reg [7:0] data [0:4]; // 5 nodes with 8-bit data
    reg [2:0] next [0:4]; // next pointer (index of the next node)
    reg [2:0] current_node; // current node index
    reg traversing; // state of traversal

    initial begin
        // Initialize linked list data
        data[0] = 8'h01; // Node 1
        data[1] = 8'h02; // Node 2
        data[2] = 8'h03; // Node 3
        data[3] = 8'h04; // Node 4
        data[4] = 8'h05; // Node 5
        // Initialize next pointers
        next[0] = 3'b001; // Node 1 points to Node 2
        next[1] = 3'b010; // Node 2 points to Node 3
        next[2] = 3'b011; // Node 3 points to Node 4
        next[3] = 3'b100; // Node 4 points to Node 5
        next[4] = 3'b000; // Node 5 points to NULL (end of list)
        current_node = 3'b000; // Start at the first node
        done = 0; // Traversal is not done
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 3'b000; // Reset to the first node
            current_value <= 0;
            done <= 0;
            traversing <= 0;
        end else if (start) begin
            traversing <= 1; // Start traversal
        end else if (traversing) begin
            current_value <= data[current_node]; // Output current node's data
            if (next[current_node] == 3'b000) begin
                done <= 1; // End of traversal
                traversing <= 0; // Stop traversing
            end else begin
                current_node <= next[current_node]; // Move to the next node
            end
        end
    end
endmodule