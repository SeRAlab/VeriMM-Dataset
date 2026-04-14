module memory_allocator (
    input wire [3:0] request_size, // Size of the request (0-15)
    input wire allocate,            // Signal to allocate memory
    input wire free,               // Signal to free memory
    output reg success              // Allocation success flag
);

    reg [15:0] memory; // Simple memory simulation (16 bits)

    always @(*) begin
        success = 0; // Default success is 'false'

        if (allocate) begin
            // Check if the requested size is available
            if (memory[request_size] == 0) begin
                memory[request_size] = 1; // Mark as allocated
                success = 1; // Allocation successful
            end
        end else if (free) begin
            // Free the allocated memory block
            if (memory[request_size] == 1) begin
                memory[request_size] = 0; // Mark as free
                success = 1; // Free successful
            end
        end
    end
endmodule