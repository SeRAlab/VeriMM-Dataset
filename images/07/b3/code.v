module MemoryAllocator (
    input wire clk,
    input wire rst,
    input wire [7:0] req_size,
    input wire allocate,
    input wire free,
    output reg [15:0] address,
    output reg success
);
    reg [15:0] mem [0:255]; // Array to simulate memory blocks
    reg [15:0] next_address;
    
    initial begin
        next_address = 0;
        success = 0;
        address = 16'hFFFF; // Invalid address
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_address <= 0;
            success <= 0;
            address <= 16'hFFFF;
        end else begin
            if (allocate) begin
                if (next_address + req_size <= 256) begin
                    address <= next_address;
                    next_address <= next_address + req_size;
                    success <= 1;
                end else begin
                    address <= 16'hFFFF; // Allocation failed
                    success <= 0;
                end
            end else if (free) begin
                // For simplicity, we do not implement actual freeing of memory
                // In a real scenario, a free list or similar structure would be needed
                success <= 1; // Assume free is always successful
            end
        end
    end
endmodule