module MemoryAllocator(
    input clk,
    input rst,
    input [3:0] alloc_request,  // Requesting allocation of a slot (1 to 15)
    input [3:0] free_slot,      // Slot to free (0 to 15)
    output reg [15:0] memory    // Memory status (1 = allocated, 0 = free)
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 16'b0000000000000000; // All slots free on reset
        end else begin
            // Allocate memory
            if (alloc_request >= 1 && alloc_request <= 15) begin
                memory[alloc_request] <= 1; // Mark as allocated
            end
            // Free memory
            if (free_slot >= 0 && free_slot <= 15) begin
                memory[free_slot] <= 0; // Mark as free
            end
        end
    end
endmodule