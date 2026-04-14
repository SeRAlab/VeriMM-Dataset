module memory_allocator (
    input wire clk,
    input wire reset,
    input wire [2:0] req_size, // Request size (1 to 7)
    input wire allocate,        // Allocate signal
    input wire free,           // Free signal
    output reg success,        // Success flag
    output reg [7:0] memory   // Memory status (1 = allocated, 0 = free)
);

    initial begin
        memory = 8'b00000000; // All memory blocks are free initially
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b00000000; // Reset memory to free
            success <= 0;
        end else begin
            if (allocate) begin
                if (memory[req_size] == 0) begin
                    memory[req_size] <= 1; // Allocate memory
                    success <= 1;
                end else begin
                    success <= 0; // Allocation failed
                end
            end else if (free) begin
                if (memory[req_size] == 1) begin
                    memory[req_size] <= 0; // Free memory
                    success <= 1;
                end else begin
                    success <= 0; // Free failed
                end
            end
        end
    end
endmodule