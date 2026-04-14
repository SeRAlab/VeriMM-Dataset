module memory_management (
    input clk,
    input rst,
    input malloc_req,
    input free_req,
    input [3:0] mem_id, // Unique identifier for memory block (0-15)
    output reg [3:0] allocated_id, // ID of allocated block
    output reg alloc_success, // Allocation success flag
    output reg free_success // Free success flag
);
    parameter MAX_MEM_BLOCKS = 4;
    reg [3:0] mem_pool [0:MAX_MEM_BLOCKS-1]; // Memory pool
    reg [1:0] head; // Pointer for FIFO queue
    reg [1:0] tail; // Pointer for FIFO queue
    reg [MAX_MEM_BLOCKS-1:0] allocated; // Allocation status

    // Initialize memory and flags
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            alloc_success <= 0;
            free_success <= 0;
            allocated_id <= 0;
            for (i = 0; i < MAX_MEM_BLOCKS; i = i + 1) begin
                allocated[i] <= 0; // All blocks free
            end
        end else begin
            // Handle malloc request
            if (malloc_req) begin
                if (tail - head < MAX_MEM_BLOCKS) begin
                    mem_pool[tail % MAX_MEM_BLOCKS] <= mem_id;
                    allocated[mem_id] <= 1; // Mark as allocated
                    allocated_id <= mem_id;
                    alloc_success <= 1;
                    tail <= tail + 1;
                end else begin
                    alloc_success <= 0; // Allocation failed
                end
            end else begin
                alloc_success <= 0; // Reset allocation success
            end

            // Handle free request
            if (free_req) begin
                if (allocated[mem_id]) begin
                    allocated[mem_id] <= 0; // Mark as free
                    free_success <= 1;
                    head <= head + 1; // Move head for FIFO
                end else begin
                    free_success <= 0; // Free failed, not allocated
                end
            end else begin
                free_success <= 0; // Reset free success
            end
        end
    end
endmodule