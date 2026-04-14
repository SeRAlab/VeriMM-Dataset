module memory_allocator(
    input clk,
    input rst,
    input [3:0] request_size, // size of memory block requested
    input allocate, // allocate signal
    input free, // free signal
    input [3:0] free_size, // size of memory block to free
    output reg [15:0] allocated_memory // current allocated memory state
);
    reg [15:0] memory_pool [0:15]; // memory pool, 16 16-bit blocks
    reg [3:0] block_count; // current number of allocated blocks

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            allocated_memory <= 16'b0;
            block_count <= 4'b0;
        end else if (allocate) begin
            if (block_count < 16 && request_size <= 16) begin
                allocated_memory <= allocated_memory | (1 << block_count); // allocate block
                block_count <= block_count + 1;
            end
        end else if (free) begin
            if (block_count > 0 && free_size < block_count) begin
                allocated_memory <= allocated_memory & ~(1 << free_size); // free block
                block_count <= block_count - 1;
            end
        end
    end
endmodule