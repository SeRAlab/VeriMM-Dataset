module linked_list_traversal(
    input clk,
    input reset,
    output reg [3:0] data_out,
    output reg done
);
    // Define node structure
    reg [3:0] data [0:4]; // 5 nodes with 4-bit data
    reg [2:0] next [0:4]; // Pointers to next nodes
    reg [2:0] current;

    // Initialize linked list
    initial begin
        data[0] = 4'b0001; next[0] = 3'b001; // Node 0
        data[1] = 4'b0010; next[1] = 3'b010; // Node 1
        data[2] = 4'b0011; next[2] = 3'b011; // Node 2
        data[3] = 4'b0100; next[3] = 3'b100; // Node 3
        data[4] = 4'b0101; next[4] = 3'b000; // Node 4 (points back to head)
    end

    // Sequential logic for traversal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current <= 3'b000; // Start from head
            done <= 0;
        end
        else if (current < 3'b101) begin // while current < 5
            data_out <= data[current]; // Output current node data
            current <= next[current]; // Move to the next node
            done <= (current == 3'b000); // Check if loop is completed
        end
        else begin
            done <= 1; // Done when current >= 5
        end
    end
endmodule