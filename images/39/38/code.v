module memory_allocator (
    input wire clk,
    input wire reset,
    input wire [3:0] request,
    input wire allocate, // 1 for allocate, 0 for free
    output reg success // 1 for success, 0 for failure
);
    reg [4:0] memory [0:15]; // 16 memory blocks, each 5 bits (for 1-bit allocation)
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                memory[i] = 0; // Initialize memory blocks to free
            end
            success <= 0;
        end else begin
            if (allocate) begin
                if (memory[request] == 0) begin
                    memory[request] = 1; // Allocate memory
                    success <= 1; // Allocation successful
                end else begin
                    success <= 0; // Allocation failed, already allocated
                end
            end else begin
                if (memory[request] == 1) begin
                    memory[request] = 0; // Free memory
                    success <= 1; // Free successful
                end else begin
                    success <= 0; // Free failed, already free
                end
            end
        end
    end
endmodule