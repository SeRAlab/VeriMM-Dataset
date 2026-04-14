module sram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire CLK,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        Q <= memory; // Always output the stored data
    end
endmodule