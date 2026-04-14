module memory_allocator(
    input clk,
    input rst,
    input [2:0] req_size, // Request for block size (1-5)
    input alloc,          // Request to allocate memory
    input free,          // Request to free memory
    output reg [4:0] memory_status, // Memory status (1: allocated, 0: free)
    output reg alloc_success // Allocation success flag
);
    reg [4:0] mem_block; // Memory blocks representation (5 blocks)
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_block <= 5'b00000;
            alloc_success <= 0;
        end else begin
            if (alloc) begin
                if (mem_block[req_size-1] == 0) begin // Check if the block is free
                    mem_block[req_size-1] <= 1; // Allocate memory
                    alloc_success <= 1; // Set success flag
                end else begin
                    alloc_success <= 0; // Already allocated
                end
            end else if (free) begin
                mem_block[req_size-1] <= 0; // Free memory
                alloc_success <= 0; // Clear success flag
            end
            memory_status <= mem_block; // Update output memory status
        end
    end
endmodule