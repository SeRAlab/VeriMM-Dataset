module memory_allocator #(parameter MEM_SIZE = 16) (
    input wire clk,
    input wire rst,
    input wire malloc_req,
    input wire [3:0] malloc_size, // size in bytes (1 to 15)
    input wire free_req,
    input wire [3:0] free_address, // address to free
    output reg [3:0] allocated_address,
    output reg alloc_success,
    output reg free_success
);
    reg [1:0] mem_pool [0:MEM_SIZE-1]; // Memory pool of 16 bytes
    reg [3:0] free_ptr; // Pointer to track free memory

    initial begin
        free_ptr = 0;
        alloc_success = 0;
        free_success = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            free_ptr <= 0;
            alloc_success <= 0;
            free_success <= 0;
        end else begin
            alloc_success <= 0;
            free_success <= 0;

            // malloc operation
            if (malloc_req && (free_ptr + malloc_size <= MEM_SIZE)) begin
                allocated_address <= free_ptr;
                free_ptr <= free_ptr + malloc_size;
                alloc_success <= 1;
            end

            // free operation
            if (free_req && (free_address < MEM_SIZE)) begin
                // Simplified free operation - just reset the free pointer (not real deallocation)
                free_ptr <= free_address; 
                free_success <= 1;
            end
        end
    end
endmodule