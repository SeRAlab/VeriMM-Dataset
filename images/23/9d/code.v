module MemoryAllocator (
    input wire clk,
    input wire reset,
    input wire alloc,          // Request to allocate memory
    input wire free,          // Request to free memory
    input wire [1:0] block_id,// Block ID (0 to 3)
    output reg [3:0] status   // Status of each memory block (4 bits)
);

    reg [3:0] memory; // 4 memory blocks, 0 = free, 1 = allocated

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000; // All blocks free on reset
            status <= 4'b0000;
        end else begin
            if (alloc && (memory[block_id] == 1'b0)) begin
                memory[block_id] <= 1'b1; // Allocate memory
            end
            if (free && (memory[block_id] == 1'b1)) begin
                memory[block_id] <= 1'b0; // Free memory
            end
            status <= memory; // Output status
        end
    end
endmodule