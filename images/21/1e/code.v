module memory_allocator (
    input wire clk,
    input wire reset,
    input wire allocate,     // signal to allocate memory
    input wire free,        // signal to free memory
    input wire [2:0] index, // index to allocate/free
    output reg [2:0] allocated_index, // index of allocated memory
    output reg error        // allocation error signal
);
    reg [4:0] memory; // 5 blocks of memory, 1 bit each

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 5'b00000;
            allocated_index <= 3'b000;
            error <= 1'b0;
        end else begin
            if (allocate) begin
                if (memory[index] == 1'b0) begin
                    memory[index] <= 1'b1; // allocate memory
                    allocated_index <= index;
                    error <= 1'b0;
                end else begin
                    error <= 1'b1; // allocation failed
                end
            end else if (free) begin
                if (memory[index] == 1'b1) begin
                    memory[index] <= 1'b0; // free memory
                    allocated_index <= 3'b000; // reset allocated index
                    error <= 1'b0;
                end else begin
                    error <= 1'b1; // free failed
                end
            end
        end
    end
endmodule