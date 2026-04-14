module SRAM_16bit (
    input wire [3:0] ADDR,       // 4-bit address input (16 locations)
    input wire [15:0] DATA_IN,   // 16-bit data input
    input wire WE,               // Write enable
    input wire CLK,              // Clock signal
    output reg [15:0] DATA_OUT   // 16-bit data output
);

    reg [15:0] memory [0:15];     // 16 x 16-bit memory array

    always @(posedge CLK) begin
        if (WE) begin
            memory[ADDR] <= DATA_IN; // Write data
        end else begin
            DATA_OUT <= memory[ADDR]; // Read data
        end
    end
endmodule