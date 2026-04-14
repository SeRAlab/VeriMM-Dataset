module memory_allocator (
    input clk,
    input rst,
    input [3:0] alloc_req, // Memory slot request (0-15)
    input free_req,        // Signal to free the allocated slot
    output reg [15:0] mem_status // Status of memory slots (1: occupied, 0: free)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_status <= 16'b0000000000000000; // All slots are free
        end else if (free_req) begin
            mem_status[alloc_req] <= 1'b0; // Free the requested slot
        end else begin
            mem_status[alloc_req] <= 1'b1; // Allocate the requested slot
        end
    end
endmodule