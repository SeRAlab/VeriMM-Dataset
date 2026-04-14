module memory_manager (
    input wire clk,
    input wire reset,
    input wire malloc,
    input wire free,
    output reg [3:0] allocated_blocks // Number of allocated blocks (0-15)
);

    reg [3:0] memory; // 4-bit register to represent memory blocks (0-15 valid)
    localparam MAX_BLOCKS = 4'b1111; // Total 16 blocks

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000; // Reset memory allocation
            allocated_blocks <= 4'b0000;
        end else begin
            if (malloc && (allocated_blocks < MAX_BLOCKS)) begin
                allocated_blocks <= allocated_blocks + 1; // Allocate a block
                memory[allocated_blocks] <= 1; // Mark the block as allocated
            end else if (free && (allocated_blocks > 0)) begin
                allocated_blocks <= allocated_blocks - 1; // Free a block
                memory[allocated_blocks] <= 0; // Mark the block as free
            end
        end
    end
endmodule