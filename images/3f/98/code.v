module memory_allocator (
    input clk,
    input reset,
    input alloc_req,
    input [2:0] alloc_size,
    input free_req,
    output reg alloc_success,
    output reg [7:0] allocated_mem
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alloc_success <= 0;
            allocated_mem <= 8'b0;
        end else if (alloc_req && !alloc_success) begin
            if (alloc_size > 0 && alloc_size <= 7) begin
                allocated_mem <= (1 << alloc_size) - 1; // Allocate memory
                alloc_success <= 1; // Success
            end
        end else if (free_req && alloc_success) begin
            allocated_mem <= 8'b0; // Free memory
            alloc_success <= 0; // Reset success
        end
    end
endmodule