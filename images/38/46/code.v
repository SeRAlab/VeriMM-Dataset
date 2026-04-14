module memory_allocator (
    input wire clk,
    input wire alloc,
    input wire free,
    input wire [2:0] addr,
    output reg [3:0] data_out,
    output reg allocated
);
    reg [3:0] memory [0:7]; // Array of 8 blocks, each 4 bits
    reg [7:0] alloc_status; // Status of each block (allocated or free)

    always @(posedge clk) begin
        if (alloc) begin
            if (!alloc_status[addr]) begin
                memory[addr] <= addr; // Store the address as the data
                alloc_status[addr] <= 1; // Mark as allocated
                allocated <= 1; // Allocation successful
            end else begin
                allocated <= 0; // Allocation failed, already allocated
            end
        end else if (free) begin
            if (alloc_status[addr]) begin
                alloc_status[addr] <= 0; // Mark as free
                allocated <= 1; // Freeing successful
            end else begin
                allocated <= 0; // Freeing failed, already free
            end
        end
        data_out <= memory[addr]; // Output the data of the specified block
    end
endmodule