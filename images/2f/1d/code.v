module sram_cell(
    input wire clk,
    input wire WE,        // Write Enable
    input wire RE,        // Read Enable
    input wire [2:0] A,   // Address
    input wire [7:0] D,   // Data input
    output reg [7:0] Q    // Data output
);
    reg [7:0] memory [0:7]; // 8 SRAM cells

    always @(posedge clk) begin
        if (WE) begin
            memory[A] <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory[A]; // Read data from memory
        end
    end
endmodule