module SRAM (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire [3:0] addr,
    input wire [15:0] D_in,
    output reg [15:0] D_out
);
    reg [15:0] memory [15:0]; // 16 × 16-bit memory

    always @(posedge clk) begin
        if (WE) begin
            memory[addr] <= D_in; // Write data to memory
        end
        if (RE) begin
            D_out <= memory[addr]; // Read data from memory
        end
    end
endmodule