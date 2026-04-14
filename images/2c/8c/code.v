module memory_allocator(
    input clk,
    input reset,
    input request,
    input [3:0] size,
    input free, // 1 for free, 0 for allocate
    output reg allocated
);
    reg [3:0] total_memory = 16; // Total memory available
    reg [3:0] allocated_memory = 0; // Currently allocated memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            allocated_memory <= 0;
            allocated <= 0;
        end else begin
            if (request) begin
                if (~free) begin // Allocate memory
                    if (allocated_memory + size <= total_memory) begin
                        allocated_memory <= allocated_memory + size;
                        allocated <= 1; // Allocation successful
                    end else begin
                        allocated <= 0; // Not enough memory
                    end
                end else begin // Free memory
                    if (allocated_memory >= size) begin
                        allocated_memory <= allocated_memory - size;
                        allocated <= 1; // Free successful
                    end else begin
                        allocated <= 0; // Not enough memory to free
                    end
                end
            end
        end
    end
endmodule