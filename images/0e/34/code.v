module LinkedListTraversal(
    input clk,
    input rst,
    input [7:0] start_addr, // Start address of the linked list
    output reg [7:0] data_out, // Output data from the current node
    output reg done // Signal to indicate traversal is complete
);
    reg [7:0] memory [0:255]; // Memory for linked list storage
    reg [7:0] current_addr; // Current node address
    
    initial begin
        // Initializing memory with some test values and next pointers
        memory[0] = 8'hA1; // Node 0
        memory[1] = 8'hA2; // Node 1
        memory[2] = 8'hA3; // Node 2
        memory[3] = 8'h00; // End of list (null pointer)
        // Example next pointers (0->1->2->0)
        memory[0] = 8'h01; // Next of Node 0 points to Node 1
        memory[1] = 8'h02; // Next of Node 1 points to Node 2
        memory[2] = 8'h00; // Next of Node 2 is null
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_addr <= start_addr;
            data_out <= 8'h00;
            done <= 1'b0;
        end else if (current_addr != 8'h00) begin
            data_out <= memory[current_addr];
            current_addr <= memory[current_addr + 1]; // Move to the next node
        end else begin
            done <= 1'b1; // Mark traversal as complete
        end
    end
endmodule