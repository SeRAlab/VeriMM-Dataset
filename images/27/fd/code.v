module flash_memory_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [1:0] addr,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4 memory cells of 4 bits each

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear the memory on reset
            memory[0] <= 4'b0000;
            memory[1] <= 4'b0000;
            memory[2] <= 4'b0000;
            memory[3] <= 4'b0000;
            data_out <= 4'b0000; // Clear output
        end else if (enable) begin
            // Write data to memory
            memory[addr] <= data_in;
            // Read data from memory
            data_out <= memory[addr];
        end
    end
endmodule