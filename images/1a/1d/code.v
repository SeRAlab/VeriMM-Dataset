module memory_allocator (
    input wire clk,
    input wire rst,
    input wire alloc,
    input wire free,
    input wire [2:0] block_id,
    output reg allocated,
    output reg freed
);
    reg [7:0] memory_blocks; // 8-bit memory to represent 8 blocks

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory_blocks <= 8'b00000000; // Initialize all blocks to free
            allocated <= 0;
            freed <= 0;
        end else begin
            if (alloc) begin
                if (memory_blocks[block_id] == 0) begin
                    memory_blocks[block_id] <= 1; // Allocate the block
                    allocated <= 1;
                end else begin
                    allocated <= 0; // Block already allocated
                end
            end else begin
                allocated <= 0; // Reset allocation signal
            end

            if (free) begin
                if (memory_blocks[block_id] == 1) begin
                    memory_blocks[block_id] <= 0; // Free the block
                    freed <= 1;
                end else begin
                    freed <= 0; // Block already free
                end
            end else begin
                freed <= 0; // Reset free signal
            end
        end
    end
endmodule