module memory_allocator(
    input wire clk,
    input wire rst,
    input wire allocate, // Request to allocate memory
    input wire free,     // Request to free memory
    output reg [4:0] memory_blocks // 5 bits to represent 5 memory blocks
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory_blocks <= 5'b00000; // Initialize all blocks to free
        end else begin
            if (allocate) begin
                // Allocate memory block
                if (memory_blocks != 5'b11111) begin
                    memory_blocks <= memory_blocks + 1'b1; // Allocate one block
                end
            end else if (free) begin
                // Free memory block
                if (memory_blocks != 5'b00000) begin
                    memory_blocks <= memory_blocks - 1'b1; // Free one block
                end
            end
        end
    end
endmodule