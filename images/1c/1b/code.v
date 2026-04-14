module memory_allocator (
    input wire clk,
    input wire reset,
    input wire alloc_req,
    input wire free_req,
    input wire [3:0] block_id,
    output reg alloc_granted,
    output reg free_granted,
    output reg error
);
    parameter NUM_BLOCKS = 16;

    reg [NUM_BLOCKS-1:0] mem_pool; // Memory pool tracking
    reg [NUM_BLOCKS-1:0] allocated; // Allocated blocks tracker

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_pool <= {NUM_BLOCKS{1'b1}}; // All blocks are free
            allocated <= {NUM_BLOCKS{1'b0}}; // No blocks allocated
            alloc_granted <= 1'b0;
            free_granted <= 1'b0;
            error <= 1'b0;
        end else begin
            alloc_granted <= 1'b0;
            free_granted <= 1'b0;
            error <= 1'b0;

            // Allocation request
            if (alloc_req) begin
                if (mem_pool[block_id]) begin
                    mem_pool[block_id] <= 1'b0; // Mark block as allocated
                    allocated[block_id] <= 1'b1; // Track allocation
                    alloc_granted <= 1'b1; // Grant allocation
                end else begin
                    error <= 1'b1; // Allocation failed, block already allocated
                end
            end

            // Free request
            if (free_req) begin
                if (allocated[block_id]) begin
                    mem_pool[block_id] <= 1'b1; // Mark block as free
                    allocated[block_id] <= 1'b0; // Track free
                    free_granted <= 1'b1; // Grant free
                end else begin
                    error <= 1'b1; // Free failed, block not allocated
                end
            end
        end
    end
endmodule