module MemoryAllocator(
    input wire clk,
    input wire reset,
    input wire req,
    input wire [3:0] addr,
    output reg allocated,
    output reg [15:0] mem
);
    reg [3:0] free_blocks [0:3]; // Simulating 4 blocks of memory
    reg [3:0] head; // Head pointer for free list
    integer i;
    
    initial begin
        head = 0;
        mem = 16'h0000; // All blocks free initially
        for (i = 0; i < 4; i = i + 1) begin
            free_blocks[i] = i; // Initialize free blocks
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem <= 16'h0000;
            head <= 0;
            allocated <= 0;
        end else begin
            if (req) begin // malloc
                if (head < 4) begin
                    mem[free_blocks[head]] <= addr; // Allocate memory
                    allocated <= 1;
                    head <= head + 1; // Move to next free block
                end else begin
                    allocated <= 0; // No more memory available
                end
            end else begin // free
                if (addr < 4) begin
                    mem[addr] <= 1'b0; // Free memory
                    allocated <= 1;
                    head <= head - 1; // Move to previous free block
                end else begin
                    allocated <= 0; // Invalid free operation
                end
            end
        end
    end
endmodule