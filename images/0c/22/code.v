module MemoryAllocator(
    input clk,
    input rst,
    input [31:0] alloc_size,
    input alloc_req,
    input free_req,
    output reg [31:0] allocated_memory,
    output reg [31:0] total_memory,
    output reg [31:0] free_memory
);
    parameter MAX_MEMORY = 1024; // Maximum memory
    reg [31:0] current_memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_memory <= 0;
            allocated_memory <= 0;
            total_memory <= MAX_MEMORY;
            free_memory <= MAX_MEMORY;
        end else begin
            if (alloc_req && (current_memory + alloc_size <= MAX_MEMORY)) begin
                current_memory <= current_memory + alloc_size;
                allocated_memory <= current_memory;
                free_memory <= free_memory - alloc_size;
            end
            if (free_req && current_memory >= alloc_size) begin
                current_memory <= current_memory - alloc_size;
                allocated_memory <= current_memory;
                free_memory <= free_memory + alloc_size;
            end
        end
    end
endmodule