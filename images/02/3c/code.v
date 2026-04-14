module memory_allocator(
    input wire clk,
    input wire reset,
    input wire [7:0] alloc_size, // Size to allocate
    input wire [7:0] free_size, // Size to free
    input wire alloc_req, // Allocate request signal
    input wire free_req, // Free request signal
    output reg [7:0] allocated_memory // Size of allocated memory
);

    reg [7:0] memory [0:255]; // Simple memory array
    reg [7:0] alloc_index; // Index for allocated memory

    initial begin
        alloc_index = 0;
        allocated_memory = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alloc_index <= 0;
            allocated_memory <= 0;
        end else begin
            if (alloc_req && (alloc_index + alloc_size < 256)) begin
                allocated_memory <= alloc_size;
                alloc_index <= alloc_index + alloc_size;
                memory[alloc_index] <= alloc_size; // Store allocated size
            end else if (free_req && (alloc_index >= free_size)) begin
                allocated_memory <= 0;
                alloc_index <= alloc_index - free_size;
            end
        end
    end
endmodule