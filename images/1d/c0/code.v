module memory_allocator #(parameter MEMORY_SIZE = 32, parameter BLOCK_SIZE = 4) (
    input wire clk,
    input wire reset,
    input wire [3:0] request_size, // Size in terms of BLOCKS
    input wire free,
    output reg [4:0] allocated_address, // Address of allocated memory
    output reg allocation_success // 1 if allocation is successful, 0 otherwise
);

    reg [BLOCK_SIZE-1:0] memory [0:MEMORY_SIZE-1]; // Memory array
    reg [4:0] free_list [0:MEMORY_SIZE-1]; // Free list of memory blocks
    reg [4:0] next_free = 0; // Pointer to the next free block

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            allocated_address <= 5'b0;
            allocation_success <= 1'b0;
            next_free <= 0;
        end else if (free) begin
            // Free the last allocated block
            if (allocated_address < MEMORY_SIZE) begin
                free_list[next_free] <= allocated_address;
                next_free <= next_free + 1;
                allocation_success <= 1'b0; // Reset allocation success
            end
        end else if (request_size > 0) begin
            // Try to allocate memory
            if (next_free + request_size <= MEMORY_SIZE) begin
                allocated_address <= next_free;
                allocation_success <= 1'b1;
                next_free <= next_free + request_size; // Update next free block
            end else begin
                allocated_address <= 5'b0; // Indicate failure
                allocation_success <= 1'b0; // Allocation failed
            end
        end
    end
endmodule