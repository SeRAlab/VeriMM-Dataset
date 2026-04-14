module MemoryAllocator(
    input clk,
    input rst,
    input [7:0] request_size, // Request size (in bytes)
    input req_type, // 0 for allocate, 1 for free
    output reg [7:0] allocated_memory, // Total allocated memory
    output reg [7:0] free_memory // Total free memory
);
    reg [7:0] total_memory = 256; // Total memory available
    reg [7:0] used_memory = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            allocated_memory <= 0;
            free_memory <= total_memory;
            used_memory <= 0;
        end else begin
            if (req_type == 0) begin // Allocate
                if (used_memory + request_size <= total_memory) begin
                    used_memory <= used_memory + request_size;
                end
            end else if (req_type == 1) begin // Free
                if (used_memory >= request_size) begin
                    used_memory <= used_memory - request_size;
                end
            end
            
            allocated_memory <= used_memory;
            free_memory <= total_memory - used_memory;
        end
    end
endmodule