module sram_cell (
    input wire [7:0] D,
    output reg [7:0] Q,
    input wire WE,
    input wire CLK
);
    reg [7:0] memory; // 8-bit memory cell

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        Q <= memory; // Read data from memory
    end
endmodule