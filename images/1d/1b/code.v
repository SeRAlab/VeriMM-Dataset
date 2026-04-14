module memory_allocator (
    input wire clk,
    input wire reset,
    input wire [7:0] request_size, // Size requested for allocation
    input wire malloc_req,          // Request to allocate memory
    input wire free_req,            // Request to free memory
    input wire [7:0] block_id,      // ID of the block to free
    output reg [15:0] status,       // Status of the operation (0: success, 1: failure)
    output reg [7:0] allocated_id    // ID of the allocated block
);
    reg [7:0] memory_pool [0:255]; // Memory pool of 256 bytes
    reg [7:0] free_list [0:255];    // Free list to track free blocks
    reg [7:0] free_count;

    initial begin
        free_count = 256; // Start with a full memory pool
        allocated_id = 0;
        status = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            free_count <= 256;
            allocated_id <= 0;
            status <= 0;
        end else begin
            if (malloc_req) begin
                if (request_size <= free_count) begin
                    allocated_id <= allocated_id + 1; // Assign a new block ID
                    // Allocate memory (simplified)
                    free_count <= free_count - request_size; // Decrement free count
                    status <= 0; // Success
                end else begin
                    status <= 1; // Failure: not enough memory
                end
            end else if (free_req) begin
                free_count <= free_count + request_size; // Simulate freeing memory
                status <= 0; // Success
            end
        end
    end
endmodule